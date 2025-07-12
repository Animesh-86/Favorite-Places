import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;

  const GradientScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: drawer,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        title: Text(
          title,
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: actions,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF2A2A2A),
              Color(0xFF3A3A3A),
            ],
          ),
        ),
        child: body,
      ),
    );
  }
}
