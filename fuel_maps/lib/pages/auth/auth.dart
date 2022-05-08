import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'login.dart';

class Auth extends HookWidget {
  const Auth({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: Auth());

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}
