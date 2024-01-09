import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/authentication/auth_screen.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/widgets/error_dialog.dart';
import 'package:tuition_app/widgets/loading_dialog.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key,required this.userType});
  final String userType;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    }
    else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please write email/password.",
            );
          }
      );
    }
  }

      loginNow() async
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return LoadingDialog(
              message: "Checking Credintials..",
            );
          }
      );

      User? currentUser;
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((auth){
        currentUser = auth.user!;
      }).catchError((error){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Invalid Email/Password.",
              );
            }
        );
      });
      if(currentUser != null)
        {
          readDataAndSetDataLocally(currentUser!);

        }
    }

    Future readDataAndSetDataLocally(User currentUser) async
    {
      if (widget.userType == "Parent") {
      await FirebaseFirestore.instance.collection("parents")
          .doc(currentUser.uid)
          .get().then((snapshot) async{
        if (snapshot.exists) {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!.setString(
              "email", snapshot.data()!["parentEmail"]);
          await sharedPreferences!.setString(
              "name", snapshot.data()!["parentName"]);
          await sharedPreferences!.setString(
              "photoUrl", snapshot.data()!["parentAvatarUrl"]);
          await sharedPreferences!.setString(
              "usertype", snapshot.data()!["userType"]);

          List<String> userCartList = snapshot.data()!["userCart"].cast<String>();
          await sharedPreferences!.setStringList(
              "userCart", userCartList);


          Navigator.pop(context);//remove loading dialog
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

        }
        else{
          firebaseAuth.signOut();
          Navigator.pop(context);//remove loading dialog
          Navigator.push(context, MaterialPageRoute(builder: (c)=>  AuthScreen(userType: widget.userType)));
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: "Account does not exist.",
                );
              }
          );        }

      });
      }
      else if (widget.userType == "Tutor") {
        await FirebaseFirestore.instance.collection("tutors")
            .doc(currentUser.uid)
            .get().then((snapshot) async{
              if(snapshot.exists){
                await sharedPreferences!.setString("uid", currentUser.uid);
                await sharedPreferences!.setString("email", snapshot.data()!["tutorEmail"]);
                await sharedPreferences!.setString("name", snapshot.data()!["tutorName"]);
                await sharedPreferences!.setString("photoUrl", snapshot.data()!["tutorAvatarUrl"]);
                await sharedPreferences!.setString(
                    "usertype", snapshot.data()!["userType"]);

                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>  const HomeScreen()));
              }
              else{
                firebaseAuth.signOut();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (c)=>  AuthScreen(userType: widget.userType)));
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorDialog(
                        message: "Account does not exist.",
                      );
                    }
                );        }

        });
      }
    }


  @override
  Widget build(BuildContext context) {
    String imagePath = widget.userType == "Parent"
        ? "images/parentlogin.png"
        : "images/tutorlogin.png";

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                    imagePath,
                    height: 300,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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

              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            ),
            onPressed: () {
              formValidation();
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
