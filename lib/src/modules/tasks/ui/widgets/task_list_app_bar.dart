import 'package:flutter/material.dart';

class TaskListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskListAppBar({
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      scrolledUnderElevation: 0,
      shadowColor: Colors.black26,
      title: Text(
        'Taski',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.blueGrey.shade800,
          fontSize: 20,
        ),
      ),
      titleSpacing: 20,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            spacing: 12,
            children: [
              Text(
                'John',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade800,
                  fontSize: 16,
                ),
              ),
              SizedBox.square(
                dimension: 32,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade50,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/56937988?v=4',
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
