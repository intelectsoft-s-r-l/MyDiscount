import 'package:flutter/material.dart';

import '../../../../domain/entities/news_model.dart';

class NewsHeaderWidget extends StatelessWidget {
  const NewsHeaderWidget({
    Key? key,
    required this.size,
    required this.news,
  }) : super(key: key);

  final Size size;
  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Image.memory(
              news.logo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container();
              },
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    news.companyName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    news.dateTime,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black38),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
