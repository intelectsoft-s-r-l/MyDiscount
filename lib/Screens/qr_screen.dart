import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

import '../services/qr_service.dart';
import '../widgets/localizations.dart';
import '../services/shared_preferences_service.dart';

class QrScreen extends StatefulWidget {
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  QrService service = QrService();
  int countTID = 0;
  bool chengeImage = true;
  @override
  void initState() {
    super.initState();
    getQr();
  }

  void getQr() async {
    countTID++;
    if (countTID == 5) {
      setState(() {
        chengeImage = false;
      });
    } else {
      //await service.attemptSignIn();
    }
  }

  Widget build(BuildContext context) {
    //var service = Provider.of<QrService>(context);
    final SharedPref sPref = SharedPref();
    Future<String> _loadSharedPref() async {
      final id = await sPref.readTID();
      return id;
    }

    return Scaffold(
      backgroundColor: Colors.white70,
      body: chengeImage
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder<String>(
                      future: _loadSharedPref(),
                      builder: (context, snapshot) {
                        return RepaintBoundary(
                          child: QrImage(
                              data: '${snapshot.data}',
                              size: MediaQuery.of(context).size.height * 0.3),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                /* checkCountGetID && serviceConection
                  ? */
                Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.43,
                          child: Image.asset('assets/icons/om.png'),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    )),
                /* : Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.asset('assets/icons/no internet.png'),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            AppLocalizations.of(context).translate('text6'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('text7'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ), */
                const SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: () {
                    /* setState(() {
                    setImage = true;
                    internetStatus = true;
                  });
                  checkInternetConection();
                  countGetID = 0; */
                  },
                  child: /* checkCountGetID
                    ? */
                      Text(
                    AppLocalizations.of(context).translate('text5'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  /*  : Text(
                        AppLocalizations.of(context).translate('text8'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ), */
                  color: Color.fromRGBO(42, 86, 198, 1),
                ),
              ],
            ),
    );
  }
}
