import 'package:desafio_mobile/helpers/routes.dart';
import 'package:desafio_mobile/viewmodel/home_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late MapController _mapController;
  late bool _isLoading;
  LocationData? _location;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _isLoading = true;
    _handleGetLocation();
    _mapController.onReady.then((_) {
      HomeViewModel.saveAnalyticsRender();
    });
  }

  void _handleGetLocation() {
    HomeViewModel.getLocation().then((value) {
      setState(() {
        _location = value;
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _location = null;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem vindo ${FirebaseAuth.instance.currentUser!.email}"),
        actions: [
          TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.login, (route) => false);
                });
              },
              child: const Text("Sair"))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _location == null
              ? Column(
                  children: [
                    const Text(
                        "É necessário ativar a localização para continuar"),
                    ElevatedButton(
                      child: const Text(""),
                      onPressed: () {
                        setState(() => _isLoading = true);
                        _handleGetLocation();
                      },
                    )
                  ],
                )
              : Center(
                  child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                      center:
                          LatLng(_location!.latitude!, _location!.longitude!),
                      zoom: 13),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://api.tomtom.com/map/1/tile/basic/main/"
                          "{z}/{x}/{y}.png?key={apiKey}",
                      additionalOptions: {
                        "apiKey": "ZpNAENRl31kBASqeTEuFPxEFMAJKAPSa"
                      },
                    ),
                    MarkerLayerOptions(markers: [
                      Marker(
                        height: 80,
                        width: 80,
                        point:
                            LatLng(_location!.latitude!, _location!.longitude!),
                        builder: (BuildContext context) => Stack(
                          children: [
                            Icon(Icons.location_on,
                                size: 60.0,
                                color: Theme.of(context).colorScheme.primary),
                            Positioned(
                                bottom: 22,
                                left: 17,
                                child: Container(
                                  width: 24,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                        Radius.elliptical(24, 4)),
                                  ),
                                ))
                          ],
                        ),
                      )
                    ])
                  ],
                )),
    );
  }
}
