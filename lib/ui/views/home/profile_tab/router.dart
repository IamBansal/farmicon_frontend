part of 'tab.dart';

class ProfileTabRoutes {
  static const String profile = '/', selectCrops = '/select_crops';
}

class HomeTabRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ProfileTabRoutes.profile:
        return GetPageRoute(
          page: () => const ProfileSubpage(),
          routeName: ProfileTabRoutes.profile,
          settings: settings,
        );
      case ProfileTabRoutes.selectCrops:
        return GetPageRoute(
          page: () => const SelectCropsSubpage(),
          routeName: ProfileTabRoutes.selectCrops,
          settings: settings,
        );
      // Default
      default:
        return GetPageRoute(
          page: () => Scaffold(
            backgroundColor: AppTheme.white,
            body: Center(
              child: AText('No route defined for ${settings.name}'),
            ),
          ),
          routeName: '/undefined',
        );
    }
  }
}
