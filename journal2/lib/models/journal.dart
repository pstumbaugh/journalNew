import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Journal with ChangeNotifier {
  final String id;
  final String title;
  final String body;
  final int rating;
  final String createdAt;

  Journal({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.rating,
    @required this.createdAt,
  });
}
