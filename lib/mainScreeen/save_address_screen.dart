import 'package:flutter/material.dart';
import 'package:tuition_app/widgets/simple_app_bar.dart';
import 'package:tuition_app/widgets/text_field.dart';

class SaveAddressScreen extends StatelessWidget {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Save Address: ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: "What's your address?",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6,),
            
            ElevatedButton.icon(
              label: const Text(
                "Get my location",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: const Icon(Icons.location_on, color: Colors.white,),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              onPressed: ()
              {
                //getCurrentLocationWithAddress
              },
            ),

            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: "City",
                    controller: _city,
                  ),
                  MyTextField(
                    hint: "State / Country",
                    controller: _state,
                  ),
                  MyTextField(
                    hint: "Address Line",
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: "Complete Address",
                    controller: _completeAddress,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Save Now"),
        icon: const Icon(Icons.check),
        onPressed: ()
        {
          //save address info
        },
      ),
    );
  }
}
