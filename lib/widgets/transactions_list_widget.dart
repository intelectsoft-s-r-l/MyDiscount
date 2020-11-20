import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final Size size;
  final List<Map> list = [
    {
      "company": "Supraten",
      "data": "20.11.2020",
      "sum": "1000",
      "discount": "20"
    },
    {
      "company": "Supraten",
      "data": "20.11.2020",
      "sum": "1000",
      "discount": "20"
    }
  ];
  final List<Color> colorList = [Colors.amber, Colors.blueAccent, Colors.cyan];
  TransactionList({Key key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .7,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          width: size.width * .9,
          decoration: BoxDecoration(
            color: colorList[index],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Row(
              children: [
                Text(
                  "Compania:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${list[index]['company']}",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  "Data tranzactiei:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${list[index]['data']}",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            trailing: Container(
                width: 150,
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Suma tranzactiei:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${list[index]['sum']} lei",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Bonus:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " ${list[index]['discount']}",
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
