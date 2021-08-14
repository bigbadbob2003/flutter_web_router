library flutter_web_router;

import 'package:flutter/material.dart';
import 'package:flutter_web_router/app_page_route.dart';
import 'package:flutter_web_router/router_service.dart';

class AppRouteInformationParser extends RouteInformationParser<List<AppPageRoute>> {
  AppRouteInformationParser({required this.routerService});

  RouterService routerService;

  @override
  Future<List<AppPageRoute>> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    return routerService.parseRouteInformation(uri);
  }

  @override
  RouteInformation? restoreRouteInformation(List<AppPageRoute> configuration) {
    if (configuration.isNotEmpty) {
      return RouteInformation(location: routerService.restoreConfiguration(configuration));
    }

    return super.restoreRouteInformation(configuration);
  }
}
