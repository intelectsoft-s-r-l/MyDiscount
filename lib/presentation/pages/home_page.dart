import 'package:flutter/material.dart';
import '../widgets/home_page/home_page_items_list.dart';

import '../widgets/home_page/home_page_top_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          HomePageTopWidget(
            size: size,
          ),
          HomePageItems(size: size),
        ],
      ),
    );
  }
}


