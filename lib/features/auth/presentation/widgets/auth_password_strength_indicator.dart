import 'package:flutter/material.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const PasswordStrengthIndicator({super.key, required this.password});

  // Your same logic for calculating strength
  static int _passwordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink(); // no bar if empty

    final int strength = _passwordStrength(password);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (strength / 4).clamp(0, 1),
            color: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green
            ][strength.clamp(0, 3)],
            backgroundColor: Colors.grey[300],
            minHeight: 6,
          ),
          const SizedBox(height: 8),
          Text(
            _getStrengthMessage(strength),
            style: TextStyle(
              color: [
                Colors.red,
                Colors.orange,
                Colors.yellow[800],
                Colors.green
              ][strength.clamp(0, 3)],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Optional: user feedback messages
  static String _getStrengthMessage(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return "Too weak. Use at least 8 characters.";
      case 2:
        return "Add numbers or special characters.";
      case 3:
        return "Almost strong!";
      case 4:
        return "Strong password 💪";
      default:
        return "";
    }
  }
}
