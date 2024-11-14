import 'package:eirmuplb/home.dart';
import 'package:eirmuplb/library_pest.dart';
import 'package:eirmuplb/map.dart';
import 'package:eirmuplb/services/notification_service.dart';
import 'package:eirmuplb/signin.dart';
import 'package:eirmuplb/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:calendar_view/calendar_view.dart';
import 'model/event.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'my_farm_page.dart';

///TODO: review this for iOS version: https://pub.dev/packages/flutter_native_splash

DateTime get _now => DateTime.now();

List<CalendarEventData<Event>> _events = [];

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EIRMApp());

}
class EIRMApp extends StatelessWidget {
  const EIRMApp({
    Key? key,
  }) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
        controller: EventController<Event>()..addAll(_events),
        child: MaterialApp(
          home: SignInScreen(),
          debugShowCheckedModeBanner: false,
        )
      // child: MaterialApp(home: UpgradeAlert(upgrader: Upgrader(dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material), child: SignInScreen()), debugShowCheckedModeBanner: false,)
    );
    // return MaterialApp(home: const SignInScreen());
  }
}

class NavigationMenuDrawer extends StatelessWidget {
  const NavigationMenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context),
          SizedBox(height: 20,),
          buildMenuItems(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Material(
    color: Color(0xFF27ae60),
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UserRoute()));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/images/emir.png",
              fit: BoxFit.fitWidth,
              height: 120,
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    ),
  );
  Widget buildMenuItems(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomeRoute()));
              },
            ),
            ListTile(
              leading: const Image(
                image: AssetImage('assets/images/icons-farmer.png'),
              ),
              title: const Text('My Farm'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  MyFarmPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text('Map'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MapRoute()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Learn'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ELearnRoute(),
                ));
              },
            ),
          ],
        ),
      ),
      Divider(height: 10.0),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          FirebaseAuth.instance.signOut().then((value) {
            print("Signed Out");
          });
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SignInScreen()));
        },
      ),
    ],
  );
}
