import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 17.0
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
