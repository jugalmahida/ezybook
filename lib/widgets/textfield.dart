import 'package:flutter/material.dart';

Widget getTextFiled({
  int? maxLines,
  required String? hintText,
  required TextEditingController? controller,
  required TextInputType? keyboardType,
  required FormFieldValidator? validator,
}) {
  return ValueListenableBuilder(
    valueListenable: controller!,
    builder: (context, value, child) {
      return TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          suffixIcon: (controller.text.isNotEmpty
              ? InkWell(
                  onTap: () {
                    controller.clear();
                  },
                  child: const Icon(Icons.clear_rounded),
                )
              : null),
        ),
        validator: validator,
        style: const TextStyle(fontSize: 18),
      );
    },
  );
}
