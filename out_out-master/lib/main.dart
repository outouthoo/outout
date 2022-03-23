import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:out_out/pages/common/edit_profile_page.dart';
import 'package:out_out/pages/common/forgot_password_page.dart';
import 'package:out_out/pages/common/login_page.dart';
import 'package:out_out/pages/common/register_page.dart';
import 'package:out_out/pages/common/settings_page.dart';
import 'package:out_out/pages/common/splash_page.dart';
import 'package:out_out/pages/common/video_upload_page.dart';
import 'package:out_out/pages/events_modul/create_event/create_event_screen.dart';
import 'package:out_out/pages/events_modul/view_events/upcoming_event.dart';
import 'package:out_out/pages/events_modul/view_events/view_events_page.dart';
import 'package:out_out/pages/friend_feed_new/friend_feed_page.dart';
import 'package:out_out/pages/friendspage/friend_page.dart';
import 'package:out_out/pages/friendspage/requestedFriendspage.dart';
import 'package:out_out/pages/home_page.dart';
import 'package:out_out/pages/membership_page.dart';
import 'package:out_out/pages/memory_page/memory_page.dart';
import 'package:out_out/pages/memory_page_for_verified/memory_page_for_verified_screen.dart';
import 'package:out_out/pages/my_messages/my_messages_screen.dart';
import 'package:out_out/pages/profile/profile_screen.dart';
import 'package:out_out/pages/renew_membership.dart';
import 'package:out_out/pages/shout_out_page/shout_out_page.dart';
import 'package:out_out/pages/story_page/image_story_page.dart';
import 'package:out_out/pages/wallet/walletpage.dart';
import 'package:out_out/pages/wallet/wallettransaction.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/utils/commona_utils.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:out_out/utils/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}
class IAPConnection {
  static InAppPurchase _instance;
  static set instance(InAppPurchase value) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // IAPConnection.instance = IAPConnection.instance();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CommonDetailsProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NavigationService.instance.navigationKey,
        title: 'OutOut',
        theme: ThemeData(
          primaryColor: CustomColor.colorPrimary,
          primaryColorDark: CustomColor.colorPrimaryDark,
          accentColor: CustomColor.colorAccent,
          canvasColor: CustomColor.colorCanvas,
          fontFamily: CommonUtils.FONT_FAMILY_UBUNTU_REGULAR,
        ),
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: SplashPage(),
        routes: {
          // '/': (context) => SplashPage(),
          LoginScreen.routeName: (context) => LoginScreen(),
          SettingsPage.routeName: (context) => SettingsPage(),
          // VideoViewPage.routeName: (context) => VideoViewPage(),
          ForgotPasswordPage.routeName: (context) => ForgotPasswordPage(),
          RegisterUserScreen.routeName: (context) => RegisterUserScreen(),
          VideoUploadPage.routeName: (context) => VideoUploadPage(),
          EditProfilePage.routeName: (context) => EditProfilePage(),
          CreateEventScreen.routeName: (context) => CreateEventScreen(),
          MemoryPage.routeName: (context) => MemoryPage(),
          ShoutOutPage.routeName: (context) => ShoutOutPage(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          // FriendsFeedPage.routeName: (context) => FriendsFeedPage(),
          FriendFeedPage.routeName: (context) => FriendFeedPage(),
          MyMessagesScreen.routeName: (context) => MyMessagesScreen(),
          ViewEventsPage.routeName: (context) => ViewEventsPage(),
          UpcomingEvents.routeName: (context) => UpcomingEvents(),
          MemoryPageForVerifiedScreen.routeName: (context) =>
              MemoryPageForVerifiedScreen(),
          // VideoStoryPage.routeName: (context) => VideoStoryPage(),
          ImageStoryPage.routeName: (context) => ImageStoryPage(),
          HomePage.routeName: (context) => HomePage(),
          FriendsPage.routeName: (context) => FriendsPage(),
          MembershipPage.routeName: (context) => MembershipPage(),
          FriendsRequestsPage.routeName: (context) => FriendsRequestsPage(),
          WalletPage.routeName: (context) => WalletPage(),
          RenewMembershipPage.routeName: (context) => RenewMembershipPage(),
          WalletHistoryPage.routeName: (context) => WalletHistoryPage(),
        },
      ),
    );
  }
}
