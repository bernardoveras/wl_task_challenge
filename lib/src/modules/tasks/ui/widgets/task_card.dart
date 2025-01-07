import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_checkbox.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    this.description,
    required this.finished,
    required this.onFinishedChanged,
    this.onEdit,
    this.deleteMode = false,
    this.onDelete,
  });

  final String title;
  final String? description;
  final bool finished;
  final ValueChanged<bool> onFinishedChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final bool deleteMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: deleteMode ? null : () => onFinishedChanged(!finished),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 12,
          crossAxisAlignment: description?.isNotEmpty == true
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            IgnorePointer(
              ignoring: deleteMode,
              child: CustomCheckbox(
                value: finished,
                onChanged: onFinishedChanged,
                backgroundColor: deleteMode ? Colors.blueGrey.shade100 : null,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: deleteMode
                                ? Colors.blueGrey.shade200
                                : Colors.blueGrey.shade900,
                            fontSize: 20,
                          ),
                        ),
                        if (description?.isNotEmpty == true)
                          Text(
                            description!,
                            style: TextStyle(
                              color: deleteMode
                                  ? Colors.blueGrey.shade200
                                  : Colors.blueGrey.shade500,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (deleteMode)
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 28,
                      ),
                    )
                  else if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.blueGrey.shade200,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
