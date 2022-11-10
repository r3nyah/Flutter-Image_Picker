import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;

  Future pickImage(ImageSource source) async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if(image == null) return;

      //final imageTemporary = File(image.path);

      if (kIsWeb) {
        final imageTemporary = Image.network(image.path);
        setState(() {
          _image = imageTemporary as File?;
        });
      } else {
        final imageTemporary = Image.file(File(image.path));
        setState(() {
          _image = imageTemporary as File?;
        });
      }

      /*
      setState(() {
        _image = imageTemporary;
      });
       */

    }on PlatformException catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Image Picker',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 32,
                //fontWeight: FontWeight.bold,
              ),
            ),
            _image != null
              ? Image.file(_image!, width: 200, height: 200,)
              : FlutterLogo(size: 200),
            buildButton(
              text: 'Camera',
              icon: Icons.camera,
              onClicked: (){
                pickImage(ImageSource.camera);
              }
            ),
            SizedBox(height: 20),
            buildButton(
                text: 'Gallery',
                icon: Icons.browse_gallery,
                onClicked: (){
                  pickImage(ImageSource.gallery);
                }
            ),
          ]
        )
      ),
    );
  }

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
}){return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        primary: Colors.purpleAccent,
        onPrimary: Colors.white,
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          SizedBox(width: 10,),
          Icon(icon),
        ],
      ),
      onPressed: onClicked,
    );
  }
}
