import 'package:MyDiscount/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final list = [
      {'logo': 'asfs', 'name': 'Convis', 'amount': '10'},
      {'logo': 'asfs', 'name': 'Eco fifiw', 'amount': '10'},
      {'logo': 'asfs', 'name': 'Decadance', 'amount': '10'},
      {'logo': 'asfs', 'name': 'Star Kebab', 'amount': '10'},
    ];
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/icons/top.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: size.height * .06,
                left: 30,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contxt) => ProfilePage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'Vasea Tombucica',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Sign In with Apple',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: size.height * .7,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) => Card(
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.grey[300],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  leading: Container(
                    width: 40,
                    height: 40,
                    child: Placeholder(),
                  ), //Text(list[index]['logo']),
                  title: Text(
                    list[index]['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //textAlign: TextAlign.center,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Suma',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent[300],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${list[index]['amount']} MDL',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent[300],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
