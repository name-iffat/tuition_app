import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/widgets/custom_text_field.dart';
import 'package:tuition_app/widgets/error_dialog.dart';
import 'package:tuition_app/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key,required this.userType});
  final String userType;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMark;

  String parentImageUrl = "";
  String completeAddress ="";
  String locality = "";

  Future<void> _getImage() async
  {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState((){
      imageXFile;
    });
  }
  LocationPermission? permission;

  getCurrentLocation() async
  {
    permission = await Geolocator.requestPermission();
    Position newPosition =  await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMark = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMark![0];

    completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    locality = pMark.locality.toString();
    locationController.text = completeAddress;
    print(locationController);
  }

  Future<void> formValidation() async {
    if(imageXFile == null){
      showDialog(
        context: context,
        builder: (c){
          return ErrorDialog(
            message: "Please select an image.",
          );
        }
      );
    }
    else{
      if(passwordController.text == confirmPasswordController.text)
        {
          if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
          {
            //start uploading image
            showDialog(
              context: context,
              builder: (c)
                {
                  return LoadingDialog(
                    message: "Registering Account. ",
                  );
                }
            );

            String fileName = DateTime.now().millisecondsSinceEpoch.toString();
            if(widget.userType == "Parent") {
              fStorage.Reference reference = fStorage.FirebaseStorage.instance
                  .ref().child("parents").child(fileName);
              fStorage.UploadTask uploadTask = reference.putFile(
                  File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot = await uploadTask
                  .whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url) {
                parentImageUrl = url;

                //save info to firestore
                authenticateParentAndSignUp();
              });
            }
            else if(widget.userType == "Tutor") {
              fStorage.Reference reference = fStorage.FirebaseStorage.instance
                  .ref().child("tutors").child(fileName);
              fStorage.UploadTask uploadTask = reference.putFile(
                  File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot = await uploadTask
                  .whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url) {
                parentImageUrl = url;

                //save info to firestore
                authenticateParentAndSignUp();
              });
            }

          }
          else
            {
              showDialog(
                  context: context,
                  builder: (c){
                    return ErrorDialog(
                      message: "Please complete the required info for registration.",
                    );
                  }
              );
            }
        }
      else
        {
          showDialog(
              context: context,
              builder: (c){
                return ErrorDialog(
                  message: "Password do not match.",
                );
              }
          );
        }
    }
  }

  void authenticateParentAndSignUp() async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });

    if(currentUser != null)
      {
        saveDataToFirestore(currentUser!).then((value) {
          Navigator.pop(context);
          //send user to homePage
          Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        });
      }
  }

  Future saveDataToFirestore(User currentUser) async
  {
    if(widget.userType == "Parent"){
    FirebaseFirestore.instance.collection("parents").doc(currentUser.uid).set({
      "parentUID": currentUser.uid,
      "parentEmail": currentUser.email,
      "parentName" : nameController.text.trim(),
      "parentAvatarUrl" : parentImageUrl,
      "phone" : phoneController.text.trim(),
      "address" : completeAddress,
      "locality" : locality,
      "status" : "approved",
      "earnings" : 0.0,
      "lat" : position!.latitude,
      "lng" : position!.longitude,
      "userType" : "Parent",
      "userCart": ["garbageValue"]
    });
    }
    else if(widget.userType == "Tutor")
      {
        FirebaseFirestore.instance.collection("tutors").doc(currentUser.uid).set({
          "tutorUID": currentUser.uid,
          "tutorEmail": currentUser.email,
          "tutorName" : nameController.text.trim(),
          "tutorAvatarUrl" : parentImageUrl,
          "phone" : phoneController.text.trim(),
          "address" : completeAddress,
          "locality" : locality,
          "status" : "approved",
          "earnings" : 0.0,
          "rating" : 0.0,
          "lat" : position!.latitude,
          "lng" : position!.longitude,
          "userType" : "Tutor"
        });
      }

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", parentImageUrl);
    await sharedPreferences!.setString("usertype", widget.userType);
    await sharedPreferences!.setStringList("userCart", ["garbageValue"]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10 ,),
            InkWell(
              onTap: (){
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                //if icon have no image show nothing
                child: imageXFile == null
                    ?
                Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.grey,
                ) : null,
              ),
            ),
            const SizedBox(height: 10 ,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: (widget.userType == "Parent") ? "Home Location" : "My Location",
                    isObsecre: false,
                    enabled: true,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get My Current Location",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              ),
              onPressed: (){
                formValidation();
              },
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),

    );
  }
}
