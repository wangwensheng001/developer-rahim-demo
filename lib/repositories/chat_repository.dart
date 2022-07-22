import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/conversation_response.dart';
import 'package:active_ecommerce_flutter/data_model/message_response.dart';
import 'package:active_ecommerce_flutter/data_model/conversation_create_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  Future<ConversationResponse> getConversationResponse(
      {@required page = 1}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/chat/conversations/${user_id.$}?page=${page}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return conversationResponseFromJson(response.body);
  }

  Future<MessageResponse> getMessageResponse(
      {@required conversation_id, @required page = 1}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/chat/messages/${conversation_id}?page=${page}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );
    return messageResponseFromJson(response.body);
  }

  Future<MessageResponse> getInserMessageResponse(
      {@required conversation_id, @required String message}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "conversation_id": "${conversation_id}",
      "message": "${message}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/chat/insert-message");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
    return messageResponseFromJson(response.body);
  }

  Future<MessageResponse> getNewMessageResponse(
      {@required conversation_id, @required last_message_id}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/chat/get-new-messages/${conversation_id}/${last_message_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );
    /* print("${AppConfig.BASE_URL}/chat/get-new-messages/${conversation_id}/${last_message_id}");
    print(response.body.toString());*/
    return messageResponseFromJson(response.body);
  }

  Future<ConversationCreateResponse> getCreateConversationResponse(
      {@required product_id,
      @required String title,
      @required String message}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "product_id": "${product_id}",
      "title": "${title}",
      "message": "${message}"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/chat/create-conversation");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
    return conversationCreateResponseFromJson(response.body);
  }
}
