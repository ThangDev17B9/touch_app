import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:touch_full_screenshot/controller/constant.dart';

class GraphQlConfig {
  static final HttpLink apiGetAllProject = HttpLink(Constant.getProject);

  static final AuthLink authLink =
      AuthLink(getToken: () => 'Bearer ${Constant.token}');

  static ValueNotifier<GraphQLClient> initializeClient() {
    final Link link = authLink.concat(apiGetAllProject);
    print(link);
    return ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }

  static void postInformationFile() {}
}
