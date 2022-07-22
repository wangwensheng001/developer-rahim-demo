import 'package:active_ecommerce_flutter/data_model/business_setting_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/business_setting_repository.dart';

class BusinessSettingHelper {
  setBusinessSettingData() async {
    List<BusinessSettingListResponse> businessLists =
        await BusinessSettingRepository().getBusinessSettingList();

    businessLists.forEach((element) {
      switch (element.type) {
        case 'facebook_login':
          {
            if (element.value.toString() == "1") {
              allow_facebook_login.$ = true;
            } else {
              allow_facebook_login.$ = false;
            }
          }
          break;
        case 'google_login':
          {
            if (element.value.toString() == "1") {
              allow_google_login.$ = true;
            } else {
              allow_google_login.$ = false;
            }
          }
          break;
        case 'twitter_login':
          {
            if (element.value.toString() == "1") {
              allow_twitter_login.$ = true;
            } else {
              allow_twitter_login.$ = false;
            }
          }
          break;
        case 'pickup_point':
          {
            if (element.value.toString() == "1") {
              pick_up_status.$ = true;
            } else {
              pick_up_status.$ = false;
            }
          }
          break;

        default:
          {}
          break;
      }
    });
  }
}
