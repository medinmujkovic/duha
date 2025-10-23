import 'package:flutter/material.dart';
import '../states/auth_state.dart';

class AuthMessages extends StatelessWidget {
  final AuthState authState;
  const AuthMessages({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    if (authState.errorMessage?.isNotEmpty ?? false) {
      return _buildMessage(
        icon: Icons.error_outline,
        color: Colors.red,
        text: authState.errorMessage!,
      );
    }
    if (authState.infoMessage?.isNotEmpty ?? false) {
      return _buildMessage(
        icon: Icons.check_circle_outline,
        color: Colors.green,
        text: authState.infoMessage!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMessage({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text, style: TextStyle(color: color, fontSize: 14)))
        ],
      ),
    );
  }
}
