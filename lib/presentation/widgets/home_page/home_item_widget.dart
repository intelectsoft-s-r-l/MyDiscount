import 'package:flutter/material.dart';
import 'package:my_discount/infrastructure/core/localization/localizations.dart';

class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({
    Key? key,
    this.icon,
    required this.localisationKey,
    required this.routeName,
  }) : super(key: key);
  final IconData? icon;
  final String localisationKey;
  final String routeName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(routeName,
                arguments: AppLocalizations.of(context)
                    .translate(localisationKey) );
          },
          child: ListTile(
            leading:
                icon != null ? Icon(icon, size: 35, color: Colors.green) : null,
            title: Text(
              AppLocalizations.of(context).translate(localisationKey)
                  ,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
