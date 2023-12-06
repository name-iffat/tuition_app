import 'package:flutter/material.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/home_screen.dart';
import 'package:tuition_app/mainScreeen/tutor_orders.dart';

import '../authentication/choose_user.dart';

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
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on,color: Colors.black,),
                  title: const Text(
                    "My Earnings",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.reorder,color: Colors.black,),
                  title: const Text(
                    "New Address",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description,color: Colors.black,),
                  title: const Text(
                    "New Orders",
                    style: TextStyle(color: Colors.black)
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> TutorOrdersScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions_car,color: Colors.black,),
                  title: const Text(
                    "History - Orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){

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
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> const ChooseUser()));
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
