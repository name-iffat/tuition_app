import 'package:flutter/material.dart';
import 'package:tuition_app/authentication/auth_screen.dart';


class ChooseUser extends StatefulWidget {
  const ChooseUser({super.key});

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}
void navigateToUserTypeScreen(BuildContext context, String userType){
  print('User Type: $userType');
  Navigator.push(
    context,
    MaterialPageRoute(builder: (c) => AuthScreen(userType: userType),
    ),
  );
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 150,
              child: Image.asset(
                "images/chooseBg.png",
                height: 270,
              ),
            ),
            Positioned(
              top: 150,
              child: Image.asset(
                "images/LOGO.png",
                height: 100, // Adjust the height as needed
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 300),
                const Text(
                  "Hi, nice to meet you!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),

                const Text(
                  "Choose who you are.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 400,
                  height: 100,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "Parent",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    icon: const Icon(
                      Icons.supervisor_account,
                      color: Colors.blueAccent,
                      size: 35,
                    ),
                    onPressed: () {
                      navigateToUserTypeScreen(context, "Parent");                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 20),
                      side: const BorderSide(width: 1, color: Colors.blue),

                    ),
                  ),
                ),
                Container(
                  width: 500,
                  height: 100,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "Tutor",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    icon: const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                      size: 35,
                    ),
                    onPressed: () {
                      navigateToUserTypeScreen(context, "Tutor");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 125, vertical: 20),
                      side: const BorderSide(width: 1, color: Colors.blue),

                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
  }
