import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';

class dialPad extends StatefulWidget {
  const dialPad({super.key});

  @override
  State<dialPad> createState() => _dialPadState();
}

class _dialPadState extends State<dialPad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Dial Pad',
          style: GoogleFonts.lato(fontWeight: FontWeight.w500),
        ),
      ),
      body: DialPad(
        // Dial Pad from dial_pad package
        buttonColor: Colors.grey,
        //enableDtmf: true,
        outputMask: "0000 0000000",
        hideSubtitle: false,
        backspaceButtonIconColor: Colors.red,
        buttonTextColor: Colors.black,
        dialOutputTextColor: Colors.black,

        makeCall: (number) {
          FlutterPhoneDirectCaller.callNumber(number);
        },
      ),
    );
  }
}
