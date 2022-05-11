import 'package:flutter/material.dart';

SnackbarError(GlobalKey<ScaffoldState> snackBarKey, String textSnack) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            textSnack,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white,),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color.fromARGB(255, 219, 64, 13),
    );
    snackBarKey.currentState?.showSnackBar(snackBar);
  }