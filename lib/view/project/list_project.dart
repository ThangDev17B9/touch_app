import 'package:flutter/material.dart';
import 'package:touch_full_screenshot/view/project/item/item_project.dart';

class ListProject extends StatelessWidget {
  const ListProject({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LIST PROJECT'),),
      body: ListView.builder(itemBuilder: (context, index) {
        return ItemProject();
      },),
    );
  }
}
