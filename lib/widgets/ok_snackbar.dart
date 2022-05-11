  import 'package:flutter/material.dart';
  
  SnackbarConfirmation(GlobalKey<ScaffoldState> snackBarKey, String text) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.thumb_up_alt_sharp,
            color: Colors.white,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green[800],
    );
    snackBarKey.currentState?.showSnackBar(snackBar);
  }