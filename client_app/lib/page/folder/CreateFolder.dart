import 'package:flutter/material.dart';

class CreateFolder extends StatefulWidget {
  const CreateFolder({super.key});

  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo thư mục', textAlign: TextAlign.center,style: TextStyle( fontFamily: "SanProBold", )),
      content: Form(
        key: key,
        child: Container(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),

    );
  }
}