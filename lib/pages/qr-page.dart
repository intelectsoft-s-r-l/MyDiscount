import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';

import '../services/qr_service.dart';
import '../widgets/human_image_widget.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/qr-widget.dart';

class QrPage extends StatefulWidget {
  QrPage({
    Key key,
  }) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> with WidgetsBindingObserver {
  AppLifecycleState _stateofpage;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _stateofpage = state;
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).translate('qr')),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (context) => QrService(),
        child: Container(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: QrPageContainer()),
          ),
        ),
      ),
    );
  }
}

class QrPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
        value: QrService(),
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(builder: (context, QrService provider, _) {
                
                return Expanded(
                  child: Center(
                    child: !provider.showImage
                        ? QrImageWidget(size: size, provider: provider)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              !provider.showNoInet
                                  ? HumanImage()
                                  : NoInternetWidget(),
                              const SizedBox(height: 10.0),
                              RaisedButton(
                                onPressed: () {
                                  provider.showImage = false;
                                  provider.showNoInet = false;
                                  provider.getTID(false);
                                },
                                child: provider.showImage
                                    ? Text(
                                        AppLocalizations.of(context)
                                            .translate('text5'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ), //textScaleFactor: 1,
                                      )
                                    : Text(
                                        AppLocalizations.of(context)
                                            .translate('text8'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ), //textScaleFactor: 1,
                                      ),
                                color: Colors.green,
                              ),
                            ],
                          ),
                  ),
                );
              }),
            ],
          );
        });
  }
}
