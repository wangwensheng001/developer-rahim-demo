import 'package:shared_value/shared_value.dart';

final SharedValue<bool> is_logged_in = SharedValue(
  value: false, // initial value
  key: "is_logged_in", // disk storage key for shared_preferences
);

final SharedValue<String> access_token = SharedValue(
  value: "", // initial value
  key: "access_token", // disk storage key for shared_preferences
);

final SharedValue<int> user_id = SharedValue(
  value: 0, // initial value
  key: "user_id", // disk storage key for shared_preferences
);

final SharedValue<String> avatar_original = SharedValue(
  value: "", // initial value
  key: "avatar_original", // disk storage key for shared_preferences
);

final SharedValue<String> user_name = SharedValue(
  value: "", // initial value
  key: "user_name", // disk storage key for shared_preferences
);

final SharedValue<String> user_email = SharedValue(
  value: "", // initial value
  key: "user_email", // disk storage key for shared_preferences
);

final SharedValue<String> user_phone = SharedValue(
  value: "", // initial value
  key: "user_phone", // disk storage key for shared_preferences
);
final SharedValue<String> app_language = SharedValue(
  value: "en", // initial value
  key: "app_language", // disk storage key for shared_preferences
);

final SharedValue<String> app_mobile_language = SharedValue(
  value: "en", // initial value
  key: "app_mobile_language", // disk storage key for shared_preferences
);

final SharedValue<bool> app_language_rtl = SharedValue(
  value: false, // initial value
  key: "app_language_rtl", // disk storage key for shared_preferences
);

// addons start

final SharedValue<bool> club_point_addon_installed = SharedValue(
  value: false, // initial value
  key: "club_point_addon_installed", // disk storage key for shared_preferences
);

final SharedValue<bool> refund_addon_installed = SharedValue(
  value: false, // initial value
  key: "refund_addon_installed", // disk storage key for shared_preferences
);

final SharedValue<bool> otp_addon_installed = SharedValue(
  value: false, // initial value
  key: "otp_addon_installed", // disk storage key for shared_preferences
);
// addon end

// social login start
final SharedValue<bool> allow_google_login = SharedValue(
  value: false, // initial value
  key: "allow_google_login", // disk storage key for shared_preferences
);

final SharedValue<bool> allow_facebook_login = SharedValue(
  value: false, // initial value
  key: "allow_facebook_login", // disk storage key for shared_preferences
);

final SharedValue<bool> allow_twitter_login = SharedValue(
  value: false, // initial value
  key: "allow_twitter_login", // disk storage key for shared_preferences
);
// social login end

// business setting
final SharedValue<bool> pick_up_status = SharedValue(
  value: false, // initial value
  key: "pick_up_status", // disk storage key for shared_preferences
);