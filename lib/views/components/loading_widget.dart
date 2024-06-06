import 'package:flutter/cupertino.dart';

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
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500
            ),
          ),
          const CupertinoActivityIndicator(
            radius: 25.0,
          )
        ],
      ),
    );
  }
}
