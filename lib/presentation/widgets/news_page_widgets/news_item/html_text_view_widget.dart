import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 5, bottom: 5),
      child: Html(
        data: data,
        onLinkTap: (url, _, __, ___) async {
         /*  try {
            print(await canLaunch(url!));
            if (await canLaunch(url)) { */
              await launch(url!);
           /*  } else {
              throw Exception();
            }
          } catch (e) {
            print(e);
          } */
        },
      ),
    );
  }
}
