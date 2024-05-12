
import 'package:client_app/component/AppBarCustom.dart';
import 'package:client_app/page/home/Carousel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  GlobalKey<State<AppBarCustom>>? appBarKey ;
  Home({this.appBarKey,super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<List<Map<String, dynamic>>>? listContent;
  List<Map<String, dynamic>>? listAuthor;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
  }
  void initValue() async
  {
    listContent = [
      [
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "AP Gov Required Court Cases", "count": 20},
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "Trắc nghiệm CNXHKH", "count": 12},
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "AP GOVERNMENT REVIEW SET", "count": 12},
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "List Rì Mít Cháy Như Phai Phai", "count": 42},
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "Lít Chiu Chiu Trong Nắng Chìu", "count": 23},
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "Nhất Niệm Thành Phật, Nhất Niệm Thành Ma", "count": 35},
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "topic", "title": "Đường Này Ta Không Đi Thì Ai Đi", "count": 35},
      ],
      [
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Hành Trình Tu Tiên", "count": 99},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Ta Là Đấu Tông", "count": 11},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Chuyển Sinh Tôi Là Chúa Tể", "count": 12},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ", "count": 42},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Ngộ Không Đấu Chiến Thắng Phật", "count": 23},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Tiên Đạo", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Nhất Định Ta Sẽ Đứng Top", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Đường Cùng", "count": 25},
      ],
      [
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Ta Là Đấu Tông", "count": 11},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Nhất Định Ta Sẽ Đứng Top", "count": 35},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Chuyển Sinh Tôi Là Chúa Tể", "count": 12},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Đường Cùng", "count": 25},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Ngộ Không Đấu Chiến Thắng Phật", "count": 23},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Hành Trình Tu Tiên", "count": 99},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Tiên Đạo", "count": 35},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "topic", "title": "Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ", "count": 42},
      ],
      [
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Hành Trình Tu Tiên", "count": 99},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Ta Là Đấu Tông", "count": 11},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Chuyển Sinh Tôi Là Chúa Tể", "count": 12},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ", "count": 42},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Ngộ Không Đấu Chiến Thắng Phật", "count": 23},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Tiên Đạo", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Nhất Định Ta Sẽ Đứng Top", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/12.jpg", "type": "topic", "title": "Đường Cùng", "count": 25},
      ],
      [
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Hành Trình Tu Tiên", "count": 99},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Ta Là Đấu Tông", "count": 11},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Chuyển Sinh Tôi Là Chúa Tể", "count": 12},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ", "count": 42},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Ngộ Không Đấu Chiến Thắng Phật", "count": 23},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Tiên Đạo", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Nhất Định Ta Sẽ Đứng Top", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/21.jpg", "type": "topic", "title": "Đường Cùng", "count": 25},
      ],
      [
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Hành Trình Tu Tiên", "count": 99},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Ta Là Đấu Tông", "count": 11},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Chuyển Sinh Tôi Là Chúa Tể", "count": 12},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ Sở Hữu Sức Mạnh Bá Đạo Tôi Làm Bá Chủ", "count": 42},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Ngộ Không Đấu Chiến Thắng Phật", "count": 23},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "topic", "title": "Tiên Đạo", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Nhất Định Ta Sẽ Đứng Top", "count": 35},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/22.jpg", "type": "topic", "title": "Đường Cùng", "count": 25},
      ],
    ];

    listAuthor =
      [ 
        {"author": "px4", "imgAuthor": "https://randomuser.me/api/portraits/men/1.jpg", "type": "author",  "count": 200},
        {"author": "ThichNoiDaoLy", "imgAuthor": "https://randomuser.me/api/portraits/men/2.jpg", "type": "author",  "count": 100},
        {"author": "TraSuaChanChauDuongDenKhongDa", "imgAuthor": "https://randomuser.me/api/portraits/men/3.jpg", "type": "author",  "count": 80},
        {"author": "ahihi", "imgAuthor": "https://randomuser.me/api/portraits/men/4.jpg", "type": "author",  "count": 80},
      ];
    
    if (widget.appBarKey?.currentState != null) 
    {
      (widget.appBarKey?.currentState as AppBarCustomState ).clearAll();
      (widget.appBarKey?.currentState as AppBarCustomState ).updateTitle("Trang Chủ");

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
      child: Column(        

        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding:  EdgeInsets.all(18.0),
            child:  Text( "Tác Giả Nổi Bật" , style:  TextStyle(
                              fontFamily: "SanProBold",
                              fontSize: 18, 
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),),
          ),
          // Build Carousel Tác Giả
          const SizedBox(height: 10,),
          _buildAuthor(),
          const SizedBox(height: 20,),
          Divider(height: 1,),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text( "Tổng Hợp Chủ Đề" , style: TextStyle(
                              fontFamily: "SanProBold",
                              fontSize: 18,  
                              color: Color.fromARGB(255, 0, 0, 0)                      
                            ),),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 50,),
            itemBuilder: (context, index) => _buildCarousel(index),
            itemCount: listContent?.length ?? 0,
          )
          
        ],
      ),
    );
  }

  Widget _buildCarousel(int index)
  {
    return Carousel(listCard: listContent?[index] ?? []);
  }
  Widget _buildAuthor()
  {
    return Carousel(listCard: listAuthor ?? []);
  }
}