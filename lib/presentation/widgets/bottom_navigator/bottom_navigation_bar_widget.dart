import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_discount/aplication/bottom_navigation_bar_bloc/bottom_navigator_bar_bloc.dart';
import 'package:my_discount/aplication/profile_bloc/profile_form_bloc.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/core/localization/localizations.dart';
import '../../pages/home_page.dart';
import '../../pages/news_page.dart';
import '../../pages/qr_page.dart';
import '../../widgets/bottom_navigator/ripple_animation.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<BottomNavigatorBarBloc, BottomNavigatorBarState>(
            builder: (context, state) {
          if (state is HomePageState) {
            return const HomePage();
          }
          if (state is NewsPageState) {
            return const NotificationPage();
          }
          return const QrPage();
        }),
        bottomNavigationBar:
            BlocConsumer<BottomNavigatorBarBloc, BottomNavigatorBarState>(
          listener: (context, state) {},
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
                      name: AppLocalizations.of(context)!.translate('home')!,
                      icon: Icons.home,
                      event: () {
                        context
                            .read<BottomNavigatorBarBloc>()
                            .add(HomeIconTapped());
                        Provider.of<ProfileFormBloc>(context, listen: false)
                            .add(UpdateProfileData());
                      },
                    ),
                    Expanded(
                      child: InkResponse(
                        onTap: () {
                          context
                              .read<BottomNavigatorBarBloc>()
                              .add(QrIconTapped());
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          color: Colors.white,
                          child: const RipplesAnimation(),
                        ),
                      ),
                    ),
                    BottomNavigationItem(
                      state: state is NewsPageState,
                      icon: MdiIcons.newspaper,
                      name: AppLocalizations.of(context)!.translate('news')!,
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
        ));
  }
}

class BottomNavigationItem extends StatelessWidget {
  const BottomNavigationItem({
    Key? key,
    required this.state,
    required this.event,
    required this.icon,
    required this.name,
  }) : super(key: key);
  final bool state;
  final VoidCallback event;
  final IconData icon;
  final String name;
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
              name,
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
