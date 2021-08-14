import 'package:flutter/material.dart';
import 'package:flutter_web_router/app_page_route.dart';
import 'package:flutter_web_router/route_information_parser.dart';
import 'package:flutter_web_router/router_delegate.dart';
import 'package:flutter_web_router/router_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RouterService>(create: (_) => RouterService(AppRoutes.initialRoute)),
        ],
        builder: (context, child) {
          var rService = context.read<RouterService>();
          final AppRouterDelegate _routerDelegate = AppRouterDelegate(routerService: rService);
          final AppRouteInformationParser _routeInformationParser = AppRouteInformationParser(routerService: rService);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'flutter_web_router example',
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
          );
        });
  }
}

class AppRoutes {
  static const String routes_root = "root";

  static const String routes_page2list = "page2list";
  static const String routes_page2details = "page2details";

  static AppPageRoute initialRoute = AppPageRoute(
    routeId: routes_root,
    routePathElements: [""],
    pageWidget: RootPage(),
    children: [_page2ListRoute],
  );

  static AppPageRoute _page2ListRoute = AppPageRoute(
    routeId: routes_page2list,
    routePathElements: ["page2"],
    children: [_page2DetailsRoute],
    pageWidget: Page2ListPage(),
  );

  static AppPageRoute _page2DetailsRoute = AppPageRoute(
    routeId: routes_page2details,
    routePathElements: ["{itemId}"],
    pageWidget: Page2DetailsPage(),
  );
}

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Root Page"),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () => context.read<RouterService>().pushRouteId(AppRoutes.routes_page2list),
            child: Text("Page2 List"),
          ),
        ),
      ),
    );
  }
}

class Page2ListPage extends StatelessWidget {
  const Page2ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.read<RouterService>().pushRouteId(AppRoutes.routes_page2details, pathVariables: {"{itemId}": "1"}),
              child: Text("Page2 Item 1"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => context.read<RouterService>().pushRouteId(AppRoutes.routes_page2details, pathVariables: {"{itemId}": "2"}),
                child: Text("Page2 Item 2"),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.read<RouterService>().pushRouteId(AppRoutes.routes_page2details, pathVariables: {"{itemId}": "3"}),
              child: Text("Page2 Item 3"),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2DetailsPage extends StatelessWidget {
  const Page2DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? itemId = context.read<RouterService>().getPathVariable("{itemId}");

    return Scaffold(
      appBar: AppBar(
        title: Text("Details Page: ${itemId ?? "Unknown"}"),
      ),
      body: Container(
          child: Center(
        child: Text(itemId ?? "Unknown"),
      )),
    );
  }
}
