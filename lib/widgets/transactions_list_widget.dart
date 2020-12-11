import 'package:MyDiscount/models/tranzaction_model.dart';
import 'package:MyDiscount/services/transactions_service.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final TransactionService service = TransactionService();
  final Size size;

  /* final List<Map> list = [
    {
      "company": "Supraten",
      "data": "20.11.2020",
      "sum": "1000",
      "discount": "20"
    },
    {"company": "supra", "data": "20.11.2020", "sum": "1000", "discount": "20"},
    {
      "company": "ethsdfbsdfb",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "sdbdsfbdsfbd",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Suprewgfsgdaten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Supsdfgdsfgdraten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Suprasdfgdsfdfgten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Suprsdfgdfsaten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Supradsfgdften",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Sudsfgdsfpraten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Supdsfgdsfraten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Suprdfgsaten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Supsdfgraten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
    {
      "company": "Supraten",
      "data": "20.11.2020",
      "sum": "100000000",
      "discount": "20"
    },
  ]; */
  final List<Color> colorList = [
    Colors.amber,
    Colors.blueAccent,
    Colors.cyan,
    Colors.amber,
    Colors.blueAccent,
    Colors.cyan,
    Colors.amber,
    Colors.blueAccent,
    Colors.cyan,
    Colors.amber,
    Colors.blueAccent,
    Colors.cyan,
    Colors.amber,
    Colors.blueAccent,
    Colors.cyan,
    Colors.amber,
    Colors.blueAccent,
    Colors.cyan
  ];
  TransactionList({Key key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Transaction>>(
        future: service.getTransactions(),
        builder: (context, snapshot) => ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 3,
          ),
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) => Container(
            width: size.width * .9,
            decoration: BoxDecoration(
              color: colorList[index],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              title: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Compania:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${snapshot.data[index].company}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              subtitle: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Data tranzactiei:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${snapshot.data[index].dateOfSale}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                  width: size.width * .44,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Suma tranzactiei:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${snapshot.data[index].amount} lei",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Adress:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ${snapshot.data[index].salesPoint}",
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
