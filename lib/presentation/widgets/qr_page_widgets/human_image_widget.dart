import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../aplication/qr_page/qr_bloc.dart';
import '../../../infrastructure/core/localization/localizations.dart';

class HumanImage extends StatefulWidget {
  const HumanImage();

  @override
  _HumanImageState createState() => _HumanImageState();
}

class _HumanImageState extends State<HumanImage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Provider.of<QrBloc>(context, listen: false).add(LoadQrData(0));
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              'assets/icons/human_img.png',
              scale: 0.5,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            AppLocalizations.of(context).translate('generateqrtoomanytimes'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context).translate('generatenewqr'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
