library flutter_web_router;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppPageRoute {
  final String routeId;
  final List<String> routePathElements;
  final List<AppPageRoute>? children;
  final Widget pageWidget;
  Page get page => MaterialPage(key: ValueKey(routeId), child: pageWidget);

  AppPageRoute({
    required this.routeId,
    required this.pageWidget,
    required this.routePathElements,
    this.children,
  });
}
