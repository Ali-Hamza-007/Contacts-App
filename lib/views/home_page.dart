import 'dart:io';
import 'package:contacts/models/contact_attributes.dart';
import 'package:contacts/views/add_contact_page.dart';
import 'package:contacts/views/dial_pad_screen.dart';
import 'package:contacts/views/view_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchBoxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  // Function For Opening Box
  Future<void> _openBox() async {
    await Hive.openBox('Contacts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Developed by HAMZA </>', style: GoogleFonts.acme()),
      ),
      appBar: AppBar(
        // App Bar
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const addContact()),
              );
            },
            icon: const Icon(Icons.person_add, color: Colors.black),
          ),
        ],
        title: Text(
          'Contacts',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          children: [
            // Search Text Field
            TextField(
              controller: searchBoxController,
              onChanged: (_) => setState(() {}), // Refresh UI when searching
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                //  Work Just Like a Stream Builder that Continuosly Watches Changing and Displays All data Stored in Hive DB.
                valueListenable: Hive.box('Contacts').listenable(),
                builder: (context, box, _) {
                  final contacts = box.values
                      .toList()
                      .cast<ContactAttributes>();

                  if (contacts.isEmpty) {
                    return const Center(child: Text('No Contacts yet!'));
                  }

                  // 🔍 Apply search filter
                  final query = searchBoxController.text.trim().toLowerCase();
                  final filteredList = query.isEmpty
                      ? contacts
                      : contacts
                            .where(
                              (c) => c.name!.toLowerCase().startsWith(query),
                            )
                            .toList();

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final contact = filteredList[index];

                      return Dismissible(
                        // Dismissible to Delete the Contact
                        key: ValueKey(contact.contactNumber),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.black,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          //  Correctly delete from Hive
                          final contactIndex = contacts.indexOf(contact);
                          await box.deleteAt(contactIndex);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${contact.name} Deleted !!!"),
                            ),
                          );
                        },
                        child: ListTile(
                          // Displays the Contacts In HomePage
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ViewContact(
                                  index: index,
                                  name: contact.name!,
                                  number: contact.contactNumber,
                                  imageAddress: contact.imageAddress != null
                                      ? contact.imageAddress!
                                      : null,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            // To Displays the Contacts saved Image In HomePage
                            backgroundImage:
                                (contact.imageAddress != null &&
                                    contact.imageAddress!.isNotEmpty)
                                ? FileImage(File(contact.imageAddress!))
                                : null,
                            child:
                                (contact.imageAddress == null ||
                                    contact.imageAddress!.isEmpty)
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          trailing: IconButton(
                            // When Pressed Call the Relative Contact
                            onPressed: () {
                              FlutterPhoneDirectCaller.callNumber(
                                contact.contactNumber,
                              );
                            },
                            icon: const Icon(Icons.call),
                          ),
                          title: Text(
                            contact.name ?? '',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            contact.contactNumber,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // When Pressed , Navigates to another Page i.e DialPad
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return dialPad();
              },
            ),
          );
        },
        child: Icon(Icons.dialpad, color: Colors.white),
      ),
    );
  }
}
