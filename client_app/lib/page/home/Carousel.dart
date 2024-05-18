
import 'dart:ui';

import 'package:client_app/modules/ColorsApp.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  List<Map<String, dynamic>> listCard;

  Carousel({required this.listCard, super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselController _controller = CarouselController();

  // Edit add topic to folder at here
  void _addTopicToFolder({topic})
  {
    var idTopic = topic["id"];
    print(idTopic);

  }



  Widget _buildCard({index})
  {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {      
          var id = widget.listCard[index]["id"];  
            if(widget.listCard[index]["type"] == "topic")
            {

            }
            else
            {
              Navigator.pushNamed(context, "/account/view", arguments: id);
            }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 400,
          width: 300 ,
          margin: const EdgeInsets.symmetric(horizontal:5),
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.card,
          ),
          child: 
          (widget.listCard[index]["type"] == "topic") ?
          _topicWidget(index)
          : 
          _authorWidget(index)
            
        ),
      ),
    );
  }
  
  Widget _topicWidget(index)
  {
    return Stack(
      textDirection: TextDirection.rtl,
      children: [
        Column(
          children: [        
            SizedBox(
              height: 30,
              child: Text(
                widget.listCard[index]["title"],
                maxLines: 2,
                style:  TextStyle(
                    fontFamily: "SanProBold",
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    color: AppColors.titleLarge),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(top: 10),
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.blue,
              ),
              child: Text("${widget.listCard[index]["count"]} thuật ngữ",
                  style: TextStyle(
                      fontFamily: "SanProBold", fontSize: 12, color: AppColors.textCard )),
            ),
         
            Container(
                child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: NetworkImage(widget.listCard[index]["imgAuthor"]),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.listCard[index]["author"],
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: "SanProBold",
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: AppColors.titleLarge),
                  ),
                )
              ],
            )),
        
            
            
          ],
        ),
        IconButton(onPressed: () => _addTopicToFolder(topic:widget.listCard[index]), icon: Icon(Icons.folder_special, color: AppColors.titleLarge,)),

      ],
    );
  }
  
  Widget _authorWidget(index)
  {

    return  Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                      child:Container(
                          width: 56.0,
                          height: 56.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(widget.listCard[index]["imgAuthor"]),
                            ),
                          ),
                        )
                    ),
                    Expanded(
                      flex: 2,
                      child:  Text(
                      widget.listCard[index]["author"] , 
                      maxLines: 1,
                      style: TextStyle(
                      fontFamily: "SanProBold",
                      overflow: TextOverflow.ellipsis,
                      fontSize: 20,                
                      color: AppColors.titleLarge                   
                    ),),)
                ],
                ),
           
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: EdgeInsets.only(top: 10, right: 6),
                    height: 30,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 248, 248, 248),
                    ),
                    child: Text("${index+1}",
                        style:  TextStyle(
                        fontFamily: "SanProBold",
                        fontSize: 12, 
                        color: Color.fromARGB(255, 3, 155, 243)
                      )
                    ),
                  ),
                   Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: EdgeInsets.only(top: 10),
                    height: 30,
                                     
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                    child: Text("${widget.listCard[index]["count"]} chủ đề",
                        style:  TextStyle(
                        fontFamily: "SanProBold",
                        fontSize: 12, 
                        color: AppColors.textCard
                      )
                    ),
                  ),
                  
                ],
              ),
             
    
            ],          
          ) 
          ;
  }
  
  double get viewportF
  {
    var width = MediaQuery.of(context).size.width;
    if(width < 405)
    {
      return 0.9;
    }
    else if(width < 530)
    {
      return 0.5;
    }
    else if( width < 660)
    {
      return 0.5;
    }
    else if(width < 791)
    {
      return 0.4;
    }
    else if(width < 1106)
    {
      return 0.3;
    }
    else if(width < 1575)
    {
      return 0.2;
    }
    return 0.2;
  }
  double get aspectR
  {
    var width = MediaQuery.of(context).size.width;
    if(width < 405)
    {
      return 1.7;
    }
    else if(width < 530)
    {
      return 3;
    }
    else if(width < 660)
    {
      return 4;
    }
    else if(width < 791)
    {
      return 5;
    }
    else if(width < 1054)
    {
      return 6;
    }
    else if(width < 1106)
    {
      return 8;
    }
    else if(width < 1575)
    {
      return 8;
    }
    return 12;
  }
  
  @override
  Widget build(BuildContext context) {
    
    return
    Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 150,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView(         
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.listCard.map((e) => _buildCard(index: widget.listCard.indexOf(e)))
                ],
              ),
            ),
          )
          //  CarouselSlider.builder(            
          //   carouselController: _controller,
          //   itemCount: widget.listCard.length,  
          //   itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => _buildCard(index: itemIndex),
          //   options: CarouselOptions( 
          //     viewportFraction: 0.5,
          //     aspectRatio: aspectR,
          //     autoPlay: false,
          //     enlargeCenterPage: false,
          //     enableInfiniteScroll: false,
          //     initialPage: 0,
          //       onPageChanged: (index, reason) {
          //       setState(() {
          //         // Update UI or state if needed
          //       });
          //     }
          //   ),
          // ),
        ],
      ); 

  }




}

class MyCustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}