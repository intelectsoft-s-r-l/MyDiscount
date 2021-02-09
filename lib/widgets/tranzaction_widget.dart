import 'package:MyDiscount/domain/entities/tranzaction_model.dart';
import 'package:flutter/material.dart';



class TranzactionWidget extends StatelessWidget {
  const TranzactionWidget({
    Key key,
    @required this.size,
    this.transaction,
  }) : super(key: key);

  final Size size;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding:const EdgeInsets.all(10),
        width: size.width * .96,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * .11,
                        height: size.width * .11,
                        child: Image.memory(
                          transaction.logo,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                          scale: 1,
                        ),
                      ),
                     const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * .50,
                            child: OverflowBar(
                              children: [
                                Text(transaction.company,
                                    style:const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                          OverflowBar(
                            children: [
                             const SizedBox(
                                width: 5,
                              ),
                              Text(
                                transaction.dateOfSale,
                                style:const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      width: size.width * .27,
                      child: OverflowBar(
                        children: [
                          Text(
                            '${transaction.amount} MDL',
                            style:const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
           const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * .9,
                  child:const Text(
                    'Strada Petricani 84, Chișinău 2059',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/* ${transaction.salesPoint} */
