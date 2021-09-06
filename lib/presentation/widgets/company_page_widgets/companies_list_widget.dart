import 'package:flutter/material.dart';

import '../../../domain/entities/company_model.dart';
import '../company_page_widgets/companie_widget.dart';

class CompaniesList extends StatelessWidget {
  const CompaniesList(this.list, this.fromCompany);
  final List<Company> list;
  final bool fromCompany;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: ListView.separated(
        //physics: BouncingScrollPhysics(),
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
          child: CompanyWidget(list[index], fromCompany),
        ),
      ),
    );
  }
}
