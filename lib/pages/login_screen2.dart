import 'package:MyDiscount/pages/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return /*  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: */
        Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  //padding: EdgeInsets.only(top: 24),
                  height: size.height * .45,
                  width: size.width,
                  child: Image.asset(
                    'assets/icons/Group.png',
                    fit: BoxFit.fill,
                  )),
              Positioned(
                left: 0.0 /* size.width * .33 */,
                top: size.height * .052,
                child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    child: Text(
                      'Welcome to MyDiscount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                      maxLines: 2,
                    )),
              ),
              /*  Positioned(
                left: 0.0,
                top: size.height * .15,
                child: Container(
                  height: size.height * .23,
                  alignment: Alignment.center,
                  constraints: BoxConstraints(maxWidth: size.width),
                  child: /* SvgPicture.asset('assets/icons/image_test.svg') */ Image
                      .asset(
                    'assets/icons/invited.png',
                    scale: 1.2,
                    fit: BoxFit.fill,
                    width: size.width,
                  ),
                ),
              ), */
            ],
          ),
          Container(
            height: size.height * .5,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .09,
                ),
                Container(
                  height: 40,
                  width: size.width * .82,
                  alignment: Alignment.center,
                  //padding: EdgeInsets.only(left:10,right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(8),
                    /* shape: BoxShape.rectangle */
                  ),
                  child: Text(
                    'Sign in with:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .065,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavigationBarWidget()),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: size.width * .82,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF406BFB),
                      //border: Border.all(width: 2, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_google.svg',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavigationBarWidget()),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: size.width * .82,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF2D4CB3),
                      //border: Border.all(width: 2, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_facebook.svg',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in with Facebook',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                     MaterialPageRoute(builder: (context) => BottomNavigationBarWidget()),
                    );
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    height: 40,
                    width: size.width * .82,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      // border: Border.all(width: 2, color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_apple.svg',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in with Apple',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /* Container(
            height: 40,
            width: size.width * .8,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              // border: Border.all(width: 2, color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [SizedBox(
                  width: 20,
                ),
                SvgPicture.asset(
                  'assets/icons/icon_apple.svg',
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Sign in with Apple',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ), */
              ],
            ),
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Text('Privacy policy'),
        ],
      ),
      /*  ), */
    );
  }
}
