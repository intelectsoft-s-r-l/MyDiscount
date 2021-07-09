import 'dart:io';
import 'dart:typed_data';

import 'package:my_discount/domain/entities/company_model.dart';

String fixture(String name) =>
    File('test/unit_test/fixtures/$name').readAsStringSync();

/* returnListCompany(){
  return 
};
returnListNews(){
  return 
}; */
List<Company> returnListcompany() {
  return [
    Company(
        amount: 'amount',
        id: 1,
        logo: Uint8List.fromList([]),
        name: 'Company 1'),
  ];
}
/* [{
		"Amount":"String content",
		"ID":2147483647,
		"Logo":"String content",
		"Name":"String content"
	}] 
   Company(
        amount: 'amount1',
        id: 2,
        logo: Uint8List.fromList([]),
        name: 'Company 2')
*/