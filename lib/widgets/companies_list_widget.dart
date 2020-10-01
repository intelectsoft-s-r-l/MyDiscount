import 'package:flutter/material.dart';

import '../widgets/companie_widget.dart';

class CompaniesList extends StatelessWidget {
  const CompaniesList(this.list);
  final list;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      separatorBuilder: (context, index) => const SizedBox(
        height: 3,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2.0,
        child: CompanieWidget(list[index]),
      ),
    );
  }
}
