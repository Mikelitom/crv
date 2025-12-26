import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({ super.key });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {

        }, 
        child: const Text(
          'Ingresar',
          style: TextStyle(fontSize: 16),
        )
      ),
    );
  }
}