import 'dart:io';

import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';
import '../services/device_info_service.dart';

class TechnicDetailPage extends StatefulWidget {
  const TechnicDetailPage();
  @override
  _TechnicDetailPageState createState() => _TechnicDetailPageState();
}

class _TechnicDetailPageState extends State<TechnicDetailPage> {
  final DeviceInfoService service = DeviceInfoService();
  @override
  void initState() {
    super.initState();
    service.getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    final String pageName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: FutureBuilder(
                future: service.getDeviceInfo(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              if (Platform.isAndroid)
                                ListTile(
                                  title: Text(AppLocalizations.of(context)
                                      .translate('text34')),
                                  trailing: Text('${snapshot.data['name']}'),
                                ),
                              ListTile(
                                title: Text(AppLocalizations.of(context)
                                    .translate('text35')),
                                trailing: Text('${snapshot.data['model']}'),
                              ),
                              ListTile(
                                title: Text(AppLocalizations.of(context)
                                    .translate('text36')),
                                trailing:
                                    Text('${snapshot.data['systemVersion']}'),
                              ),
                            ],
                          ),
                        )
                      : Container();
                }),
          ),
        ),
      ),
    );
  }
}
