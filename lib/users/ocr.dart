import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:heart_rate/api/imagetotext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class OCR extends StatefulWidget {
  const OCR({super.key});

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  final ImagePicker picker = ImagePicker();
  File? _image;

  handleimage() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
      final imageBytes = File(photo.path).readAsBytesSync();
      print(imageBytes);
      Provider.of<ImageApi>(context, listen: false).getImage(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: ElevatedButton(
                  onPressed: () {
                    handleimage();
                  },
                  child: Text("Select Picture")),
            ),
          ),
          _image == null
              ? Center(child: Container(child: Text("No Image")))
              : Center(
                  child: Container(
                    child: Image.file(_image!),
                  ),
                )
        ],
      ),
    );
  }
}
