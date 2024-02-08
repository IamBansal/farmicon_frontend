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
    addMarkers(context);
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => SelectServiceLocation(location: locations[index], marker: markers[index])));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF3EDFD)),
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                      child: Center(child: Text(locations[index], textAlign: TextAlign.center,)),
                    ),
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

  void addMarkers(BuildContext context) {
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
          onTap: () {
            int index = markers.indexWhere((element) => element.position == coord);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectServiceLocation(location: locations[index], marker: markers[index])));
          }
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

class SelectServiceLocation extends StatefulWidget {
  final String location;
  final Marker marker;

  const SelectServiceLocation({required this.location, required this.marker, super.key});

  @override
  State<SelectServiceLocation> createState() => _SelectServiceLocationState();
}

class _SelectServiceLocationState extends State<SelectServiceLocation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.location, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ), textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: 50,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Farmer name',
                    hintStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    hintMaxLines: 1,
                    labelText: 'Farmer name',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: 50,
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Farm location',
                    hintStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    hintMaxLines: 1,
                    labelText: 'Location',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: 50,
                child: TextField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Area size in acres',
                    hintStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    hintMaxLines: 1,
                    labelText: 'Area size',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: 50,
                child: TextField(
                  controller: _cropController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Plant name',
                    hintStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    hintMaxLines: 1,
                    labelText: 'Plant name',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: 50,
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                      const BorderSide(color: Colors.black),
                    ),
                    hintText: 'Date of spray',
                    hintStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    hintMaxLines: 1,
                    labelText: 'Date',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    suffixIcon: IconButton(onPressed: () {
                      selectDate(context);
                    }, icon: const Icon(Icons.calendar_month_outlined)),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  minLines: 1,
                  readOnly: true,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Select a time slot for service',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  spacing: 5.0,
                  children: List<Widget>.generate(
                    _slots.length,
                        (int index) {
                      return ChoiceChip(
                        label: SizedBox(
                            width: 80,
                            child: Center(child: Text(_slots[index]))),
                        selected: false,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedChipIndex = selected ? index : -1;
                          });
                        },
                        backgroundColor: _selectedChipIndex == index
                            ? AppTheme.primary
                            : Colors.white,
                        selectedColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          color: _selectedChipIndex == index
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.5),
                          side: const BorderSide(
                            color: AppTheme.primary,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Do you want them to carry pesticides?',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            RadioListTile(
              activeColor: AppTheme.primary,
              title: const Text('Yes'),
              value: 'Yes',
              groupValue: _selectedChoice,
              onChanged: (value) {
                setState(() {
                  _selectedChoice = value!;
                });
              },
            ),
            RadioListTile(
              activeColor: AppTheme.primary,
              title: const Text('No'),
              value: 'No',
              groupValue: _selectedChoice,
              onChanged: (value) {
                setState(() {
                  _selectedChoice = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                bookDrone();
              },
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r))),
                textStyle: const MaterialStatePropertyAll(AppTheme.h3),
              ),
              child: const AText('Book Drone'),
            ),
          ],
        ),
      ),
    ));
  }

  void bookDrone() async {

    if(_dateController.text.isNotEmpty && _nameController.text.isNotEmpty && _locationController.text.isNotEmpty && _areaController.text.isNotEmpty && _cropController.text.isNotEmpty) {

      String id = (FirebaseAuth.instance.currentUser?.uid)!;

      try {
        final firestore = FirebaseFirestore.instance.collection('dronesBooking');
        DocumentReference newDoc = await firestore.add({
          'date': _dateController.text,
          'addedBy': id,
          'crop': _cropController.text,
          'name': _nameController.text,
          'location': _locationController.text,
          'area': _areaController.text,
          'bookedOn': DateTime.now(),
          'isPesticideRequired': _selectedChoice == 'Yes',
          'timeSlot': _slots[_selectedChipIndex],
          'droneCentre': widget.location,
          'droneCentreLat': widget.marker.position.latitude.toString(),
          'droneCentreLon': widget.marker.position.longitude.toString(),
        });

        await firestore.doc(newDoc.id).update({'bookingId': newDoc.id});

        debugPrint('Drone Booked');
        Fluttertoast.showToast(
          msg: "Drone booking added to database, you will be notified once accepted by the service provider.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        debugPrint('Error booking drone to Firestore: $e');
        Fluttertoast.showToast(
          msg: "Error booking drone",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Fill all details first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selectedDate != null) {
      _dateController.text = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    }
  }

  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  final _cropController = TextEditingController();

  final List<String> _slots = const ['8AM-10AM', '10AM-12PM','12PM-2PM','2PM-4PM','4PM-6PM'];
  int _selectedChipIndex = 0;
  String _selectedChoice = 'Yes';

}
