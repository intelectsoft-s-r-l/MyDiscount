/* import 'package:flutter/material.dart';

import '../widgets/credentials.dart';

class DrawerWidget extends StatelessWidget {
  final List list;
  DrawerWidget(this.list);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Container(
                    height: size.height * .12,
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                      child: snapshot.hasData
                          ? Container(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.network(
                                  "${snapshot.data['PhotoUrl']}",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  snapshot.hasData
                      ? Text('${snapshot.data["DisplayName"]}')
                      : Text(''),
                ],
              );
            },
          ),
          //TODO de vazut poate se poate de adaugat lista de notificari sau noutati concret pentru utilizatorul dat
          //TODO de pridumait cum de adus lista de notificari pin aici
          Container(
            height: size.height * .6,
            child:list?.length != 0
                ? ListView.builder(
                    itemCount:1, //list?.length,
                    itemBuilder: (context, index) => Container(
                      child: Text('{list[index]["title"]}'),
                    ),
                  )
                : Container(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text('Exit'),
          )
        ],
      ),
    );
  }
}
 */