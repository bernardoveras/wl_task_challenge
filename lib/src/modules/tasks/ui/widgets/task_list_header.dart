import 'package:flutter/material.dart';

import '../../../../shared/extensions/build_context_extensions.dart';
import '../../../../shared/extensions/string_extensions.dart';

class TaskListHeader extends StatefulWidget {
  const TaskListHeader({
    super.key,
    required this.taskCount,
    required this.onlyFinished,
    required this.searchMode,
    required this.onSearch,
    required this.onDeleteAll,
  });

  final int taskCount;
  final bool searchMode;
  final bool onlyFinished;
  final ValueChanged<String> onSearch;

  final VoidCallback onDeleteAll;

  @override
  State<TaskListHeader> createState() => _TaskListHeaderState();
}

class _TaskListHeaderState extends State<TaskListHeader> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.onlyFinished
        ? Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  'Completed Tasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                    fontSize: 20,
                  ),
                ),
              ),
              if (widget.taskCount > 0)
                GestureDetector(
                  onTap: widget.onDeleteAll,
                  child: Text(
                    'Delete all',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              if (!widget.searchMode) ...[
                RichText(
                  text: TextSpan(
                    text: 'Welcome, ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                      fontSize: 20,
                    ),
                    children: [
                      TextSpan(
                        text: 'John',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
                Text(
                  widget.taskCount > 0
                      ? "You've got ${widget.taskCount} ${"task".pluralize(widget.taskCount)} to do."
                      : "Create tasks to achieve more.",
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 16,
                  ),
                ),
              ] else
                TextField(
                  autofocus: true,
                  controller: textEditingController,
                  onChanged: (value) {
                    widget.onSearch(textEditingController.text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).primaryColor.withAlpha(5),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        textEditingController.clear();
                        widget.onSearch('');
                        context.hideKeyboard();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          );
  }
}
