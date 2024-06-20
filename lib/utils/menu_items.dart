import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItem {
  final String title;
  final VoidCallback onPressed;
  final String img;

  MenuItem({required this.title, required this.onPressed, required this.img});
}

List<MenuItem> getMenuItems(BuildContext context) {
  final cubit = context.read<ProfileCubit>();
  final currentState = cubit.state;

  List<MenuItem> menuItems = [
    MenuItem(
      title: 'Discussion',
      img: 'assets/images/discussion.png',
      onPressed: () => Navigator.pushNamed(context, '/discussion'),
    ),
    MenuItem(
      title: 'Event',
      img: 'assets/images/event.png',
      onPressed: () => Navigator.pushNamed(context, '/event'),
    ),
    MenuItem(
      title: 'Job Vacancy',
      img: 'assets/images/jobvacancy.png',
      onPressed: () => Navigator.pushNamed(context, '/jobvacancy'),
    ),
    MenuItem(
      title: 'List Event',
      img: 'assets/images/listevent.png',
      onPressed: () => Navigator.pushNamed(context, '/listevent'),
    ),
    MenuItem(
      title: 'List Vacancy',
      img: 'assets/images/listvacancy.png',
      onPressed: () => Navigator.pushNamed(context, '/listvacancy'),
    ),
  ];

  if (currentState.roles == 'admin') {
    menuItems.add(MenuItem(
      title: 'User Control',
      img: 'assets/images/userControl.png',
      onPressed: () => Navigator.pushNamed(context, '/user_control'),
    ));
  }

  return menuItems;
}
