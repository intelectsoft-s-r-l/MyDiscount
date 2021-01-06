import 'package:flutter/material.dart';

import '../models/tranzaction_model.dart';
import '../services/transactions_service.dart';

class TransactionList extends StatelessWidget {
  final TransactionService service = TransactionService();

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
  TransactionList({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            color: Colors.white,
            child: FutureBuilder<List<Transaction>>(
              future: service.getTransactions(),
              builder: (context, snapshot) => snapshot.data != null
                  ? ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: 3,
                      ),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data.length == 0) {
                          return Container(
                            child: Center(
                              child: Text('Nu aveti tranzactii efectuate !'),
                            ),
                          );
                        }
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Adress:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " ${snapshot.data[index].salesPoint}",
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
