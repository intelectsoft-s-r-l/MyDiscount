
import '../widgets/widgets/top_bar_image.dart';
import '../widgets/widgets/top_bar_text.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
             TopBarImage(size: size),
             AppBarText(size: size, text: 'Transactions')
            ],
          )
        ],
      ),
    );
  }
}
