import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_discount/infrastructure/core/localization/localizations.dart';

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
                    fit: BoxFit.fill,
                    scale: 0.7,
                    width: 110,
                    height: 110,
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
                    message: AppLocalizations.of(context)
                        .translate('changeimg'),
                    child: InkResponse(
                      onTap: isEdit
                          ? () async {
                              try {
                                final file = await _picker.getImage(
                                    source: ImageSource.gallery);
                                final bytes = await file!.readAsBytes();

                                context
                                    .read<ProfileFormBloc>()
                                    .add(ImageChanged(bytes));
                              } catch (e) {
                                print('error:$e');
                              }
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        width: 110,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
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
}