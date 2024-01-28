import 'package:flutter/material.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/book_in_progress_screen.dart';
import 'package:tuition_app/mainScreeen/history_tutor_screen.dart';
import 'package:tuition_app/mainScreeen/not_yet_tutored_screen.dart';
import 'package:tuition_app/mainScreeen/tutor_cancel_screen.dart';
import 'package:tuition_app/mainScreeen/tutor_orders.dart';

import '../authentication/choose_user.dart';
import '../mainScreeen/tutor_home_screen.dart';

class MyDrawerTutor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //header drawer
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child:  Column(
              children: [
                //header drawer
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Bebas"),

                ),
                Text(
                  "RM $previousTutorEarnings",
                  style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: "Poppins"),

                )
              ],
            ),
          ),

          const SizedBox(height:12,),

          //body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home,color: Colors.black,),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const TutorHomeScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description,color: Colors.black,),
                  title: const Text(
                    "New Book",
                    style: TextStyle(color: Colors.black)
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> TutorOrdersScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel,color: Colors.black,),
                  title: const Text(
                    "Canceled Book",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> CancelScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history,color: Colors.black,),
                  title: const Text(
                    "History - Book",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> TutorHistoryScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions_car,color: Colors.black,),
                  title: const Text(
                    "Book in Progress",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> BookInProgressScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.approval,color: Colors.black,),
                  title: const Text(
                    "Not Yet Tutored",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetTutoredScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app,color: Colors.black,),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    firebaseAuth.signOut().then((value){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=> const ChooseUser()));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
