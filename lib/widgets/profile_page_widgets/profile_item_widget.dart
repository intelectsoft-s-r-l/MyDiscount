import 'package:MyDiscount/aplication/profile_bloc/profile_form_bloc.dart';
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
                      context.read<ProfileFormBloc>().add(LastNameChanged(val,true));
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
