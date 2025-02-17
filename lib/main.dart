import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:touch_full_screenshot/controller/graph_ql_config.dart';
import 'package:touch_full_screenshot/view/home/bubble/custom_bubble.dart';
import 'package:touch_full_screenshot/view/home/my_home_app.dart';
import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  final client = GraphQlConfig.initializeClient();
  runApp(GraphQLProvider(
    client: client,
    child: MyApp(),
  ));
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomBubble(),
    ),
  );
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
