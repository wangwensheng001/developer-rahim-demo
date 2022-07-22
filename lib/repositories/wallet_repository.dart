import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/wallet_balance_response.dart';
import 'package:active_ecommerce_flutter/data_model/wallet_recharge_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class WalletRepository {
  Future<WalletBalanceResponse> getBalance() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/wallet/balance/${user_id.$}");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    print(response.body.toString());
    return walletBalanceResponseFromJson(response.body);
  }

  Future<WalletRechargeResponse> getRechargeList({int page = 1}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wallet/history/${user_id.$}?page=${page}");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    print("url:" +url.toString());
    print(response.body);
    return walletRechargeResponseFromJson(response.body);
  }
}
