import 'package:flutter/material.dart';
import 'package:tuition_app/global/global.dart';
import 'package:tuition_app/mainScreeen/address_screen.dart';
import 'package:tuition_app/mainScreeen/history_screen.dart';
import 'package:tuition_app/mainScreeen/map_screen.dart';
import 'package:tuition_app/mainScreeen/my_orders_screen.dart';
import 'package:tuition_app/mainScreeen/search_screen.dart';
import 'package:tuition_app/mainScreeen/tutor_cancel_screen.dart';

import '../authentication/choose_user.dart';
import '../mainScreeen/home_screen.dart';

class MyDrawer extends StatelessWidget {

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
                  leading: const Icon(Icons.map,color: Colors.black,),
                  title: const Text(
                    "Map",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> FullMap()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.reorder,color: Colors.black,),
                  title: const Text(
                    "My Orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MyOrderScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time,color: Colors.black,),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel_outlined,color: Colors.black,),
                  title: const Text(
                    "Cancel Booking",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> CancelScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search,color: Colors.black,),
                  title: const Text(
                    "Search",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_location,color: Colors.black,),
                  title: const Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> AddressScreen()));
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
                      Navigator.pop(context);
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
