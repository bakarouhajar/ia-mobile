import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBox extends StatefulWidget {
  const AddBox({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _AddBoxState createState() => _AddBoxState();
}

class _AddBoxState extends State<AddBox> {
  final _formKey = GlobalKey<FormState>();
  late File _imageFile;
  late List _identifiedResult;
  
   @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  Future selectImage() async {
    final picker = ImagePicker();
    var image = await picker.getImage(source: ImageSource.gallery, maxHeight: 300);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Emoji Classifier",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white70,
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: (_imageFile != null)?
                Image.file(_imageFile) :
                Image.network('https://i.imgur.com/sUFH1Aq.png')
              ),
              FloatingActionButton(
                tooltip: 'Select Image',
                onPressed: (){
                  selectImage();
                },
                child: Icon(Icons.add_a_photo,
                size: 25,
                color: Colors.blue,
                ),
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: _identifiedResult != null ? [
                    Text(
                      "Result : ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    Card(
                        elevation: 1.0,
                        color: Colors.white,
                        child: Container(
                          width: 100,
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              //"${_identifiedResult[0]["label"]}",
                              "test",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      )
                    ]
                  :[]
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
