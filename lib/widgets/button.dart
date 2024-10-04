import 'package:flutter/material.dart';

Row getMainButton({required VoidCallback onPressed, String? name}) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 45,
          child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF24BAEC)),
            onPressed: onPressed,
            child: Text(
              name!,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    ],
  );
}

Row getLinkButton({required VoidCallback onPressed, String? name}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: onPressed,
        child: Text(
          name!,
          style: const TextStyle(color: Colors.orange, fontSize: 15.0),
        ),
      ),
    ],
  );
}
