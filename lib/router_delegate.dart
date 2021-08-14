library flutter_web_router;

import 'package:flutter/material.dart';
import 'package:flutter_web_router/app_page_route.dart';
import 'package:flutter_web_router/router_service.dart';

class AppRouterDelegate extends RouterDelegate<List<AppPageRoute>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<AppPageRoute>> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppRouterDelegate({required this.routerService}) {
    routerService.addListener(() {
      notifyListeners();
    });
  }

  RouterService routerService;

  @override
  List<AppPageRoute> get currentConfiguration {
    return routerService.allRoutes;
  }

  @override
  Future<void> setNewRoutePath(List<AppPageRoute> configuration) async {
    routerService.setRoutes(configuration);
  }

  @override
  Widget build(BuildContext context) {
    return routerService.allPages.isNotEmpty
        ? Navigator(
            key: routerService.navigatorKey,
            pages: [
              ...routerService.allPages,
              //if (currentConfiguration.isNotEmpty ? currentConfiguration.last.isUnknown : true) unknownPage,
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }
              routerService.pop();

              return true;
            },
          )
        : Container();
  }
}
