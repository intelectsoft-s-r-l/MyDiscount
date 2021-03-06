import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../aplication/profile_bloc/profile_form_bloc.dart';
import '../../../domain/entities/profile_model.dart';

class NewWidget extends StatelessWidget {
  NewWidget({
    Key key,
    @required this.profile,
    this.isEdit,
  }) : super(key: key);
  final _picker = ImagePicker();
  final Profile profile;
  final isEdit;

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
                    'assets/icons/profile.png',
                    width: 110,
                    height: 110,
                  ),
          ),
          isEdit
              ? Positioned(
                  bottom: 0,
                  child: InkResponse(
                    child: Container(
                      alignment: Alignment.center,
                      //padding: EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
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
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    onTap: isEdit
                        ? () async {
                            final file = await _picker.getImage(source: ImageSource.gallery);
                            final bytes = await file?.readAsBytes();
                            context.read<ProfileFormBloc>().add(ImageChanged(bytes));
                          }
                        : null,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

/* import 'package:MyDiscount/aplication/profile_bloc/profile_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileItemWidget extends StatefulWidget {
  ProfileItemWidget({
    Key key,
    this.labelText,
    this.text,
  }) : super(key: key);
  final String labelText;
  final String text;

  @override
  _ProfileItemWidgetState createState() => _ProfileItemWidgetState();
}

class _ProfileItemWidgetState extends State<ProfileItemWidget> {
  bool isReadOnly = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      buildWhen: (prev, curr) => prev != curr,
      builder: (context, state) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.labelText,
                style: const TextStyle(color: Colors.black),
              ),
              InkResponse(
                onTap: () {
                  setState(() {
                    isReadOnly = !isReadOnly;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .6,
                  child: TextFormField(
                    initialValue: state.profile.lastName,
                    decoration: InputDecoration(border: InputBorder.none),
                    onFieldSubmitted: (val) {
                      context.read<ProfileFormBloc>().add(LastNameChanged(val));
                    },
                    readOnly: isReadOnly,
                    style: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
 */
