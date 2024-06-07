import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
           CupertinoActivityIndicator(
            radius: 30.0,
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
