import 'dart:io';

import 'package:flutter/material.dart';

import '../../infrastructure/core/device_info_service.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../../injectable.dart';
import '../widgets/custom_app_bar.dart';

class TechnicDetailPage extends StatefulWidget {
  const TechnicDetailPage();

  @override
  _TechnicDetailPageState createState() => _TechnicDetailPageState();
}

class _TechnicDetailPageState extends State<TechnicDetailPage> {
  @override
  void initState() {
    super.initState();
    getIt<DeviceInfoService>().getDeviceInfo();
  }

  final initialData = {
    'systemVersion': '',
    'name': '',
    'model': '',
  };

  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)!.settings.arguments as String?;
    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: FutureBuilder<Map<String, dynamic>?>(
          initialData: initialData,
          future: getIt<DeviceInfoService>().getDeviceInfo(),
          builder: (context, snapshot) {
            final map = snapshot.data!;
            return snapshot.hasData
                ? Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        if (Platform.isAndroid)
                          ListTile(
                            title: Text(AppLocalizations.of(context)
                                .translate('manufacture')),
                            trailing: Text('${map['name'] as String}'),
                          ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)
                              .translate('model')),
                          trailing: Text('${map['model']}'),
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)
                              .translate('version')),
                          trailing: Text('${map['systemVersion']}'),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }
}
