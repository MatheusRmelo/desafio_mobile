import 'package:flutter/material.dart';

SnackBar errorSnackBar(String message) => SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
          textColor: Colors.white, label: 'Fechar', onPressed: () {}),
    );
