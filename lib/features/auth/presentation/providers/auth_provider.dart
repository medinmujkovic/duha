import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart'; // This will be generated

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() {
    return false; // initial logged out state
  }

  void login() => state = true;
  void logout() => state = false;
}
