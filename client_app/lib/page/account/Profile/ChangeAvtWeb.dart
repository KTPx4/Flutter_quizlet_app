
import 'package:client_app/apiservices/WebAPI.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class ChangeAvtWeb extends StatefulWidget {
  

  ChangeAvtWeb({Key? key,}) : super(key: key);

  @override
  _ChangeAvtWebState createState() => _ChangeAvtWebState();
}

class _ChangeAvtWebState extends State<ChangeAvtWeb> {


  bool isBlock = false;
  bool waitLoad = false;

  List<PlatformFile>? _paths;

  void pickFiles() async {
    try {
        _paths = (await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          onFileLoading: (FilePickerStatus status) => print(status),
          allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
        ))
          ?.files;
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } 
    catch (e) {
    print("Error when pick file: " + e.toString());
    }
    // log(_paths.toString());
    setState(() {      
    });

  }

  Future<void> _uploadImage() async {
      if (_paths  == null) {
        return;
      }
      setState(() {
        isBlock = true;
      });
  
      var res = await WebAPI.changeAvtWeb(file: _paths!.first.bytes!,fileName: _paths!.first.name);
        
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
        else
        {
          Navigator.of(context).pop(false);  

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
               (_paths != null) ?
                   Image.memory(_paths!.first.bytes!)  : Text("Chọn Ảnh" ,textAlign: TextAlign.center, 
                          style: TextStyle(  fontFamily: "SanProBold", fontSize: 17))),
                 
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      if(!isBlock) ElevatedButton(
                        onPressed: pickFiles,
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
