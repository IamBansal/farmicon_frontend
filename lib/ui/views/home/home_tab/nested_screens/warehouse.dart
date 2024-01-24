part of '../tab.dart';

class WarehouseSubpage extends StatelessWidget {
  WarehouseSubpage({required HomeViewModel model, Key? key}) : super(key: key) {
    // model.fetchWarehouses();
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
                      model.imageUrlMap['Storage'] ?? '',
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
                            AppLocalization.of(context).getTranslatedValue('warehouseInfoHeader').toString(),
                            style: AppTheme.vendorDataTitleStyle,
                          ),
                          AText(
                            model.textsMap['warehouseInfoCollapsed']![
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
                      AppLocalization.of(context).getTranslatedValue('warehouseInfoHeader').toString(),
                      style: AppTheme.vendorDataTitleStyle,
                    ),
                    SizedBox(height: 8.r),
                    Align(
                      alignment: Alignment.center,
                      child: AImage(
                        model.imageUrlMap['Storage']! ?? '',
                        width: 280.r,
                      ),
                    ),
                    SizedBox(height: 8.r),
                    AText(
                      '${model.textsMap['warehouseInfoExpanded']![AppLocalization.of(context).locale]}\n',
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
    //           AppLocalization.of(context).getTranslatedValue('warehouseSectionHeader').toString(),
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
    //           child: (model.warehouses.isNotEmpty)
    //               ? Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: List<Widget>.generate(
    //                     model.warehouses.length,
    //                     (index) => VendorInfoCard(model.warehouses[index]),
    //                   ),
    //                 )
    //               : const Center(
    //                   child: CircularProgressIndicator(color: AppTheme.primary),
    //                 ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    addMarkers();
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: markers.first.position, zoom: 12)));
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(29.87594898766918, 77.89665493774467),
          zoom: 12.0,
        ),
        markers: Set.from(markers),
      ),
    );
  }

  late GoogleMapController mapController;
  List<Marker> markers = [];

  void addMarkers() {
    List<LatLng> coordinates = const [
      LatLng(29.87594898766918, 77.89665493774467),
      LatLng(29.872971971367242, 77.89305004897001),
      LatLng(29.883093464246727, 77.91313442928599),
      LatLng(29.820115151541316, 77.7740887194061),
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
