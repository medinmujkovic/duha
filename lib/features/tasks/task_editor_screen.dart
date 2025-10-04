import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationService {
static final _local = FlutterLocalNotificationsPlugin();


static Future<void> init() async {
const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
await _local.initialize(const InitializationSettings(android: androidSettings));


final messaging = FirebaseMessaging.instance;
await messaging.requestPermission();
final token = await messaging.getToken();
final uid = FirebaseAuth.instance.currentUser?.uid;
if (uid != null && token != null) {
await FirebaseFirestore.instance.collection('users').doc(uid).set({
'fcmTokens': FieldValue.arrayUnion([token])
}, SetOptions(merge: true));
}


FirebaseMessaging.onMessage.listen((msg) async {
await _local.show(0, msg.notification?.title, msg.notification?.body, const NotificationDetails(
android: AndroidNotificationDetails('default', 'General'),
));
});
}
}