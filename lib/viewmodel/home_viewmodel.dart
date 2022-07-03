import 'package:desafio_mobile/helpers/db.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class HomeViewModel {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
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
    LocationData locationData = await location.getLocation();
    var database = await DB.connectToDabase();
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO last_location(uid, latitude, longitude, created_at) VALUES(?, ?, ?, ?)',
          [
            _auth.currentUser!.email,
            locationData.latitude.toString(),
            locationData.longitude.toString(),
            DateFormat("yyyy-MM-dd").format(DateTime.now())
          ]);
    });
    database.close();
    return locationData;
  }

  static Future<void> saveAnalyticsRender() async {
    await _analytics.logScreenView(
        screenName: "Home with map", screenClass: "HomeView");
  }
}
