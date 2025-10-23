import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/routes/routes_class.dart';
import 'package:ozone_erp/translation/language.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: false,
      designSize: const Size(360, 640),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          theme: ThemeData(
              useMaterial3: false,
              tabBarTheme: TabBarThemeData(
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.black54,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppStyle.tabColor)),
              appBarTheme:
                  const AppBarTheme(backgroundColor: AppStyle.primaryColor),
              primaryColor: AppStyle.primaryColor),
          useInheritedMediaQuery: false,
          title: StringConstant.appTitle,
          color: AppStyle.primaryColor,
          translations: Language(),
          locale: const Locale('en', 'US'),
          navigatorKey: MyApp.navigatorKey,
          defaultTransition: Transition.rightToLeftWithFade,
          getPages: RoutesClass.routes,
          debugShowCheckedModeBanner: false,
          enableLog: !kReleaseMode,
          navigatorObservers: <NavigatorObserver>[GetObserver()],
          initialRoute: RoutesName.splash,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: child!),
        );
      },
    );
  }
}
