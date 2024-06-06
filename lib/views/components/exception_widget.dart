import 'package:flutter/material.dart';

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({super.key, required this.errorMessage});
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 16.0
          ),
        ),
      ),
    );
  }
}
