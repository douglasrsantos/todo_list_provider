// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';

class TodoListLogo extends StatelessWidget {
  const TodoListLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo.png',
          height: 200,
        ),
        Text(
          'Lista de Tarefas',
          style: context.textTheme.headline6,
        ),
      ],
    );
  }
}
