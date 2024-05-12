import 'dart:io';
import 'dart:convert';
import 'package:client_app/apiservices/accountAPI.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChangeAvtMobile extends StatefulWidget {
  

  ChangeAvtMobile({Key? key,}) : super(key: key);

  @override
  _ChangeAvtMobileState createState() => _ChangeAvtMobileState();
}

class _ChangeAvtMobileState extends State<ChangeAvtMobile> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool isBlock = false;
  bool waitLoad = false;

  Future<void> _pickImage() async {
    if(isBlock || waitLoad) return;
    if(mounted)
    {
      setState(() {
        waitLoad = true;
      });
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }

      setState(() {
        waitLoad = false;
      });

    }
  }

  Future<void> _uploadImage() async {
      if (_imageFile == null) {
        return;
      }
      setState(() {
        isBlock = true;
      });

      var res = await AccountAPI.changeAvt(path: _imageFile!.path);
      
      if(mounted)
      {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
        
        setState(() {
          isBlock = false;
        });
        if(res['success'] == true)
        {           
          Navigator.of(context).pop(true);  
        }

      }
   
    
    
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 250, 237, 241),
      content:  Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 0),
        height: 210,
        width: 350,
        child: Row(
              children: [
                Expanded(child: 
               (_imageFile != null) ?
                  Image.file(File(_imageFile!.path), scale: 2,) : Text("Chọn Ảnh" ,textAlign: TextAlign.center, 
                          style: TextStyle(  fontFamily: "SanProBold", fontSize: 17))),
                 
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      if(!isBlock) ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                           fixedSize: Size(110, 40),
                        ),
                        child: Text('Tải lên' , style: TextStyle(color: Colors.black, ) ),
                      ),
                      SizedBox(height: 10),
                      isBlock? CircularProgressIndicator(color: Colors.pink,) : ElevatedButton(
                        onPressed: _uploadImage,
                        style: ElevatedButton.styleFrom(
                           fixedSize: Size(110, 40),
                        ),
                        child: Text('Lưu' , style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(                       
                          fixedSize: Size(110, 40),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Thoát', style: TextStyle(color: Colors.black, ),),
                      ),
                    ],
                  ),
                )
              ],
            ),
      ),
          
  
      
    );
  }
}
