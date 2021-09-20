import 'package:flutter/material.dart';
import '../../../infrastructure/core/localization/localizations.dart';

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({
    Key? key,
    required this.state,
    required this.event,
    required this.icon,
    required this.localizationKey,
  }) : super(key: key);
  final bool state;
  final VoidCallback event;
  final IconData icon;
  final String localizationKey;
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: event,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .33,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: state ? Colors.green : Colors.black,
            ),
            Text(
              AppLocalizations.of(context).translate(localizationKey),
              style: TextStyle(
                color: state ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
