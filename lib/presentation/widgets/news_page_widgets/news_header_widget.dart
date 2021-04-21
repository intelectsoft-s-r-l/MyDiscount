import 'package:flutter/material.dart';

import '../../../domain/entities/news_model.dart';

class NewsHeaderWidget extends StatelessWidget {
  const NewsHeaderWidget({
    Key? key,
    required this.size,
    required this.news,
  }) : super(key: key);

  final Size? size;
  final News? news;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          top: 39,
          left: 69,
          child: Container(
            padding:const EdgeInsets.only(
              right: 10,
            ),
            child: Text(
              news!.dateTime,
              style:const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black38),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Positioned(
          top: 15,
          left: 69,
          child: Container(
            child: Text(
              news!.companyName.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: Container(
            width: 60,
            height: 60,
            child: Image.memory(
              news!.logo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container();
              },
            ),
          ),
        ),
      ],
    );
  }
}
