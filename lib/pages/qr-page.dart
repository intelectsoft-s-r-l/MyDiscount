import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/icons/top.svg',
                  fit: BoxFit.fill,
                ),
              ),
              /* Positioned(
                top: size.height * .07,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserPage()),
                    );
                  },
                ),
              ), */
              Positioned(
                top: size.height * .08,
                left: size.width * .33,
                child: Container(
                  alignment: Alignment.center,
                  width: size.width * .33,
                  child: Text(
                    'Qr-code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                width: size.width * .8,
                height: size.width * .8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (rect) => LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.green,
                            ],
                          ).createShader(rect),
                          child: QrImage(
                            data: 'null',
                            size: size.width * .6,
                          ),
                        ),
                      ),
                    ),
                    LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/icons/bottom.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: size.width * .1,
                bottom: size.height * .05,
                child: Container(
                  width: size.width * .8,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'Prezentati acest cod casierului',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Codul se modifica la fiecare 10 sec.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
