import 'package:flutter/material.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.isReadOnly,
    required this.keyboardType,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final String initialValue;
  final bool isReadOnly;
  final TextInputType keyboardType;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          Container(
            child: TextFormField(
              keyboardType: keyboardType,
              initialValue: initialValue,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusColor: Colors.red,
              ),
              onChanged: onChanged,
              readOnly: isReadOnly,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
