import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../aplication/qr_page/qr_bloc.dart';
import '../../aplication/qr_page/timer_bloc/ticker.dart';
import '../../aplication/qr_page/timer_bloc/timer_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nointernet_widget.dart';
import '../widgets/qr_page_widgets/human_image_widget.dart';
import '../widgets/qr_page_widgets/qr-widget.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QrBloc()..add(LoadQrData(0)),
        ),
        BlocProvider(create: (context) => TimerBloc(const Ticker()))
      ],
      child: CustomAppBar(
        title: AppLocalizations.of(context).translate('qr'),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<QrBloc, QrState>(
                  builder: (context, state) {
                if (state is QrLoaded && state.iteration < 3 ||
                    state is QrLoading) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: size.height * .06,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('showqr'),
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        AppLocalizations.of(context).translate('qrtime'),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  );
                }
                return Container();
              }),
              Expanded(
                child: Center(
                  child: BlocConsumer<QrBloc, QrState>(
                    listener: (context, state) {
                      if (state is QrLoaded) {
                        Provider.of<TimerBloc>(context, listen: false)
                            .add(TimerStarted(
                          duration: 10,
                          iteration: state.iteration,
                        ));
                      }
                    },
                    builder: (context, state) {
                      if (state is QrLoaded) {
                        return state.iteration < 3
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  QrImageWidget(
                                    size: size,
                                    future: state.qrString,
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const HumanImage(),
                                  const SizedBox(height: 10.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<QrBloc>().add(LoadQrData(0));
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('generate'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      } else if (state is QrError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const NoInternetWidget(),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                context.read<QrBloc>().add(LoadQrData(0));
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('retry'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgresIndicatorWidget(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
