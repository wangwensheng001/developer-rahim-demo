import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text = " @BongoBaba " + this_year; //this shows in the splash screen
  static String app_name = "HatBazer"; //this shows in the splash screen
  static String purchase_code = "b2c6fc47-1fb7-47d2-9532-d2843f680f42"; //enter your purchase code for the app from codecanyon

  //configure this
  static const bool HTTPS = true;

  //configure this
  //static const DOMAIN_PATH = "192.168.31.29/bongobaba"; //localhost
  static const DOMAIN_PATH = "www.tamampk.com"; //inside a folder
  //static const DOMAIN_PATH = "www.apcombd.com"; // directly inside the public folder

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PUBLIC_FOLDER = "public";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";

  //configure this if you are using amazon s3 like services
  //give direct link to file like https://[[bucketname]].s3.ap-southeast-1.amazonaws.com/
  //otherwise do not change anythink
  static const String BASE_PATH = "${RAW_BASE_URL}/${PUBLIC_FOLDER}/";
  //static const String BASE_PATH = "https://tosoviti.s3.ap-southeast-2.amazonaws.com/";
}
