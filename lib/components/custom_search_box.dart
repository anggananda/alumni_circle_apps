import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Function onChanged;
  final Function onClear;
  final String hintText;

  const CustomSearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: [Colors.white, thirdColor.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => onChanged(value),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: primaryFontColor.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: primaryFontColor),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: primaryFontColor),
                  onPressed: () {
                    controller.clear();
                    onClear();
                  },
                )
              : null,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
        style: TextStyle(color: primaryFontColor),
      ),
    );
  }
}
