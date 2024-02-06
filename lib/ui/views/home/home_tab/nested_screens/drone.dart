part of '../tab.dart';

class DroneSubpage extends StatelessWidget {
  DroneSubpage({required HomeViewModel model, Key? key}) : super(key: key) {
    model.fetchDroneCenters();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildInfoHeader(HomeViewModel model) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
        child: exp.ExpandableNotifier(
          child: exp.ExpandablePanel(
            collapsed: Material(
              elevation: 5,
              type: MaterialType.card,
              borderRadius: BorderRadius.circular(8.r),
              color: AppTheme.dirtyWhite,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.r, 20.r, 16.r, 12.r),
                child: Row(
                  children: <Widget>[
                    AImage(
                      model.imageUrlMap['Drone']!,
                      width: 65.r,
                    ),
                    SizedBox(width: 20.r),
                    SizedBox(
                      width: 210.r,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AText(
                            AppLocalization.of(context).getTranslatedValue('droneInfoHeader').toString(),
                            style: AppTheme.vendorDataTitleStyle,
                          ),
                          AText(
                            model.textsMap['droneInfoCollapsed']![
                                AppLocalization.of(context).locale]!,
                            style: AppTheme.otpInstructionsStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 18 / 12,
                              color: AppTheme.text,
                            ),
                          ),
                          AText(
                            AppLocalization.of(context).getTranslatedValue('readMore').toString(),
                            style: AppTheme.readMoreStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            expanded: Material(
              elevation: 5,
              type: MaterialType.card,
              borderRadius: BorderRadius.circular(8.r),
              color: AppTheme.dirtyWhite,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 8.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AText(
                      AppLocalization.of(context).getTranslatedValue('droneInfoHeader').toString(),
                      style: AppTheme.vendorDataTitleStyle,
                    ),
                    SizedBox(height: 8.r),
                    Align(
                      alignment: Alignment.center,
                      child: AImage(
                        model.imageUrlMap['Drone']!,
                        width: 280.r,
                      ),
                    ),
                    SizedBox(height: 8.r),
                    AText(
                      '${model.textsMap['droneInfoExpanded']![AppLocalization.of(context).locale]}\n',
                      style: AppTheme.otpInstructionsStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 18 / 12,
                        color: AppTheme.text,
                      ),
                    ),
                    AText(
                      AppLocalization.of(context).getTranslatedValue('readLess').toString(),
                      style: AppTheme.readMoreStyle,
                    ),
                  ],
                ),
              ),
            ),
            theme: const exp.ExpandableThemeData(
              tapBodyToExpand: true,
              tapBodyToCollapse: true,
            ),
          ),
        ),
      );
    }

    final model = Provider.of<HomeViewModel>(context, listen: true);

    // return ListView(
    //   children: <Widget>[
    //     // buildInfoHeader(model),
    //     Align(
    //       alignment: Alignment.centerLeft,
    //       child: Padding(
    //         padding: EdgeInsets.fromLTRB(
    //           25.r,
    //           12.r,
    //           32.r,
    //           15.r,
    //         ),
    //         child: AText(
    //           AppLocalization.of(context).getTranslatedValue('droneCenterSectionHeader').toString(),
    //           style: AppTheme.h3.copyWith(
    //             color: AppTheme.text,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 15.r),
    //       child: Material(
    //         elevation: 5,
    //         borderRadius: BorderRadius.circular(8.r),
    //         type: MaterialType.card,
    //         color: AppTheme.dirtyWhite,
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
    //           child: (model.droneCenters.isNotEmpty)
    //               ? Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: List<Widget>.generate(
    //                     model.droneCenters.length,
    //                     (index) => VendorInfoCard(model.droneCenters[index]),
    //                   ),
    //                 )
    //               : const Center(
    //                   child: CircularProgressIndicator(
    //                     color: AppTheme.primary,
    //                   ),
    //                 ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    addMarkers();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: markers.first.position, zoom: 12)));
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(29.86468003990907, 77.89429986090441),
                zoom: 12.0,
              ),
              markers: Set.from(markers),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF3EDFD)),
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: Center(child: Text(locations[index], textAlign: TextAlign.center,)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> locations = const [
    'Near Masjid, Azad Nagar, Rajendra Nagar, Roorkee, Shafipur, Uttarakhand 247667',
    '22-23, Yadavpuri Rd, Ambedkar Nagar, Roorkee, Shafipur, Uttarakhand 247667',
    'Indian Institute of Technology Roorkee, Roorkee, Uttarakhand 247667',
    'Balelpur Majra Harjauli J, Uttarakhand 247667'
  ];

  late GoogleMapController mapController;
  List<Marker> markers = [];

  void addMarkers() {
    List<LatLng> coordinates = const [
      LatLng(29.86864584837445, 77.87432967489508),
      LatLng(29.873676641960163, 77.8761376188956),
      LatLng(29.86468003990907, 77.89429986090441),
      LatLng(29.841375650870205, 77.8362117315268),
    ];

    for (var coord in coordinates) {
      markers.add(
        Marker(
          markerId: MarkerId(coord.toString()),
          position: coord,
          draggable: false,
          infoWindow: InfoWindow(
            title: 'Marker at (${coord.latitude}, ${coord.longitude})',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _currentLocation;

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _currentLocation = await _location.getLocation();

    mapController.animateCamera(
      CameraUpdate.newLatLng(LatLng(_currentLocation.latitude!, _currentLocation.longitude!)),
    );
  }
}