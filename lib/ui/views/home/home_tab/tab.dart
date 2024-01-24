import 'dart:math';
import 'package:expandable/expandable.dart' as exp;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../models/crop_analysis.dart';
import '../../../../services/app_localizations.dart';
import '../../../../config/environment_config.dart';
import '../../../../constants/app_assets.dart';
import '../../../../models/crop_price.dart';
import '../../../../models/weather.dart';
import '../../../../viewmodels/home.dart';
import '../../../app_theme.dart';
import '../../../components/image.dart';
import '../../../components/scheme_info_card.dart';
import '../../../components/text.dart';
import '../../../components/vendor_info_card.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

part 'components/crop_price.dart';
part 'components/gov_schemes.dart';
part 'components/org_farming.dart';
part 'components/shortcuts.dart';
part 'components/weather_and_location_header.dart';
part 'nested_screens/doctor.dart';
part 'nested_screens/drone.dart';
part 'nested_screens/gov_schemes.dart';
part 'nested_screens/home.dart';
part 'nested_screens/insurance.dart';
part 'nested_screens/org_farming.dart';
part 'nested_screens/price.dart';
part 'nested_screens/soil_testing.dart';
part 'nested_screens/warehouse.dart';
part 'nested_screens/weather.dart';
part 'router.dart';

Widget buildHomeTab(BuildContext context) {
  return SafeArea(
    child: Navigator(
      initialRoute: HomeTabRoutes.home,
      key: Get.nestedKey(1),
      onGenerateInitialRoutes: (navState, route) {
        return [
          GetPageRoute(
            page: () => const HomeSubpage(),
            routeName: HomeTabRoutes.home,
          ),
        ];
      },
      onGenerateRoute: HomeTabRouter.generateRoute,
    ),
  );
}
