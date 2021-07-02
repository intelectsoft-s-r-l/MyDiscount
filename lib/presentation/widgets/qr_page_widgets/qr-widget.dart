import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../aplication/qr_page/qr_bloc.dart';
import '../../../aplication/qr_page/timer_bloc/timer_bloc.dart';
import '../../../domain/repositories/is_service_repository.dart';
import '../../../injectable.dart';

class QrImageWidget extends StatefulWidget {
  const QrImageWidget({
    Key? key,
    required this.future,
    required this.size,
  }) : super(key: key);
  final String future;
  final Size size;

  @override
  _QrImageWidgetState createState() => _QrImageWidgetState();
}

class _QrImageWidgetState extends State<QrImageWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
     getIt<IsService>().getCompanyList();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Provider.of<QrBloc>(context, listen: false).add(LoadQrData(0));
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.transparent,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Container(
          width: widget.size.width * .8,
          height: widget.size.width * .8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                child: RepaintBoundary(
                  child: ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (rect) => const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.green,
                      ],
                    ).createShader(rect),
                    child: QrImage(
                      data: widget.future,
                      size: widget.size.width * .6,
                    ),
                  ),
                ),
              )),
              const QrTimer(),
            ],
          ),
        ),
      ),
    );
  }
}

class QrTimer extends StatelessWidget {
  const QrTimer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerRunComplete) {
          final updatedIteration = state.iteration + 1;
          if (state.iteration < 3) {
            BlocProvider.of<QrBloc>(context, listen: false)
                .add(LoadQrData(updatedIteration));
          }
        }
      },
      builder: (context, state) {
        print(state.hashCode);
        return LinearProgressIndicator(
          value: state.duration / 10,
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation(Colors.green),
        );
      },
    );
  }
}
