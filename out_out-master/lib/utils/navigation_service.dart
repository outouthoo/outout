import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }

  Future<dynamic> navigateToReplacement(String routeName) {
    return navigationKey.currentState.pushReplacementNamed(routeName);
  }

  Future<dynamic> navigateToRemoveUntil(String routeName, Object args) {
    return navigationKey.currentState.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: args);
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigationKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateToRoute(MaterialPageRoute routeName) {
    return navigationKey.currentState.push(routeName);
  }

  goBack(value) {
    return navigationKey.currentState.pop(value);
  }
}
