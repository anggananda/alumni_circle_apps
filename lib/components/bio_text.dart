import 'package:flutter/material.dart';

class BioText extends StatelessWidget {
  final String label;
  final String value;

  const BioText({super.key, 
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10), // Adding space between label and value
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87.withOpacity(0.7),
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}