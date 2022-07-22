import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  ScrollController _mainScrollController = ScrollController();

  TextEditingController _nameController =
      TextEditingController(text: "${user_name.$}");
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _file;

  chooseAndUploadImage(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(AppLocalizations.of(context).common_photo_permission),
                content: Text(
                    AppLocalizations.of(context).common_app_needs_permission),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).common_deny),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).common_settings),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_give_photo_permission,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
    } else if (status.isGranted) {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _file = await _picker.pickImage(source: ImageSource.gallery);

      if (_file == null) {
        ToastComponent.showDialog(AppLocalizations.of(context).common_no_file_chosen, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      //return;
      String base64Image = FileHelper.getBase64FormateFile(_file.path);
      String fileName = _file.path.split("/").last;

      var profileImageUpdateResponse =
          await ProfileRepository().getProfileImageUpdateResponse(
        base64Image,
        fileName,
      );

      if (profileImageUpdateResponse.result == false) {
        ToastComponent.showDialog(profileImageUpdateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else {
        ToastComponent.showDialog(profileImageUpdateResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

        avatar_original.$ = profileImageUpdateResponse.path;
        setState(() {});
      }
    }
  }

  Future<void> _onPageRefresh() async {}

  onPressUpdate() async {
    var name = _nameController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    var change_password = password != "" ||
        password_confirm !=
            ""; // if both fields are empty we will not change user's password

    if (name == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).profile_edit_screen_name_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).profile_edit_screen_password_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password_confirm == "") {
      ToastComponent.showDialog(AppLocalizations.of(context).profile_edit_screen_password_confirm_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).password_otp_screen_password_length_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    if (change_password && password != password_confirm) {
      ToastComponent.showDialog(AppLocalizations.of(context).profile_edit_screen_password_match_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var profileUpdateResponse =
        await ProfileRepository().getProfileUpdateResponse(
      name,
      change_password ? password : "",
    );

    if (profileUpdateResponse.result == false) {
      ToastComponent.showDialog(profileUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(profileUpdateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      user_name.$ = name;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Colors.white,
flexibleSpace: Container(
        decoration: BoxDecoration(color: MyTheme.green_accent_color_d0
        //     gradient: LinearGradient(colors: [
        //   // Color(0xff0fc744),
        //   // Color(0xff3fcad2)
        //   Color.fromRGBO(206, 35, 43, 1),
        //   Color.fromRGBO(237, 101, 85, 1),
        // ], begin: Alignment.topCenter,end:Alignment.bottomCenter)
        
        ,borderRadius: BorderRadius.horizontal(left: Radius.circular(20),right: Radius.circular(20))),
      ),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).profile_edit_screen_edit_profile,
        style: TextStyle(fontSize: 20, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildBody(context) {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).profile_edit_screen_login_warning,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                buildTopSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                  ),
                ),
                buildProfileForm(context)
              ]),
            )
          ],
        ),
      );
    }
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: Color.fromRGBO(112, 112, 112, .3), width: 2),
                  //shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: AppConfig.BASE_PATH + "${avatar_original.$}",
                      fit: BoxFit.fill,
                    )),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Icon(
                      Icons.edit,
                      color: MyTheme.font_grey,
                      size: 14,
                    ),
                    shape: CircleBorder(
                      side:
                          new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    ),
                    color: MyTheme.light_grey,
                    onPressed: () {
                      chooseAndUploadImage(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  buildProfileForm(context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                AppLocalizations.of(context).profile_edit_screen_basic_information,
                style: TextStyle(
                    color: MyTheme.grey_153,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLocalizations.of(context).profile_edit_screen_name,
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _nameController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "John Doe"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                AppLocalizations.of(context).profile_edit_screen_password,
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 36,
                    child: TextField(
                      controller: _passwordController,
                      autofocus: false,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text: "• • • • • • • •"),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).profile_edit_screen_password_length_recommendation,
                    style: TextStyle(
                        color: MyTheme.textfield_grey,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                  AppLocalizations.of(context).profile_edit_screen_retype_password,
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _passwordConfirmController,
                  autofocus: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: "• • • • • • • •"),
                ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: 120,
                    height: 36,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,

                      color: MyTheme.green_accent_color_d0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        AppLocalizations.of(context).profile_edit_screen_btn_update_profile,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressUpdate();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
