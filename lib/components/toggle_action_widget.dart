import 'package:alumni_circle_app/utils/constants.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';

class ReplyActions extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ReplyActions({super.key, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: addButtonColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: deleteButtonColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 1) {
              onEdit();
            } else if (value == 2) {
              showConfirmDeleteDialog(
                context: context,
                onConfirm: onDelete,
              );
            }
          },
        ),
      ],
    );
  }
}
