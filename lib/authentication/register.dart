import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuition_app/widgets/custom_text_field.dart';
import 'package:tuition_app/widgets/error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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

    String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

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
          //start uploading

          if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty)
          {
            //start uploading image
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
                    hintText: "Home Location",
                    isObsecre: false,
                    enabled: false,
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
                        primary: Colors.amber,
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
                primary: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
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
