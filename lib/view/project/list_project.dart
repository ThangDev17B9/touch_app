import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:touch_full_screenshot/view/home/my_home_app.dart';

class ListProject extends StatelessWidget {
  const ListProject({super.key});
  @override
  Widget build(BuildContext context) {
    const String getItemsQuery = """
    query{
      projects {
        id
        title
      }
    }
    """;
    return Scaffold(
      appBar: AppBar(title: const Text('List Project')),
      body: Query(
        options: QueryOptions(
          document: gql(getItemsQuery),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            print(result);
            return Center(child: Text(result.exception.toString()));
          }

          final List items = result.data?['projects'] ?? [];
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text("Project: ${item['title']}"),
                onTap: (){
                  Get.to(() => MyHomeApp(), arguments: item['id']);
                },
              );
            },
          );
        },
      ),
    );
  }
}
