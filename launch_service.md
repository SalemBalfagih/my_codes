# Launch Service (Singleton + Testable)

``` dart
abstract class ILaunchService {
  Future<bool> openUrl(String url);
  Future<bool> openInApp(String url);
  Future<bool> callNumber(String phone);
  Future<bool> sendSMS(String phone, {String? message});
  Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  });
  Future<bool> openMap({
    required double lat,
    required double lng,
    String? label,
  });
}
```

``` dart
import 'package:url_launcher/url_launcher.dart';

class LaunchService implements ILaunchService {
  // Singleton Instance
  static final LaunchService _instance = LaunchService._internal();
  LaunchService._internal();
  factory LaunchService() => _instance;

  @override
  Future<bool> openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    if (!await canLaunchUrl(uri)) return false;

    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Future<bool> openInApp(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    if (!await canLaunchUrl(uri)) return false;

    return await launchUrl(uri, mode: LaunchMode.inAppWebView);
  }

  @override
  Future<bool> callNumber(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (!await canLaunchUrl(uri)) return false;
    return await launchUrl(uri);
  }

  @override
  Future<bool> sendSMS(String phone, {String? message}) async {
    final uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: message != null ? {'body': message} : null,
    );
    if (!await canLaunchUrl(uri)) return false;
    return await launchUrl(uri);
  }

  @override
  Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    if (!await canLaunchUrl(uri)) return false;
    return await launchUrl(uri);
  }

  @override
  Future<bool> openMap({
    required double lat,
    required double lng,
    String? label,
  }) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng${label != null ? '&query_place_id=$label' : ''}';
    return openUrl(url);
  }
}
```
