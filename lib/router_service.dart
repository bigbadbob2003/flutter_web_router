library flutter_web_router;

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_web_router/app_page_route.dart';

class RouterService extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppPageRoute initialRoute;

  RouterService(this.initialRoute);

  ListQueue<AppPageRoute> _routeStack = ListQueue<AppPageRoute>();
  Map<String, String>? _currentPathVariables;

  AppPageRoute? get currentRoute => _routeStack.isNotEmpty ? _routeStack.last : null;
  List<AppPageRoute> get allRoutes => _routeStack.toList();
  List<Page> get allPages => _routeStack.map((element) => element.page).toList();

  ///
  List<AppPageRoute> parseRouteInformation(Uri uri) {
    List<AppPageRoute> retVal = [initialRoute];
    AppPageRoute r = initialRoute;

    _currentPathVariables = {};

    for (var pe in uri.pathSegments) {
      if (r.children != null) {
        try {
          var temp = r.children!.firstWhere((element) => element.routePathElements.contains(pe));
          retVal.add(temp);
          r = temp;
        } catch (e) {
          try {
            var temp = r.children!.firstWhere((element) => element.routePathElements.any((element2) => element2.startsWith("{")));
            retVal.add(temp);
            r = temp;
            _currentPathVariables!.addEntries([MapEntry<String, String>(r.routePathElements.first, pe)]);
          } catch (e2) {}
        }
      }
    }

    return retVal;
  }

  String restoreConfiguration(List<AppPageRoute> routes) {
    String url = "";

    for (var route in routes) {
      for (var rpe in route.routePathElements) {
        if (rpe.startsWith('{')) {
          url += _currentPathVariables?[rpe] ?? "";
        } else {
          url += rpe;
        }
        url += "/";
      }
    }

    return url;
  }

  setRoutes(List<AppPageRoute> routes) {
    _routeStack = ListQueue.from(routes);
    notifyListeners();
  }

  String? getPathVariable(String pathId) {
    return _currentPathVariables?[pathId];
  }

  ////

  pushRouteId(String routeId, {Map<String, String>? pathVariables}) {
    if (currentRoute != null && currentRoute!.children != null && currentRoute!.children!.any((element) => element.routeId == routeId)) {
      try {
        var r = currentRoute!.children!.firstWhere((element) => element.routeId == routeId);
        _routeStack.add(r);
        _currentPathVariables = pathVariables;
        notifyListeners();
      } catch (e) {}
    }
  }

  push(AppPageRoute route, Map<String, String> pathVariables) {
    _currentPathVariables = pathVariables;
    _routeStack.add(route);
    notifyListeners();
  }

  pop() {
    if (_routeStack.isNotEmpty) _routeStack.removeLast();
    notifyListeners();
  }
}
