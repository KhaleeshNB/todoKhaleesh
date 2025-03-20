import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.white,
                )
              : Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
        ),
      ),
    );
  }
}
