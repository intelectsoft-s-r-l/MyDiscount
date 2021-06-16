import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../infrastructure/core/localization/localizations.dart';

class HomePageTopWidget extends StatelessWidget {
  HomePageTopWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * .253,
      width: size.width,
      child: BlocConsumer<ProfileFormBloc, ProfileFormState>(
        listener: (context, state) {},
        builder: (context, state) {
          final profile = state.profile;
          return Stack(
            children: [
              Positioned(
                top: (size.height * .253) / 4,
                left: size.width * .2,
                child: SizedBox(
                  width: size.width * .6,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: profile.photo.isNotEmpty
                              ? Image.memory(
                                  profile.photo,
                                  fit: BoxFit.fill,
                                  scale: 0.7,
                                  width: 110,
                                  height: 110,
                                )
                              : Image.asset('assets/icons/profile.png'),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${profile.firstName}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            textScaleFactor: 1.3,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${profile.lastName}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            textScaleFactor: 1.3,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (profile.registerMode == 1)
                        Text(
                          AppLocalizations.of(context)!.translate('signinG')!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 1,
                        ),
                      if (profile.registerMode == 2)
                        Text(
                          AppLocalizations.of(context)!.translate('signinF')!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 1,
                        ),
                      if (profile.registerMode == 3)
                        Text(
                          AppLocalizations.of(context)!.translate('signinA')!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 1,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
