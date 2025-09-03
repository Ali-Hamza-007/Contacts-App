import 'dart:io';

import 'package:contacts/models/contact_attributes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class addContact extends StatefulWidget {
  const addContact({super.key});

  @override
  State<addContact> createState() => _addContactState();
}

class _addContactState extends State<addContact> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  String? _imageFile; // To store picked image
  final ImagePicker _picker = ImagePicker();
  // Function to Pick Images from Gallery
  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Contact',
          style: GoogleFonts.lato(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final contactBox = await Hive.openBox('Contacts');

              if (contactBox.isOpen) {
                final _contactAttributes = ContactAttributes(
                  name: nameController.text.trim(),
                  contactNumber: numberController.text.trim(),
                  imageAddress: _imageFile,
                );
                contactBox.add(_contactAttributes);
                // final data = contactBox.get(3) as ContactAttributes;
                // print('image Address : ${data.imageAddress}');
              }
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Circle Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!))
                        : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.black54,
                          )
                        : null,
                  ),

                  // Positioned Plus Button to add Images
                  Positioned(
                    bottom: -5, // Slightly below the border
                    right: 0, // Align to the right
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Enter Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: numberController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.call),
                hintText: 'Enter Contact No.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
