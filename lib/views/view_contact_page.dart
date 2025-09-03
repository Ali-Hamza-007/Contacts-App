import 'dart:io';
import 'package:contacts/views/edit_contact_page.dart';
import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';

class ViewContact extends StatefulWidget {
  final String name;
  final String number;
  final int index;
  final String? imageAddress;

  const ViewContact({
    super.key,
    required this.name,
    required this.number,
    this.imageAddress,
    required this.index,
  });

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return editContact(
                      index: widget.index,
                      name: widget.name,
                      contactNo: widget.number,
                      imageAddress: widget.imageAddress,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: widget.imageAddress != null
                    ? FileImage(File(widget.imageAddress!))
                    : null,
                child: widget.imageAddress == null
                    ? const Icon(Icons.person, size: 60, color: Colors.black54)
                    : null,
              ),
            ),
            const SizedBox(height: 50),

            // Name
            Card(
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Number
            Card(
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(
                  widget.number,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
