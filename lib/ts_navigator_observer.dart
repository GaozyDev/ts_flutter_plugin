import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ts_flutter_plugin/ts_flutter_plugin_platform_interface.dart';

class TSNavigatorObserver extends NavigatorObserver {
  var tsFlutterPluginPlatform = TsFlutterPluginPlatform.instance;

  List<String> pages = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print(
          'didPush - route: ${route.settings.name} ${route.settings.arguments} '
          'previousRoute: ${previousRoute?.settings.name} ${previousRoute?.settings.arguments}');
    }

    var arguments = route.settings.arguments != null
        ? jsonEncode(route.settings.arguments).toString()
        : "";

    if (route.settings.name != null) {
      if (pages.isEmpty) {
        tsFlutterPluginPlatform.event("应用启动", {});
        pages.add(route.settings.name!);
        tsFlutterPluginPlatform.eventViewPage(pages.last, arguments);
      } else if (previousRoute?.settings.name != null &&
          previousRoute?.settings.name == pages.last) {
        pages.add(route.settings.name!);
        tsFlutterPluginPlatform.eventViewPageStop();
        tsFlutterPluginPlatform.eventViewPage(pages.last, arguments);
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print(
          'didPop - route: ${route.settings.name} ${route.settings.arguments} '
          'previousRoute: ${previousRoute?.settings.name} ${previousRoute?.settings.arguments}');
    }

    if (route.settings.name != null &&
        pages.isNotEmpty &&
        route.settings.name == pages.last) {
      pages.removeLast();
      tsFlutterPluginPlatform.eventViewPageStop();
      if (pages.isNotEmpty) {
        tsFlutterPluginPlatform.eventViewPage(pages.last, "");
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      print(
          'didReplace - newRoute: ${newRoute?.settings.name} ${newRoute?.settings.arguments} '
          'oldRoute: ${oldRoute?.settings.name} ${oldRoute?.settings.arguments}');
    }

    if (newRoute != null &&
        newRoute.settings.name != null &&
        oldRoute != null &&
        oldRoute.settings.name != null) {
      if (pages.isNotEmpty && oldRoute.settings.name == pages.last) {
        var arguments = newRoute.settings.arguments != null
            ? jsonEncode(newRoute.settings.arguments).toString()
            : "";
        pages.removeLast();
        pages.add(newRoute.settings.name!);
        tsFlutterPluginPlatform.eventViewPageStop();
        tsFlutterPluginPlatform.eventViewPage(pages.last, arguments);
      }
    }
  }
}
