
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

  Widget _buildCard({index})
  {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 100,
          width: MediaQuery.sizeOf(context).width ,
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
    return Column(
      children: [
        SizedBox(
          height: 35,
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
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.blue,
          ),
          child: Text("${widget.listCard[index]["count"]} thuật ngữ",
              style: TextStyle(
                  fontFamily: "SanProBold", fontSize: 12, color: AppColors.textCard )),
        ),
        Spacer(),
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
    );
  }
  
  Widget _authorWidget(index)
  {
    return  Column(
            children: [
              Container(
                child: Row(
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
                  )
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
                    color: AppColors.card
                  )
                ),
              ),
              Spacer(),

            ],          
          ) 
          ;
  }
  
  double get viewportF
  {
    var width = MediaQuery.of(context).size.width;
    if( width < 600)
    {
      return 0.7;
    }
    else if(width < 1106)
    {
      return 0.4;
    }
    return 0.2;
  }
  double get aspectR
  {
    var width = MediaQuery.of(context).size.width;
    if(width < 600)
    {
      return 3;
    }
    else if(width < 1106)
    {
      return 8;
    }
    return 15;
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.listCard.length,  // Giả sử bạn có 10 card
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => _buildCard(index: itemIndex),
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: false,
            // viewportFraction: 0.6, // 0.2
            viewportFraction: viewportF, // 0.2
            // aspectRatio: 4.0, // 15
            aspectRatio: aspectR, // 15
            initialPage: 0,
  
            onPageChanged: (index, reason) {
              setState(() {
                // Update UI or state if needed
              });
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(          
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () => _controller.previousPage(),
                icon: Icon(Icons.arrow_back_ios_new, color: AppColors.iconNB,),
              ),
              IconButton(
                onPressed: () => _controller.nextPage(),
                icon: Icon(Icons.arrow_forward_ios, color: AppColors.iconNB),
              ),
            ],
          ),
        )
      ],
    );
  }
}