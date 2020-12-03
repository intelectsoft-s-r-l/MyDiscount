import 'package:MyDiscount/models/company_model.dart';
import 'package:flutter/material.dart';

import 'companie_widget.dart';

class CompaniesList extends StatelessWidget {
  const CompaniesList(this.list);
  final List<Company>list;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(
        height: 3,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2.0,
        child: CompanyWidget(list[index]),
      ),
    );
  }
}
