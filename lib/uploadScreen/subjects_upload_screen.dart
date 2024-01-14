import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/widgets/progress_bar.dart';
import '../mainScreeen/home_screen.dart';
import '../widgets/error_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class SubjectUploadScreen extends StatefulWidget {
  const SubjectUploadScreen({super.key});

  @override
  State<SubjectUploadScreen> createState() => _SubjectUploadScreenState();
}

class _SubjectUploadScreenState extends State<SubjectUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  // locality state variables
  List<String> selectedFilters = [];

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
          "Add Collection",
          style: TextStyle(fontSize: 30, fontFamily: "Bebas"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
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
                  "Add Your Collections",
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
                title: const Text("Collection image",style: TextStyle(color: Colors.blue,fontWeight:FontWeight.bold ),),
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
  void _handleFilterSelection(String value, bool selected) {
    setState(() {
      if (value == "All") {
        if (selected) {
          selectedFilters.clear(); // Clear all other selections if All is selected
        } else {
          selectedFilters.add(value);
          // Do nothing if All is deselected (other selections remain)
        }
      } else { // For other chips
        if (selected) {
          selectedFilters.add(value);
        } else {
          selectedFilters.remove(value);
        }
      }
      // Apply filtering logic based on selectedFilters
    });
  }

  SubjectUploadScreen()
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
          "Add Collection",
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
                  hintText: "subject title",
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
            leading: const Icon(Icons.perm_device_information, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "subjet info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.cyan,),
                title: Wrap(
                  children: [
                    FilterChip(
                      label: const Text("All", style: TextStyle(color: Colors.white)),
                      selected: selectedFilters.contains("All"),
                      selectedColor: selectedFilters.contains("All") ? Colors.lightGreen : Colors.lightBlueAccent, // Change color based on "All" selection, // Change color based on "All" selection
                      checkmarkColor: selectedFilters.contains("All") ? Colors.white : Colors.white,
                      onSelected: (selected) => _handleFilterSelection("All", selected),
                    ),
                    FilterChip(
                      label: const Text("Tapah", style: TextStyle(color: Colors.white)),
                      selected: selectedFilters.contains("Tapah"),
                      selectedColor: Colors.lightBlueAccent,
                      checkmarkColor: Colors.white,
                      onSelected: (selected) => _handleFilterSelection("Tapah", selected),
                    ),
                    FilterChip(
                      label: const Text("Bidor", style: TextStyle(color: Colors.white)),
                      selected: selectedFilters.contains("Bidor"),
                      selectedColor: Colors.lightBlueAccent,
                      checkmarkColor: Colors.white,
                      onSelected: (selected) => _handleFilterSelection("Bidor", selected),
                    ),
                    FilterChip(
                      label: const Text("Kampar", style: TextStyle(color: Colors.white)),
                      selected: selectedFilters.contains("Kampar"),
                      selectedColor: Colors.lightBlueAccent,
                      checkmarkColor: Colors.white,
                      onSelected: (selected) => _handleFilterSelection("Kampar", selected),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  clearSubjectUploadForm()
  {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async
  {
    if(imageXFile !=null)
      {
        if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty)
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
        .collection("subject");
    ref.doc(uniqueIdName).set({
      "subjectID" : uniqueIdName,
      "tutorUID" : sharedPreferences!.getString("uid"),
      "subjectInfo" : shortInfoController.text.toString(),
      "subjectTitle" : titleController.text.toString(),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : downloadUrl,
      "locality" : selectedFilters,
    }).then((value) {
      final SubjectRef = FirebaseFirestore.instance
          .collection("subjects");

      SubjectRef.doc(uniqueIdName).set({
        "subjectID": uniqueIdName,
        "tutorUID": sharedPreferences!.getString("uid"),
        "subjectInfo": shortInfoController.text.toString(),
        "subjectTitle": titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
        "locality": selectedFilters,
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
        .child("subjects");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);
    
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : SubjectUploadScreen();
  }
}
