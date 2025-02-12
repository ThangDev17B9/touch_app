import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:touch_full_screenshot/controller/graph_ql_config.dart';
import 'package:touch_full_screenshot/view/home/my_home_app.dart';

void main () async {
  await initHiveForFlutter();
  final client = GraphQlConfig.initializeClient();
  runApp(GraphQLProvider(client: client, child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomeApp(),
    );
  }
}

