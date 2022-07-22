import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/data_model/cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_process_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_summary_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class CartRepository {
  Future<List<CartResponse>> getCartResponseList(
    @required int user_id,
  ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/$user_id");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    return cartResponseFromJson(response.body);
  }

  Future<CartDeleteResponse> getCartDeleteResponse(
    @required int cart_id,
  ) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/$cart_id");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    return cartDeleteResponseFromJson(response.body);
  }

  Future<CartProcessResponse> getCartProcessResponse(
      @required String cart_ids, @required String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/process");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return cartProcessResponseFromJson(response.body);
  }

  Future<CartAddResponse> getCartAddResponse(
      @required int id,
      @required String variant,
      @required int user_id,
      @required int quantity) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "variant": "$variant",
      "user_id": "$user_id",
      "quantity": "$quantity",
      "cost_matrix": AppConfig.purchase_code
    });

    print(post_body.toString());

    Uri url = Uri.parse("${AppConfig.BASE_URL}/carts/add");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    print(response.body.toString());
    return cartAddResponseFromJson(response.body);
  }

  Future<CartSummaryResponse> getCartSummaryResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/cart-summary/${user_id.$}");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    print("${AppConfig.BASE_URL}/cart-summary/${user_id.$}");
    return cartSummaryResponseFromJson(response.body);
  }
}
