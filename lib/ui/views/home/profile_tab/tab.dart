
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_assets.dart';
import '../../../../models/crop_price.dart';
import '../../../../services/app_localizations.dart';
import '../../../../viewmodels/home.dart';
import '../../../app_theme.dart';
import '../../../components/image.dart';
import '../../../components/text.dart';
import '../../../components/text_input.dart';

part 'components/crop_icon.dart';
part 'components/land_area.dart';
part 'components/location_section.dart';
part 'components/my_crops.dart';
part 'components/search_bar.dart';
part 'components/update_crops_button.dart';
part 'components/user_card.dart';
part 'nested_screens/profile.dart';
part 'nested_screens/select_crops.dart';
part 'router.dart';

Widget buildProfileTab(BuildContext context) {
  return SafeArea(
    child: Navigator(
      initialRoute: ProfileTabRoutes.profile,
      key: Get.nestedKey(2),
      onGenerateInitialRoutes: (navState, route) {
        return [
          GetPageRoute(
            page: () => const ProfileSubpage(),
            routeName: ProfileTabRoutes.profile,
          ),
        ];
      },
      onGenerateRoute: HomeTabRouter.generateRoute,
    ),
  );
}
