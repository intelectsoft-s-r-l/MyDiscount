import 'package:MyDiscount/widgets/widgets/top_bar_image.dart';
import 'package:MyDiscount/widgets/widgets/top_bar_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            /**/
            children: [
              TopBarImage(size: size),
              AppBarText(size: size, text: 'Profile'),
              Positioned(
                top: size.height * .07,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: size.height * .08,
                right: 30,
                child: GestureDetector(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ), /* IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ), */
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'First Name',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('Igor'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Last Name',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('Cristea'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Date of birth',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('08.05.1995'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Gender',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('Male'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('E-mail'),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('koolpix404@gmail.com'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Phone Number',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('+37369858838'),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: SvgPicture.asset(
              'assets/icons/bottom.svg',
              width: size.width,
              height: size.height * .18,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
