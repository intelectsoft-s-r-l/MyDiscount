import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_discount/infrastructure/core/permisions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../aplication/card_bloc/add_card_page_bloc.dart';
import '../../domain/entities/company_model.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../../injectable.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage();
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _controller = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final FocusNode _node = FocusNode();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scann = false;

  @override
  void initState() {
    super.initState();
    _node.requestFocus();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((value) {
      getValue(value.code);
    });
  }

  void getValue(String value) {
    debugPrint(value);
    _controller.text = value;
    controller?.stopCamera();
    setState(() {
      scann = false;
    });
  }

  Future<bool> checkPermissions() async {
    final status = await PermissionHandler.hasCameraPermision();
    if (status == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Widget _buildQrView(BuildContext context) {
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.green,
            borderRadius: 10,
            borderLength: 50,
            borderWidth: 10,
            cutOutSize: 220,
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * .4,
          bottom: 10,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.green),
                    side: const BorderSide(color: Colors.green),
                    primary: Colors.white,
                    onPrimary: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  setState(() {
                    scann = false;
                    if (_controller.text.isNotEmpty) {
                      _controller.text = '';
                    }
                  });
                },
                child: const Icon(Icons.close_outlined)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Set<Object>;
    final company = arguments.first as Company;
    final fromCompany = arguments.last as bool;
    return !scann
        ? BlocProvider(
            create: (context) => getIt<AddCardPageBloc>(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Platform.isAndroid
                      ? Icons.arrow_back_sharp
                      : Icons.arrow_back_ios_sharp),
                  onPressed: () {
                    if (fromCompany) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context)..pop()..pop();
                    }
                  },
                ),
                centerTitle: true,
                title: Text(
                  '${AppLocalizations.of(context).translate('connectcard')} ${company.name}',
                  style: const TextStyle(fontSize: 18),
                ),
                elevation: 0,
              ),
              body: Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: BlocConsumer<AddCardPageBloc, AddCardPageState>(
                        listener: (context, state) {
                          if (state is SavedCardForm) {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/cardlist'));
                          }
                          if (state is CardError) {
                            Flushbar(
                              message: state.error,
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          }
                          context
                              .read<AddCardPageBloc>()
                              .add(CompanyChanged(company));
                        },
                        builder: (context, state) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  height: 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Image.memory(company.logo)],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .05,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('inputcardnumber'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * .9,
                                  child: Form(
                                    key: _key,
                                    child: TextFormField(
                                      focusNode: _node,
                                      controller: _controller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        suffixIcon: Tooltip(
                                          preferBelow: false,
                                          message: AppLocalizations.of(context)
                                              .translate('scancard'),
                                          child: InkWell(
                                            onTap: () async {
                                              if (await checkPermissions()) {
                                                setState(() {
                                                  scann = !scann;
                                                });
                                              }
                                            },
                                            child: const Icon(
                                              Icons.fit_screen,
                                            ),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      // ignore: missing_return
                                      validator: (code) {
                                        if (code!.isEmpty) {
                                          return AppLocalizations.of(context)
                                              .translate('addcardnum');
                                        }
                                      },
                                      onSaved: (input) {
                                        _controller.text = input as String;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_key.currentState!.validate()) {
                                          _key.currentState!.save();
                                          _node.unfocus();
                                          context.read<AddCardPageBloc>().add(
                                              SaveNewCard(company,
                                                  _controller.text, context));
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('addcard'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : _buildQrView(context);
  }
}
