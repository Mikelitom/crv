// lib/core/models/inspection_models.dart
import 'package:flutter/material.dart';

class StatsModel {
  final String value;
  final String label;
  final Color color;

  StatsModel({required this.value, required this.label, this.color = Colors.red});
}

class ActionCardModel {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  ActionCardModel({
    required this.title, 
    required this.description, 
    required this.icon, 
    required this.onTap
  });
}