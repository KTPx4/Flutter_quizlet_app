import 'package:flutter/material.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget{
  final GlobalKey<State<AppBarCustom>> key;

  AppBarCustom({ required this.key}) : super(key: key);
  // const AppBarCustom({super.key});

  @override
  State<AppBarCustom> createState() => AppBarCustomState();
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight );



  

 
}

class AppBarCustomState extends State<AppBarCustom> with SingleTickerProviderStateMixin{
  String _title = "";
  List<Widget> _action = [];
  Color? _color = Colors.white;
  Color? _titleColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    initStartup();
    super.initState();
  }
  void initStartup()
  {
    setState(() {
      _title = "";
      _action = [];   
      _color = Colors.white;    
      _titleColor = Colors.black;   
    });

  }

  

  void updateTitle(String title , {Color color = Colors.black})
  {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _title = title;
          _titleColor = color;
        });

      }
    });
  }

  void updateAction(List<Widget> action)
  {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _action = action;
        });
      }
    });
  }
  void updateColor(Color? color)
  {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _color = color;
        });
      }
    });
  }


  void clearAll()
  {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        initStartup();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(      
      title: Text(_title, style: TextStyle(color: _titleColor, fontFamily: "SanProBold",),),      
      actions: _action,     
      backgroundColor: _color,      
    );
  }
}