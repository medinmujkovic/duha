import 'package:flutter/material.dart';


ThemeData buildTheme() {
final base = ThemeData(useMaterial3: true);
return base.copyWith(
colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
appBarTheme: const AppBarTheme(centerTitle: true),
);
}