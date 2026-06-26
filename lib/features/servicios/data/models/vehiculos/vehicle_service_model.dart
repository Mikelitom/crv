import 'package:flutter/material.dart';

class VehicleUnit {
  final String id;
  final String model;
  final String status;
  final String location;
  final String lastReport;
  final Color statusColor;

  VehicleUnit({
    required this.id,
    required this.model,
    required this.status,
    required this.location,
    required this.lastReport,
    required this.statusColor,
  });
}
class InspectionEntry {
  final String date;
  final String auditor;
  final String comment;
  final String status;
  final String scReference;
  final List<String> photos;
  final Color accentColor;

  InspectionEntry({
    required this.date,
    required this.auditor,
    required this.comment,
    required this.status,
    required this.scReference,
    this.photos = const [],
    required this.accentColor,
  });
}
class InspectionRecord {
  final String date;
  final String author;
  final String title;
  final String comment;
  final String tag;
  final Color color;

  InspectionRecord({
    required this.date,
    required this.author,
    required this.title,
    required this.comment,
    required this.tag,
    required this.color,
  });
  
}