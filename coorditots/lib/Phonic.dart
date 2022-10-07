import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';


class Phonic {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? voiceUrl;

  Phonic(
    this.title,
    this.subtitle,
    this.imageUrl,
    this.voiceUrl,
  );
}