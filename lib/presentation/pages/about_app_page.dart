import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../core/localization/localizations.dart';
import '../widgets/custom_app_bar.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage();
  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  String? appversion;
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((pack) {
      setState(() {
        appversion = pack.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageName = ModalRoute.of(context)!.settings.arguments as String?;

    return CustomAppBar(
      title: pageName,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.translate('welcome')!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                  height: size.height * .45,
                  width: size.width,
                  child: Image.asset(
                    'assets/icons/1.png',
                    fit: BoxFit.fill,
                  )),
              Text(
                '${AppLocalizations.of(context)!.translate('appversion')} $appversion',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.translate('aboutpar.1')!,
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                AppLocalizations.of(context)!.translate('aboutpar.2')!,
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                AppLocalizations.of(context)!.translate('aboutpar.3')!,
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                AppLocalizations.of(context)!.translate('aboutpar.4')!,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/icons/islogo.jpeg',
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
