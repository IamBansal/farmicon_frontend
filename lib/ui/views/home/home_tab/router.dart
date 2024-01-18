part of 'tab.dart';

class HomeTabRoutes {
  static const String home = '/',
      price = '/price',
      doctor = '/doctor',
      insurance = '/insurance',
      drone = '/drone',
      govSchemes = '/gov_schemes',
      orgFarming = '/org_farming',
      soilTesting = '/soil_testing',
      warehouse = '/warehouse',
      weather = '/weather';
}

class HomeTabRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeTabRoutes.home:
        return GetPageRoute(
          page: () => const HomeSubpage(),
          routeName: HomeTabRoutes.home,
          settings: settings,
        );
      case HomeTabRoutes.warehouse:
        return GetPageRoute(
          page: () =>
              WarehouseSubpage(model: settings.arguments as HomeViewModel),
          routeName: HomeTabRoutes.warehouse,
          settings: settings,
        );
      case HomeTabRoutes.drone:
        return GetPageRoute(
          page: () => DroneSubpage(model: settings.arguments as HomeViewModel),
          routeName: HomeTabRoutes.drone,
          settings: settings,
        );
      case HomeTabRoutes.insurance:
        return GetPageRoute(
          page: () =>
              InsuranceSubpage(model: settings.arguments as HomeViewModel),
          routeName: HomeTabRoutes.insurance,
          settings: settings,
        );
      case HomeTabRoutes.soilTesting:
        return GetPageRoute(
          page: () =>
              SoilTestingSubpage(model: settings.arguments as HomeViewModel),
          routeName: HomeTabRoutes.soilTesting,
          settings: settings,
        );
      case HomeTabRoutes.govSchemes:
        return GetPageRoute(
          page: () => const GovSchemesSubpage(),
          routeName: HomeTabRoutes.govSchemes,
          settings: settings,
        );
      case HomeTabRoutes.orgFarming:
        return GetPageRoute(
          page: () => const OrganicFarmingSubpage(),
          routeName: HomeTabRoutes.orgFarming,
          settings: settings,
        );
      case HomeTabRoutes.price:
        return GetPageRoute(
          page: () => const PriceSubpage(),
          routeName: HomeTabRoutes.price,
          settings: settings,
        );
      case HomeTabRoutes.doctor:
        return GetPageRoute(
          page: () => DoctorSubpage(model: settings.arguments as HomeViewModel),
          routeName: HomeTabRoutes.doctor,
          settings: settings,
        );
      case HomeTabRoutes.weather:
        return GetPageRoute(
          page: () =>
              WeatherSubpage(model: settings.arguments as HomeViewModel),
          routeName: HomeTabRoutes.weather,
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
