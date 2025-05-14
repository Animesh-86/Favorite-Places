import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const GradientScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E3C72),
            Color(0xFF2A5298),
          ], // Professional blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ], // Darker gradient for AppBar
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white, // White text for visibility
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: actions,
            ),
          ),
        ),
        body: Stack(
          children: [
            body, // your main content
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.05,
                ), // Slightly transparent overlay for better text visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
