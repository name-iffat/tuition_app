import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/tutor_home_screen.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import '../models/subjects.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {
  final Subjects model;
  ItemsUploadScreen({required this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  //TextEditingController shortInfoController = TextEditingController();
  String selectedForm = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final List<String> forms = ["Form 1", "Form 2", "Form 3", "Form 4", "Form 5"];

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();


  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.blue,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "Add New item",
          style: TextStyle(fontSize: 30, fontFamily: "Bebas"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const TutorHomeScreen()));
          },
        ),

      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.my_library_books, color: Colors.grey, size: 200,),
              ElevatedButton(
                child: Text(
                  "Add Your Subject",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: ()
                {
                  takeImage(context);
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
  takeImage(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (context)
        {
          return SimpleDialog(
            title: const Text("Subject image",style: TextStyle(color: Colors.cyan,fontWeight:FontWeight.bold ),),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture With Camera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select From Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: ()=> Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }

  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async
  {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  itemsUploadScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.blue,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "Add New Items",
          style: TextStyle(fontSize: 30, fontFamily: "Bebas"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            clearSubjectUploadForm();
            //Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen(userType: "Tutor",)));
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Add",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  fontFamily: "Bebas"
              ),
            ),
            onPressed:uploading ? null : ()=> validateUploadForm(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.lightBlue,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.school, color: Colors.cyan,),
            title:Wrap(
              children: [
                for (String form in forms)

                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ChoiceChip(
                      selectedColor: Colors.cyan,
                      label: Text(form, style: TextStyle(color: Colors.white),),
                      selected: selectedForm == form,
                      onSelected: (selected) {
                        setState(() {
                          selectedForm = selected ? form : "";
                        });
                      },
                    ),
                  ),
              ],
            ),

          ),
          const Divider(
            color: Colors.lightBlue,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller:  descriptionController,
                decoration: const InputDecoration(
                  hintText: "description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.lightBlue,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.money, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller:  priceController,
                decoration: const InputDecoration(
                  hintText: "price per session",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.lightBlue,
            thickness: 1,
          ),


        ],
      ),
    );
  }

  clearSubjectUploadForm()
  {
    setState(() {
      selectedForm = "";
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async
  {
    if(imageXFile !=null)
    {
      if(selectedForm.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));


        //save info to firebase
        saveInfo(downloadUrl);
      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please write title and info for subject.",
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
              message: "Please pick an image for Subject.",
            );
          }
      );
    }
  }

  saveInfo(String downloadUrl)
  {
    final ref= FirebaseFirestore.instance
        .collection("tutors")
        .doc(sharedPreferences!.getString("uid"))
        .collection("subject")
        .doc(widget.model.subjectID)
        .collection("items");
    ref.doc(uniqueIdName).set({
      "itemID" : uniqueIdName,
      "subjectID" : widget.model!.subjectID,
      "tutorUID" : sharedPreferences!.getString("uid"),
      "tutorName" : sharedPreferences!.getString("name"),
      "shortInfo" : selectedForm.toString(),
      "longDescription" : descriptionController.text.toString(),
      "price" : int.parse(priceController.text),
      "title" : titleController.text.toString(),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : downloadUrl,
    }).then((value)
    {
      final itemsRef= FirebaseFirestore.instance
          .collection("items");

      itemsRef.doc(uniqueIdName).set({
        "itemID" : uniqueIdName,
        "subjectID" : widget.model!.subjectID,
        "tutorUID" : sharedPreferences!.getString("uid"),
        "tutorName" : sharedPreferences!.getString("name"),
        "shortInfo" : selectedForm.toString(),
        "longDescription" : descriptionController.text.toString(),
        "price" : int.parse(priceController.text),
        "title" : titleController.text.toString(),
        "publishedDate" : DateTime.now(),
        "status" : "available",
        "thumbnailUrl" : downloadUrl,
      });
    }).then((value)
    {
      clearSubjectUploadForm();
      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading =false ;
      });
    });
  }

  uploadImage(mImageFile) async
  {
    storageRef.Reference reference =  storageRef.FirebaseStorage
        .instance
        .ref()
        .child("items");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadScreen();
  }
}
