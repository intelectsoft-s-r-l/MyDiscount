import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_discount/infrastructure/core/localization/localizations.dart';
import 'package:my_discount/injectable.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../domain/entities/profile_model.dart';

class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker({
    Key? key,
    required this.profile,
    required this.isEdit,
  }) : super(key: key);
  final _picker = ImagePicker();
  final Profile profile;
  final bool isEdit;

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
                : Image.asset(
                    'assets/icons/default_profile_img.png',
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
                      onTap: isEdit ? pickImage : null,
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

  void pickImage() async {
    try {
      final file = await _picker.getImage(source: ImageSource.gallery);
      final bytes = await file!.readAsBytes();

      getIt<ProfileFormBloc>().add(ImageChanged(bytes));
    } catch (exception, stack) {
      print('error:$exception');
      await FirebaseCrashlytics.instance.recordError(exception, stack);
    }
  }
}
