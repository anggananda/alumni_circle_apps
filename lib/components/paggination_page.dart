import 'package:flutter/material.dart';

class PaginationButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isEnabled;
  final String buttonTo;

  const PaginationButton({
    required this.color,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
    required this.buttonTo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEnabled ? color : Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: isEnabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: buttonTo == 'decrement' 
          ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 5),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          )
          : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 5),
              Icon(icon, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
