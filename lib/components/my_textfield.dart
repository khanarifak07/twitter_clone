// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  MyTextField({
    super.key,
    required this.colorScheme,
    required this.text,
    required this.controller,
    this.isObsecure = false,
    this.isPassField,
    this.maxLength,
    this.maxLines = 1,
  });

  final ColorScheme colorScheme;
  final String text;
  final TextEditingController controller;
  bool isObsecure;
  final bool? isPassField;
  int maxLines;
  int? maxLength;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        obscureText: widget.isObsecure,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.isPassField != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.isObsecure = !widget.isObsecure;
                    });
                  },
                  icon: Icon(
                    widget.isObsecure ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
          hintText: widget.text,
          hintStyle: TextStyle(color: widget.colorScheme.primary),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.colorScheme.tertiary,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
