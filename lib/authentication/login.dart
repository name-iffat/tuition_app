import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/widgets/error_dialog.dart';
import 'package:tuition_app/widgets/loading_dialog.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
          readDataAndSetDataLocally(currentUser!).then((value){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          });

        }
    }

    Future readDataAndSetDataLocally(User currentUser) async
    {
      await FirebaseFirestore.instance.collection("parents")
          .doc(currentUser.uid)
          .get().then((snapshot) async{
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["parentEmail"]);
            await sharedPreferences!.setString("name", snapshot.data()!["parentName"]);
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["parentAvatarUrl"]);

      });
    }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "images/seller.png",
                    height: 270,
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
