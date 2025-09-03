import 'dart:io';
import 'package:contacts/models/contact_attributes.dart';
//import 'package:contacts/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class editContact extends StatefulWidget {
  final int index; //  Index of the contact in Hive box
  final String name;
  final String contactNo;
  final String? imageAddress;

  const editContact({
    super.key,
    required this.index,
    required this.name,
    required this.contactNo,
    required this.imageAddress,
  });

  @override
  State<editContact> createState() => _EditContactState();
}

class _EditContactState extends State<editContact> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController nameController;
  late TextEditingController numberController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    numberController = TextEditingController(text: widget.contactNo);
    imagePath = widget.imageAddress;
  }

  // Function to Pick Image from Gallery
  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imagePath = pickedFile.path;
      });
    }
  }

  // Function to save contact
  void _saveContact() {
    final updatedContact = ContactAttributes(
      name: nameController.text.trim(),
      contactNumber: numberController.text.trim(),
      imageAddress: imagePath,
    );

    final box = Hive.box('Contacts');
    box.putAt(widget.index, updatedContact); // Update correct contact

    Navigator.pop(context); // Go back instead of pushing new HomePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App Bar
        centerTitle: true,
        title: Text(
          'Edit Contact',
          style: GoogleFonts.lato(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () => _saveContact(),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Stack(
                // Use of Stack for Image Picker UI
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!))
                        : null,
                    child: imagePath == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.black54,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: -5,
                    right: 0,
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
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // Contact Name
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Contact Number
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.call),
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
