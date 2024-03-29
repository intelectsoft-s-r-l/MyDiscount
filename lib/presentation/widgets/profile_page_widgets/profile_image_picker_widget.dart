import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_discount/infrastructure/core/localization/localizations.dart';
import 'package:my_discount/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../domain/entities/profile_model.dart';

class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker({
    Key? key,
    required this.profile,
    required this.isEdit,
    required this.updateImage,
    required this.forAuth
  }) : super(key: key);
  final _picker = ImagePicker();
  final Profile profile;
  final bool isEdit;
  final Function(bool) updateImage;
  final bool forAuth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: profile.photo.isNotEmpty
                ? Image.memory(
                    profile.photo,
                    fit: BoxFit.cover,
                    scale: 0.7,
                    width: 110,
                    height: 110,
                    filterQuality: FilterQuality.high,
                  )
                : Container(
                    width: 110,
                    height: 110,
                  ),
          ),
          isEdit
              ? Positioned(
                  bottom: 0,
                  child: Tooltip(
                    preferBelow: false,
                    message:
                        AppLocalizations.of(context).translate('changeimg'),
                    child: InkResponse(
                      onTap: () => isEdit ? pickImage(context) : null,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 110,
                        height: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera,
                              color: Colors.white.withOpacity(.5),
                              size: 55,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void getImage(BuildContext context) async {
    try {
      final file = await _picker.getImage(source: ImageSource.gallery);
      final bytes = await file?.readAsBytes() as Uint8List;

      getIt<ProfileFormBloc>().add(ImageChanged(bytes));
      updateImage(true);
    } catch (exception, stack) {
      if (Platform.isAndroid) showSnackBar(context);
      print('error:$exception');
      await FirebaseCrashlytics.instance.recordError(exception, stack);
    }
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      content: Text(AppLocalizations.of(context).translate('permission'),
          style: const TextStyle(color: Colors.black)),
      action: SnackBarAction(
        label: AppLocalizations.of(context).translate('open'),
        onPressed: AppSettings.openAppSettings,
      ),
    ));
  }

  void pickImage(BuildContext context) async {
    if (Platform.isIOS) {
      await Permission.photos.request();
      if (await Permission.photos.status.isGranted &&
          !await Permission.photos.status.isPermanentlyDenied) {
        getImage(context);
      } else {
        showSnackBar(context);
      }
    } else {
      getImage(context);
    }
  }
}
