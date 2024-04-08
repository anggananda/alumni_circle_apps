import 'package:flutter/material.dart';

class CategoryEvent{
  final String img;
  final String title;
  final VoidCallback onPressed;

  CategoryEvent({required this.img, required this.title, required this.onPressed});
}

List<CategoryEvent> getCategoryEvents(BuildContext context) {
  return [
    CategoryEvent(
      img: 'https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      title: 'Education 📚',
      onPressed: () => Navigator.pushNamed(context, "/cateducation")
    ),
    CategoryEvent(
      img: 'https://images.unsplash.com/photo-1480180566821-a7d525cdfc5e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c3BvcnQlMjBldmVudHxlbnwwfHwwfHx8MA%3D%3D',
      title: 'Sport Competitions ⚽️',
      onPressed: () => Navigator.pushNamed(context, "/catsport")
    ),
    CategoryEvent(
      img: 'https://images.unsplash.com/photo-1477281765962-ef34e8bb0967?q=80&w=1466&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      title: 'Seminars and Webinars 💫',
      onPressed: () => Navigator.pushNamed(context, "/semiwebi")
    ),
    CategoryEvent(
      img: 'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      title: 'Study Program Anniversary 🎊',
      onPressed: () => Navigator.pushNamed(context, "/anniversery")
    ),
    CategoryEvent(
      img: 'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c29jaWFsJTIwc2VydmljZXxlbnwwfHwwfHx8MA%3D%3D',
      title: 'Educare ✨',
      onPressed: () => Navigator.pushNamed(context, "/educare")
    ),
  ];
}