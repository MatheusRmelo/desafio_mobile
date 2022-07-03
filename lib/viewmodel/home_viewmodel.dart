import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:location/location.dart';

class HomeViewModel {
  static FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static Future<LocationData?> getLocation() async {
    Location location = Location();
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  static Future<void> saveAnalyticsRender() async {
    await _analytics.logScreenView(
        screenName: "Home with map", screenClass: "HomeView");
  }
}
