import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../aplication/auth/auth_bloc.dart';
import '../../../aplication/bottom_navigation_bar_bloc/bottom_navigator_bar_bloc.dart';
import '../../../aplication/profile_bloc/profile_form_bloc.dart';

import '../../pages/home_page.dart';
import '../../pages/news_page.dart';
import '../../pages/qr_page.dart';
import '../../widgets/bottom_navigator/ripple_animation.dart';

import 'bottom_navigation_bar_item.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  void initState() {
    context.read<BottomNavigatorBarBloc>().add(QrIconTapped());
    /* Future.delayed(const Duration(minutes: 2), () {
      getIt<LocalRepository>()
        ..deleteLocalUser()
        ..getLocalClientInfo();
      context.read<AuthBloc>().add(AuthCheckRequested());
    }); */
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<ProfileFormBloc>(context).add(const UpdateProfileData());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthUnauthorized) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }, child: BlocBuilder<BottomNavigatorBarBloc, BottomNavigatorBarState>(
          builder: (context, state) {
        if (state is HomePageState) {
          return const HomePage();
        }
        if (state is NewsPageState) {
          return const NotificationPage();
        }
        return const QrPage();
      })),
      bottomNavigationBar:
          BlocBuilder<BottomNavigatorBarBloc, BottomNavigatorBarState>(
        builder: (context, state) {
          return SafeArea(
            top: true,
            bottom: true,
            maintainBottomViewPadding: true,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: 2,
                      color: Colors.grey[200]!,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      blurRadius: 0.1,
                      spreadRadius: 1.5,
                    )
                  ]),
              height: 60,
              child: Row(
                children: [
                  BottomNavigationItem(
                    state: state is HomePageState,
                    localizationKey: 'home',
                    icon: Icons.home,
                    event: () {
                      context
                          .read<BottomNavigatorBarBloc>()
                          .add(HomeIconTapped());
                      context.read<ProfileFormBloc>().add(const UpdateProfileData());
                    },
                  ),
                  const QrButton(),
                  BottomNavigationItem(
                    state: state is NewsPageState,
                    icon: MdiIcons.newspaper,
                    localizationKey: 'news',
                    event: () {
                      context
                          .read<BottomNavigatorBarBloc>()
                          .add(NewsIconTapped());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QrButton extends StatelessWidget {
  const QrButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: () {
          context.read<BottomNavigatorBarBloc>().add(QrIconTapped());
        },
        child: Container(
          alignment: Alignment.topCenter,
          color: Colors.white,
          child: const RipplesAnimation(),
        ),
      ),
    );
  }
}
