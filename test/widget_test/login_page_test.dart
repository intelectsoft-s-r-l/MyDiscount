import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_discount/aplication/auth/sign_in/sign_form_bloc.dart';
import 'package:my_discount/injectable.dart';
import 'package:my_discount/presentation/widgets/login_button_widget.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'test login page',
    (WidgetTester tester) async {
      await tester.pumpWidget(Provider(
        create: (context) => getIt<SignFormBloc>(),
      ));
      await tester.pumpWidget(LoginButton(
          size: const Size(400, 40),
          event: SignInWithGoogle(),
          picture: 'assets/icons/icon_google.svg',
          text: 'SignIn With Google',
          color: const Color(0xFF406BFB)));

      final media = find.byType(MediaQuery);
      final scaffold = find.byType(Scaffold);
      expect(media, findsOneWidget);
      expect(scaffold, findsOneWidget);
    },
    skip: true,
  );
}
