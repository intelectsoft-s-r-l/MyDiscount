import 'dart:async';

import 'package:flutter/material.dart';

class AppBarIcons extends StatelessWidget {
  const AppBarIcons({
    Key key,
    @required this.size,
    @required StreamController<int> indexController,
    @required this.selectedIndex,
    @required PageController pageController,
  }) : _indexController = indexController, _pageController = pageController, super(key: key);

  final Size size;
  final StreamController<int> _indexController;
  final int selectedIndex;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: size.height * .05,
      child: StreamBuilder<int>(
        stream: _indexController.stream,
        initialData: 1,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (selectedIndex != 0) {
                    _pageController.jumpToPage(0);
                    _indexController.add(0);
                   // FirebaseCrashlytics.instance.crash();
                  }
                },
                child: Container(
                  width: size.width * 0.33,
                  child: CircleAvatar(
                    minRadius: 26.5,
                    backgroundColor:
                        _pageController.initialPage - 1 ==
                                snapshot.data
                            ? Colors.green
                            : Colors.white,
                    child: ImageIcon(
                      const AssetImage('assets/icons/qrlogo.png'),
                      size: 53,
                      color: _pageController.initialPage - 1 ==
                              snapshot.data
                          ? Colors.white
                          : Colors.green,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _pageController.jumpToPage(
                    1,
                  );
                  _indexController.add(1);
                },
                child: Container(
                  width: size.width * 0.33,
                  child: CircleAvatar(
                    minRadius: 26.5,
                    backgroundColor:
                        _pageController.initialPage == snapshot.data
                            ? Colors.green
                            : Colors.white,
                    child: ImageIcon(
                      const AssetImage('assets/icons/qq3.png'),
                      size: 53,
                      color: _pageController.initialPage ==
                              snapshot.data
                          ? Colors.white
                          : Colors.green,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _pageController.jumpToPage(2);
                  _indexController.add(2);
                },
                child: Container(
                  width: size.width * 0.33,
                  child: CircleAvatar(
                    minRadius: 26.5,
                    backgroundColor:
                        _pageController.initialPage + 1 ==
                                snapshot.data
                            ? Colors.green
                            : Colors.white,
                    child: ImageIcon(
                      const AssetImage('assets/icons/news1.png'),
                      size: 53,
                      color: _pageController.initialPage + 1 ==
                              snapshot.data
                          ? Colors.white
                          : Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}