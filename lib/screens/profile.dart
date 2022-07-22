import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/club_point.dart';
import 'package:active_ecommerce_flutter/screens/refund_request.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.show_back_button = false}) : super(key: key);

  bool show_back_button;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _cartCounter = 0;
  String _cartCounterString = "...";
  int _wishlistCounter = 0;
  String _wishlistCounterString = "...";
  int _orderCounter = 0;
  String _orderCounterString = "...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  fetchAll() {
    fetchCounters();
  }

  fetchCounters() async {
    var profileCountersResponse =
        await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    _wishlistCounter = profileCountersResponse.wishlist_item_count;
    _orderCounter = profileCountersResponse.order_count;

    _cartCounterString =
        counterText(_cartCounter.toString(), default_length: 2);
    _wishlistCounterString =
        counterText(_wishlistCounter.toString(), default_length: 2);
    _orderCounterString =
        counterText(_orderCounter.toString(), default_length: 2);

    setState(() {});
  }

  String counterText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  reset() {
    _cartCounter = 0;
    _cartCounterString = "...";
    _wishlistCounter = 0;
    _wishlistCounterString = "...";
    _orderCounter = 0;
    _orderCounterString = "...";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  buildBody(context) {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).profile_screen_please_log_in,
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
                buildCountersRow(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                    color: Colors.red,
                  ),
                ),
                buildHorizontalMenu(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                    color: MyTheme.green_accent_color_d0,
                  ),
                ),
                buildVerticalMenu()
              ]),
            )
          ],
        ),
      );
    }
  }

  buildHorizontalMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList();
            }));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: Colors.green,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context).profile_screen_orders,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfileEdit();
            })).then((value) {
              onPopped(value);
            });
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context).profile_screen_profile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Address();
            }));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  // color: Colors.redAccent,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.amber,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context).profile_screen_address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        /*InkWell(
          onTap: () {
            ToastComponent.showDialog("Coming soon", context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Icon(Icons.message_outlined, color: Colors.redAccent),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),*/
      ],
    );
  }

  buildVerticalMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              ToastComponent.showDialog(
                  AppLocalizations.of(context).common_coming_soon, context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            },
            child: Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppLocalizations.of(context)
                            .profile_screen_notification,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: MyTheme.font_grey, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OrderList();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .profile_screen_purchase_history,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
          club_point_addon_installed.$
              ? InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Clubpoint();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.white,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .profile_screen_earning_points,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
          refund_addon_installed.$
              ? InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RefundRequest();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.double_arrow,
                                color: Colors.white,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .profile_screen_refund_requests,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _cartCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_your_cart,
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _wishlistCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_wishlist,
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _orderCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_ordered,
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        )
      ],
    );
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Container(
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "${user_name.$}",
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              //if user email is not available then check user phone if user phone is not available use empty string
              "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
              style: TextStyle(
                color: MyTheme.medium_grey,
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            height: 30,
            child: FlatButton(
              color:MyTheme.green_accent_color_e0,
              // 	rgb(50,205,50)
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                bottomLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0),
              )),
              child: Text(
                AppLocalizations.of(context).profile_screen_check_balance,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wallet();
                }));
              },
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(color:MyTheme.green_accent_color_d0
            // gradient: LinearGradient(colors: [
            //   // Color(0xff0fc744),
            //   // Color(0xff3fcad2)
            //   Color.fromRGBO(206, 35, 43, 1),
            //   Color.fromRGBO(237, 101, 85, 1),
            // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
           , borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
      ),
      centerTitle: true,
      leading: GestureDetector(
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0.0),
                    child: Container(
                      child: Image.asset(
                        'assets/hamburger.png',
                        height: 16,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ),
              ),
      ),
      title: Text(
        AppLocalizations.of(context).profile_screen_account,
        style: TextStyle(fontSize: 20, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}

// // import 'package:flutter/material.dart';
// // import 'package:active_ecommerce_flutter/my_theme.dart';
// // import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
// // import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// // import 'package:active_ecommerce_flutter/app_config.dart';
// // import 'package:active_ecommerce_flutter/screens/wallet.dart';
// // import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
// // import 'package:active_ecommerce_flutter/screens/address.dart';
// // import 'package:active_ecommerce_flutter/screens/order_list.dart';
// // import 'package:active_ecommerce_flutter/screens/club_point.dart';
// // import 'package:active_ecommerce_flutter/screens/refund_request.dart';
// // import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
// // import 'package:active_ecommerce_flutter/custom/toast_component.dart';
// // import 'package:toast/toast.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // class Profile extends StatefulWidget {
// //   Profile({Key key, this.show_back_button = false}) : super(key: key);

// //   bool show_back_button;

// //   @override
// //   _ProfileState createState() => _ProfileState();
// // }

// // class _ProfileState extends State<Profile> {
// //   ScrollController _mainScrollController = ScrollController();
// //   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// //   int _cartCounter = 0;
// //   String _cartCounterString = "...";
// //   int _wishlistCounter = 0;
// //   String _wishlistCounterString = "...";
// //   int _orderCounter = 0;
// //   String _orderCounterString = "...";

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();

// //     if (is_logged_in.$ == true) {
// //       fetchAll();
// //     }
// //   }

// //   void dispose() {
// //     _mainScrollController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _onPageRefresh() async {
// //     reset();
// //     fetchAll();
// //   }

// //   onPopped(value) async {
// //     reset();
// //     fetchAll();
// //   }

// //   fetchAll() {
// //     fetchCounters();
// //   }

// //   fetchCounters() async {
// //     var profileCountersResponse =
// //         await ProfileRepository().getProfileCountersResponse();

// //     _cartCounter = profileCountersResponse.cart_item_count;
// //     _wishlistCounter = profileCountersResponse.wishlist_item_count;
// //     _orderCounter = profileCountersResponse.order_count;

// //     _cartCounterString =
// //         counterText(_cartCounter.toString(), default_length: 2);
// //     _wishlistCounterString =
// //         counterText(_wishlistCounter.toString(), default_length: 2);
// //     _orderCounterString =
// //         counterText(_orderCounter.toString(), default_length: 2);

// //     setState(() {});
// //   }

// //   String counterText(String txt, {default_length = 3}) {
// //     var blank_zeros = default_length == 3 ? "000" : "00";
// //     var leading_zeros = "";
// //     if (txt != null) {
// //       if (default_length == 3 && txt.length == 1) {
// //         leading_zeros = "00";
// //       } else if (default_length == 3 && txt.length == 2) {
// //         leading_zeros = "0";
// //       } else if (default_length == 2 && txt.length == 1) {
// //         leading_zeros = "0";
// //       }
// //     }

// //     var newtxt = (txt == null || txt == "" || txt == null.toString())
// //         ? blank_zeros
// //         : txt;

// //     // print(txt + " " + default_length.toString());
// //     // print(newtxt);

// //     if (default_length > txt.length) {
// //       newtxt = leading_zeros + newtxt;
// //     }
// //     //print(newtxt);

// //     return newtxt;
// //   }

// //   reset() {
// //     _cartCounter = 0;
// //     _cartCounterString = "...";
// //     _wishlistCounter = 0;
// //     _wishlistCounterString = "...";
// //     _orderCounter = 0;
// //     _orderCounterString = "...";
// //     setState(() {});
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
// //       child: Scaffold(
// //         key: _scaffoldKey,
// //         drawer: MainDrawer(),
// //         backgroundColor: Colors.white,
// //         appBar: buildAppBar(context),
// //         body: buildBody(context),
// //       ),
// //     );
// //   }

// //   buildBody(context) {
// //     if (is_logged_in.$ == false) {
// //       return Container(
// //           height: 100,
// //           child: Center(
// //               child: Text(
// //                 AppLocalizations.of(context).profile_screen_please_log_in,
// //             style: TextStyle(color: MyTheme.font_grey),
// //           )));
// //     } else {
// //       return RefreshIndicator(
// //         color: MyTheme.accent_color,
// //         backgroundColor: Colors.white,
// //         onRefresh: _onPageRefresh,
// //         displacement: 10,
// //         child: CustomScrollView(
// //           controller: _mainScrollController,
// //           physics: const BouncingScrollPhysics(
// //               parent: AlwaysScrollableScrollPhysics()),
// //           slivers: [
// //             SliverList(
// //               delegate: SliverChildListDelegate([
// //                 buildTopSection(),
// //                 buildCountersRow(),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: Divider(
// //                     height: 24,
// //                   ),
// //                 ),
// //                 buildHorizontalMenu(),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: Divider(
// //                     height: 24,
// //                   ),
// //                 ),
// //                 buildVerticalMenu()
// //               ]),
// //             )
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   buildHorizontalMenu() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         InkWell(
// //           onTap: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (context) {
// //               return OrderList();
// //             }));
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Icon(
// //                       Icons.assignment_outlined,
// //                       color: Colors.green,
// //                     ),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_orders,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //         InkWell(
// //           onTap: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (context) {
// //               return ProfileEdit();
// //             })).then((value) {
// //               onPopped(value);
// //             });
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Icon(
// //                       Icons.person,
// //                       color: Colors.blueAccent,
// //                     ),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_profile,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //         InkWell(
// //           onTap: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (context) {
// //               return Address();
// //             }));
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Icon(
// //                       Icons.location_on,
// //                       color: Colors.amber,
// //                     ),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_address,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //         /*InkWell(
// //           onTap: () {
// //             ToastComponent.showDialog("Coming soon", context,
// //                 gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child:
// //                         Icon(Icons.message_outlined, color: Colors.redAccent),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   "Message",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),*/
// //       ],
// //     );
// //   }

// //   buildVerticalMenu() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         children: [
// //           InkWell(
// //             onTap: () {
// //               ToastComponent.showDialog(AppLocalizations.of(context).common_coming_soon, context,
// //                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
// //             },
// //             child: Visibility(
// //               visible: false,
// //               child: Padding(
// //                 padding: const EdgeInsets.only(bottom: 16.0),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                         height: 40,
// //                         width: 40,
// //                         decoration: BoxDecoration(
// //                           color: Colors.amber,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Icon(
// //                             Icons.notifications_outlined,
// //                             color: Colors.white,
// //                           ),
// //                         )),
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                       child: Text(
// //                         AppLocalizations.of(context).profile_screen_notification,
// //                         textAlign: TextAlign.center,
// //                         style:
// //                             TextStyle(color: MyTheme.font_grey, fontSize: 14),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //           InkWell(
// //             onTap: () {
// //               Navigator.push(context, MaterialPageRoute(builder: (context) {
// //                 return OrderList();
// //               }));
// //             },
// //             child: Padding(
// //               padding: const EdgeInsets.only(bottom: 16.0),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                       height: 40,
// //                       width: 40,
// //                       decoration: BoxDecoration(
// //                         color: Colors.green,
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Icon(
// //                           Icons.credit_card_rounded,
// //                           color: Colors.white,
// //                         ),
// //                       )),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: Text(
// //                       AppLocalizations.of(context).profile_screen_purchase_history,
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           ),
// //           club_point_addon_installed.$
// //               ? InkWell(
// //                   onTap: () {
// //                     Navigator.push(context,
// //                         MaterialPageRoute(builder: (context) {
// //                       return Clubpoint();
// //                     }));
// //                   },
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(bottom: 16.0),
// //                     child: Row(
// //                       children: [
// //                         Container(
// //                             height: 40,
// //                             width: 40,
// //                             decoration: BoxDecoration(
// //                               color: Colors.orange,
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Icon(
// //                                 Icons.monetization_on_outlined,
// //                                 color: Colors.white,
// //                               ),
// //                             )),
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                           child: Text(
// //                             AppLocalizations.of(context).profile_screen_earning_points,
// //                             textAlign: TextAlign.center,
// //                             style: TextStyle(
// //                                 color: MyTheme.font_grey, fontSize: 14),
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 )
// //               : Container(),
// //           refund_addon_installed.$
// //               ? InkWell(
// //             onTap: () {
// //               Navigator.push(context,
// //                   MaterialPageRoute(builder: (context) {
// //                     return RefundRequest();
// //                   }));
// //             },
// //             child: Padding(
// //               padding: const EdgeInsets.only(bottom: 16.0),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                       height: 40,
// //                       width: 40,
// //                       decoration: BoxDecoration(
// //                         color: Colors.pinkAccent,
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Icon(
// //                           Icons.double_arrow,
// //                           color: Colors.white,
// //                         ),
// //                       )),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: Text(
// //                       AppLocalizations.of(context).profile_screen_refund_requests,
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                           color: MyTheme.font_grey, fontSize: 14),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           )
// //               : Container(),
// //         ],
// //       ),
// //     );
// //   }

// //   buildCountersRow() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 8.0),
// //               child: Text(
// //                 _cartCounterString,
// //                 style: TextStyle(
// //                     fontSize: 16,
// //                     color: MyTheme.font_grey,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //             Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_in_your_cart,
// //                   style: TextStyle(
// //                     color: MyTheme.medium_grey,
// //                   ),
// //                 )),
// //           ],
// //         ),
// //         Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 8.0),
// //               child: Text(
// //                 _wishlistCounterString,
// //                 style: TextStyle(
// //                     fontSize: 16,
// //                     color: MyTheme.font_grey,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //             Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_in_wishlist,
// //                   style: TextStyle(
// //                     color: MyTheme.medium_grey,
// //                   ),
// //                 )),
// //           ],
// //         ),
// //         Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 8.0),
// //               child: Text(
// //                 _orderCounterString,
// //                 style: TextStyle(
// //                     fontSize: 16,
// //                     color: MyTheme.font_grey,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //             Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_in_ordered,
// //                   style: TextStyle(
// //                     color: MyTheme.medium_grey,
// //                   ),
// //                 )),
// //           ],
// //         )
// //       ],
// //     );
// //   }

// //   buildTopSection() {
// //     return Column(
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
// //           child: Container(
// //             width: 120,
// //             height: 120,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(100),
// //               border: Border.all(
// //                   color: Color.fromRGBO(112, 112, 112, .3), width: 2),
// //               //shape: BoxShape.rectangle,
// //             ),
// //             child: ClipRRect(
// //                 clipBehavior: Clip.hardEdge,
// //                 borderRadius: BorderRadius.all(Radius.circular(100.0)),
// //                 child: FadeInImage.assetNetwork(
// //                   placeholder: 'assets/placeholder.png',
// //                   image: AppConfig.BASE_PATH + "${avatar_original.$}",
// //                   fit: BoxFit.fill,
// //                 )),
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.only(top: 8.0),
// //           child: Text(
// //             "${user_name.$}",
// //             style: TextStyle(
// //                 fontSize: 14,
// //                 color: MyTheme.font_grey,
// //                 fontWeight: FontWeight.w600),
// //           ),
// //         ),
// //         Padding(
// //             padding: const EdgeInsets.only(top: 4.0),
// //             child:
// //                 Text(
// //                   //if user email is not available then check user phone if user phone is not available use empty string
// //                     "${user_email.$ != "" && user_email.$ != null?
// //                     user_email.$:user_phone.$ != "" && user_phone.$ != null?user_phone.$:''}",
// //                     style: TextStyle(
// //                       color: MyTheme.medium_grey,
// //                     ),
// //                   )
// //         ),
// //         Visibility(
// //           visible: wallet_system_status.$,
// //           child: Padding(
// //             padding: const EdgeInsets.only(top: 16.0),
// //             child: Container(
// //               height: 24,
// //               child: FlatButton(
// //                 color: Colors.green,
// //                 // 	rgb(50,205,50)
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: const BorderRadius.only(
// //                   topLeft: const Radius.circular(16.0),
// //                   bottomLeft: const Radius.circular(16.0),
// //                   topRight: const Radius.circular(16.0),
// //                   bottomRight: const Radius.circular(16.0),
// //                 )),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_check_balance,
// //                   style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w600),
// //                 ),
// //                 onPressed: () {
// //                   Navigator.push(context, MaterialPageRoute(builder: (context) {
// //                     return Wallet();
// //                   }));
// //                 },
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   AppBar buildAppBar(BuildContext context) {
// //     return AppBar(
// // backgroundColor: Colors.white,
// //       centerTitle: true,
// //       leading: GestureDetector(
// //         child: widget.show_back_button
// //             ? Builder(
// //                 builder: (context) => IconButton(
// //                   icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
// //                   onPressed: () => Navigator.of(context).pop(),
// //                 ),
// //               )
// //             : Builder(
// //                 builder: (context) => GestureDetector(
// //                   onTap: () {
// //                     _scaffoldKey.currentState.openDrawer();
// //                   },
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                         vertical: 18.0, horizontal: 0.0),
// //                     child: Container(
// //                       child: Image.asset(
// //                         'assets/hamburger.png',
// //                         height: 16,
// //                         color: MyTheme.dark_grey,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //       ),
// //       title: Text(
// //         AppLocalizations.of(context).profile_screen_account,
// //         style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
// //       ),
// //       elevation: 0.0,
// //       titleSpacing: 0,
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
// import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// import 'package:active_ecommerce_flutter/app_config.dart';
// import 'package:active_ecommerce_flutter/screens/wallet.dart';
// import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
// import 'package:active_ecommerce_flutter/screens/address.dart';
// import 'package:active_ecommerce_flutter/screens/order_list.dart';
// import 'package:active_ecommerce_flutter/screens/club_point.dart';
// import 'package:active_ecommerce_flutter/screens/refund_request.dart';
// import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
// import 'package:active_ecommerce_flutter/custom/toast_component.dart';
// import 'package:toast/toast.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class Profile extends StatefulWidget {
//   Profile({Key key, this.show_back_button = false}) : super(key: key);

//   bool show_back_button;

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   ScrollController _mainScrollController = ScrollController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   int _cartCounter = 0;
//   String _cartCounterString = "...";
//   int _wishlistCounter = 0;
//   String _wishlistCounterString = "...";
//   int _orderCounter = 0;
//   String _orderCounterString = "...";

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     if (is_logged_in.$ == true) {
//       fetchAll();
//     }
//   }

//   void dispose() {
//     _mainScrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _onPageRefresh() async {
//     reset();
//     fetchAll();
//   }

//   onPopped(value) async {
//     reset();
//     fetchAll();
//   }

//   fetchAll() {
//     fetchCounters();
//   }

//   fetchCounters() async {
//     var profileCountersResponse =
//         await ProfileRepository().getProfileCountersResponse();

//     _cartCounter = profileCountersResponse.cart_item_count;
//     _wishlistCounter = profileCountersResponse.wishlist_item_count;
//     _orderCounter = profileCountersResponse.order_count;

//     _cartCounterString =
//         counterText(_cartCounter.toString(), default_length: 2);
//     _wishlistCounterString =
//         counterText(_wishlistCounter.toString(), default_length: 2);
//     _orderCounterString =
//         counterText(_orderCounter.toString(), default_length: 2);

//     setState(() {});
//   }

//   String counterText(String txt, {default_length = 3}) {
//     var blank_zeros = default_length == 3 ? "000" : "00";
//     var leading_zeros = "";
//     if (txt != null) {
//       if (default_length == 3 && txt.length == 1) {
//         leading_zeros = "00";
//       } else if (default_length == 3 && txt.length == 2) {
//         leading_zeros = "0";
//       } else if (default_length == 2 && txt.length == 1) {
//         leading_zeros = "0";
//       }
//     }

//     var newtxt = (txt == null || txt == "" || txt == null.toString())
//         ? blank_zeros
//         : txt;

//     // print(txt + " " + default_length.toString());
//     // print(newtxt);

//     if (default_length > txt.length) {
//       newtxt = leading_zeros + newtxt;
//     }
//     //print(newtxt);

//     return newtxt;
//   }

//   reset() {
//     _cartCounter = 0;
//     _cartCounterString = "...";
//     _wishlistCounter = 0;
//     _wishlistCounterString = "...";
//     _orderCounter = 0;
//     _orderCounterString = "...";
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: MainDrawer(),
//         backgroundColor: Colors.white,
//         appBar: buildAppBar(context),
//         body: buildBody(context),
//       ),
//     );
//   }

//   buildBody(context) {
//     if (is_logged_in.$ == false) {
//       return Container(
//           height: 100,
//           child: Center(
//               child: Text(
//             AppLocalizations.of(context).profile_screen_please_log_in,
//             style: TextStyle(color: MyTheme.font_grey),
//           )));
//     } else {
//       return RefreshIndicator(
//         color: MyTheme.accent_color,
//         backgroundColor: Colors.white,
//         onRefresh: _onPageRefresh,
//         displacement: 10,
//         child: CustomScrollView(
//           controller: _mainScrollController,
//           physics: const BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics()),
//           slivers: [
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 buildTopSection(),
//                 buildCountersRow(),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(
//                     height: 24,
//                   ),
//                 ),
//                 buildHorizontalMenu(),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Divider(
//                     height: 24,
//                   ),
//                 ),
//                 buildVerticalMenu()
//               ]),
//             )
//           ],
//         ),
//       );
//     }
//   }

//   buildHorizontalMenu() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return OrderList();
//             }));
//           },
//           child: Column(
//             children: [
//               Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: MyTheme.light_grey,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(
//                       Icons.assignment_outlined,
//                       color: Colors.green,
//                     ),
//                   )),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   AppLocalizations.of(context).profile_screen_orders,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
//                 ),
//               )
//             ],
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return ProfileEdit();
//             })).then((value) {
//               onPopped(value);
//             });
//           },
//           child: Column(
//             children: [
//               Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: MyTheme.light_grey,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(
//                       Icons.person,
//                       color: Colors.blueAccent,
//                     ),
//                   )),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   AppLocalizations.of(context).profile_screen_profile,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
//                 ),
//               )
//             ],
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return Address();
//             }));
//           },
//           child: Column(
//             children: [
//               Container(
//                   height: 40,
//                   width: 40,
//                   // color: Colors.redAccent,
//                   decoration: BoxDecoration(
//                     color: MyTheme.light_grey,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(
//                       Icons.location_on,
//                       color: Colors.amber,
//                     ),
//                   )),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   AppLocalizations.of(context).profile_screen_address,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
//                 ),
//               )
//             ],
//           ),
//         ),
//         /*InkWell(
//           onTap: () {
//             ToastComponent.showDialog("Coming soon", context,
//                 gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
//           },
//           child: Column(
//             children: [
//               Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: MyTheme.light_grey,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child:
//                         Icon(Icons.message_outlined, color: Colors.redAccent),
//                   )),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   "Message",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
//                 ),
//               )
//             ],
//           ),
//         ),*/
//       ],
//     );
//   }

//   buildVerticalMenu() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () {
//               ToastComponent.showDialog(
//                   AppLocalizations.of(context).common_coming_soon, context,
//                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
//             },
//             child: Visibility(
//               visible: false,
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Row(
//                   children: [
//                     Container(
//                         height: 40,
//                         width: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.notifications_outlined,
//                             color: Colors.white,
//                           ),
//                         )),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Text(
//                         AppLocalizations.of(context)
//                             .profile_screen_notification,
//                         textAlign: TextAlign.center,
//                         style:
//                             TextStyle(color: MyTheme.font_grey, fontSize: 14),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return OrderList();
//               }));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Row(
//                 children: [
//                   Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(
//                           Icons.credit_card_rounded,
//                           color: Colors.white,
//                         ),
//                       )),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Text(
//                       AppLocalizations.of(context)
//                           .profile_screen_purchase_history,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           club_point_addon_installed.$
//               ? InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return Clubpoint();
//                     }));
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Row(
//                       children: [
//                         Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.orange,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.monetization_on_outlined,
//                                 color: Colors.white,
//                               ),
//                             )),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Text(
//                             AppLocalizations.of(context)
//                                 .profile_screen_earning_points,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey, fontSize: 14),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               : Container(),
//           refund_addon_installed.$
//               ? InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return RefundRequest();
//                     }));
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Row(
//                       children: [
//                         Container(
//                             height: 40,
//                             width: 40,
//                             decoration: BoxDecoration(
//                               color: Colors.pinkAccent,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(
//                                 Icons.double_arrow,
//                                 color: Colors.white,
//                               ),
//                             )),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Text(
//                             AppLocalizations.of(context)
//                                 .profile_screen_refund_requests,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: MyTheme.font_grey, fontSize: 14),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }

//   buildCountersRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 _cartCounterString,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: MyTheme.font_grey,
//                     fontWeight: FontWeight.w600),
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   AppLocalizations.of(context).profile_screen_in_your_cart,
//                   style: TextStyle(
//                     color: MyTheme.medium_grey,
//                   ),
//                 )),
//           ],
//         ),
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 _wishlistCounterString,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: MyTheme.font_grey,
//                     fontWeight: FontWeight.w600),
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   AppLocalizations.of(context).profile_screen_in_wishlist,
//                   style: TextStyle(
//                     color: MyTheme.medium_grey,
//                   ),
//                 )),
//           ],
//         ),
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 _orderCounterString,
//                 style: TextStyle(
//                     fontSize: 16,
//                     color: MyTheme.font_grey,
//                     fontWeight: FontWeight.w600),
//               ),
//             ),
//             Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   AppLocalizations.of(context).profile_screen_in_ordered,
//                   style: TextStyle(
//                     color: MyTheme.medium_grey,
//                   ),
//                 )),
//           ],
//         )
//       ],
//     );
//   }

//   buildTopSection() {
//     return Column(
//       children: [
//         Container(
//           margin: EdgeInsets.only(top: 5),
//           child: Card(
//             elevation: 3,
//             shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.redAccent,width: .5)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     top: 16.0,
//                     bottom: 16.0,
//                     left: 15,
//                   ),
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       border: Border.all(
//                           color: Color.fromRGBO(112, 112, 112, .3), width: 2),
//                       //shape: BoxShape.rectangle,
//                     ),
//                     child: ClipRRect(
//                         clipBehavior: Clip.hardEdge,
//                         borderRadius: BorderRadius.all(Radius.circular(100.0)),
//                         child: FadeInImage.assetNetwork(
//                           placeholder: 'assets/placeholder.png',
//                           image: AppConfig.BASE_PATH + "${avatar_original.$}",
//                           fit: BoxFit.fill,
//                         )),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4.0, left: 15),
//                       child: Text(
//                         "${user_name.$}",
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: MyTheme.font_grey,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.only(top: 8.0, left: 15),
//                         child: Text(
//                           //if user email is not available then check user phone if user phone is not available use empty string
//                           "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
//                           style: TextStyle(
//                             color: MyTheme.medium_grey,
//                           ),
//                         )),
//                   ],
//                 ),

//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 16.0),
//                 //   child: Container(
//                 //     height: 24,
//                 //     child: FlatButton(
//                 //       color: Colors.green,
//                 //       // 	rgb(50,205,50)
//                 //       shape: RoundedRectangleBorder(
//                 //           borderRadius: const BorderRadius.only(
//                 //         topLeft: const Radius.circular(16.0),
//                 //         bottomLeft: const Radius.circular(16.0),
//                 //         topRight: const Radius.circular(16.0),
//                 //         bottomRight: const Radius.circular(16.0),
//                 //       )),
//                 //       child: Text(
//                 //         AppLocalizations.of(context).profile_screen_check_balance,
//                 //         style: TextStyle(
//                 //             color: Colors.white,
//                 //             fontSize: 11,
//                 //             fontWeight: FontWeight.w600),
//                 //       ),
//                 //       onPressed: () {
//                 //         Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 //           return Wallet();
//                 //         }));
//                 //       },
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 16.0, bottom: 10),
//           child: Container(
//             height: 35,
//             child: FlatButton(
//               color: Colors.green,
//               // 	rgb(50,205,50)
//               shape: RoundedRectangleBorder(
//                   borderRadius: const BorderRadius.only(
//                 topLeft: const Radius.circular(10.0),
//                 bottomLeft: const Radius.circular(10.0),
//                 topRight: const Radius.circular(10.0),
//                 bottomRight: const Radius.circular(10.0),
//               )),
//               child: Text(
//                 AppLocalizations.of(context).profile_screen_check_balance,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600),
//               ),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return Wallet();
//                 }));
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 // Color(0xff0fc744),
//                 // Color(0xff3fcad2)
//                 Color.fromRGBO(206, 35, 43, 1),
//                 Color.fromRGBO(237, 101, 85, 1),
//               ],
//             ),
//             borderRadius: BorderRadius.horizontal(
//                 left: Radius.circular(10), right: Radius.circular(10))),
//       ),
//       centerTitle: true,
//       leading: GestureDetector(
//         child: widget.show_back_button
//             ? Builder(
//                 builder: (context) => IconButton(
//                   icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               )
//             : Builder(
//                 builder: (context) => GestureDetector(
//                   onTap: () {
//                     _scaffoldKey.currentState.openDrawer();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 18.0, horizontal: 0.0),
//                     child: Container(
//                       child: Image.asset(
//                         'assets/hamburger.png',
//                         height: 16,
//                         color: MyTheme.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//       title: Text(
//         AppLocalizations.of(context).profile_screen_account,
//         style: TextStyle(fontSize: 20, color: MyTheme.white),
//       ),
//       elevation: 0.0,
//       titleSpacing: 0,
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:active_ecommerce_flutter/my_theme.dart';
// // import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
// // import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// // import 'package:active_ecommerce_flutter/app_config.dart';
// // import 'package:active_ecommerce_flutter/screens/wallet.dart';
// // import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
// // import 'package:active_ecommerce_flutter/screens/address.dart';
// // import 'package:active_ecommerce_flutter/screens/order_list.dart';
// // import 'package:active_ecommerce_flutter/screens/club_point.dart';
// // import 'package:active_ecommerce_flutter/screens/refund_request.dart';
// // import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
// // import 'package:active_ecommerce_flutter/custom/toast_component.dart';
// // import 'package:toast/toast.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // class Profile extends StatefulWidget {
// //   Profile({Key key, this.show_back_button = false}) : super(key: key);

// //   bool show_back_button;

// //   @override
// //   _ProfileState createState() => _ProfileState();
// // }

// // class _ProfileState extends State<Profile> {
// //   ScrollController _mainScrollController = ScrollController();
// //   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// //   int _cartCounter = 0;
// //   String _cartCounterString = "...";
// //   int _wishlistCounter = 0;
// //   String _wishlistCounterString = "...";
// //   int _orderCounter = 0;
// //   String _orderCounterString = "...";

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();

// //     if (is_logged_in.$ == true) {
// //       fetchAll();
// //     }
// //   }

// //   void dispose() {
// //     _mainScrollController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _onPageRefresh() async {
// //     reset();
// //     fetchAll();
// //   }

// //   onPopped(value) async {
// //     reset();
// //     fetchAll();
// //   }

// //   fetchAll() {
// //     fetchCounters();
// //   }

// //   fetchCounters() async {
// //     var profileCountersResponse =
// //         await ProfileRepository().getProfileCountersResponse();

// //     _cartCounter = profileCountersResponse.cart_item_count;
// //     _wishlistCounter = profileCountersResponse.wishlist_item_count;
// //     _orderCounter = profileCountersResponse.order_count;

// //     _cartCounterString =
// //         counterText(_cartCounter.toString(), default_length: 2);
// //     _wishlistCounterString =
// //         counterText(_wishlistCounter.toString(), default_length: 2);
// //     _orderCounterString =
// //         counterText(_orderCounter.toString(), default_length: 2);

// //     setState(() {});
// //   }

// //   String counterText(String txt, {default_length = 3}) {
// //     var blank_zeros = default_length == 3 ? "000" : "00";
// //     var leading_zeros = "";
// //     if (txt != null) {
// //       if (default_length == 3 && txt.length == 1) {
// //         leading_zeros = "00";
// //       } else if (default_length == 3 && txt.length == 2) {
// //         leading_zeros = "0";
// //       } else if (default_length == 2 && txt.length == 1) {
// //         leading_zeros = "0";
// //       }
// //     }

// //     var newtxt = (txt == null || txt == "" || txt == null.toString())
// //         ? blank_zeros
// //         : txt;

// //     // print(txt + " " + default_length.toString());
// //     // print(newtxt);

// //     if (default_length > txt.length) {
// //       newtxt = leading_zeros + newtxt;
// //     }
// //     //print(newtxt);

// //     return newtxt;
// //   }

// //   reset() {
// //     _cartCounter = 0;
// //     _cartCounterString = "...";
// //     _wishlistCounter = 0;
// //     _wishlistCounterString = "...";
// //     _orderCounter = 0;
// //     _orderCounterString = "...";
// //     setState(() {});
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
// //       child: Scaffold(
// //         key: _scaffoldKey,
// //         drawer: MainDrawer(),
// //         backgroundColor: Colors.white,
// //         appBar: buildAppBar(context),
// //         body: buildBody(context),
// //       ),
// //     );
// //   }

// //   buildBody(context) {
// //     if (is_logged_in.$ == false) {
// //       return Container(
// //           height: 100,
// //           child: Center(
// //               child: Text(
// //                 AppLocalizations.of(context).profile_screen_please_log_in,
// //             style: TextStyle(color: MyTheme.font_grey),
// //           )));
// //     } else {
// //       return RefreshIndicator(
// //         color: MyTheme.accent_color,
// //         backgroundColor: Colors.white,
// //         onRefresh: _onPageRefresh,
// //         displacement: 10,
// //         child: CustomScrollView(
// //           controller: _mainScrollController,
// //           physics: const BouncingScrollPhysics(
// //               parent: AlwaysScrollableScrollPhysics()),
// //           slivers: [
// //             SliverList(
// //               delegate: SliverChildListDelegate([
// //                 buildTopSection(),
// //                 buildCountersRow(),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: Divider(
// //                     height: 24,
// //                   ),
// //                 ),
// //                 buildHorizontalMenu(),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: Divider(
// //                     height: 24,
// //                   ),
// //                 ),
// //                 buildVerticalMenu()
// //               ]),
// //             )
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   buildHorizontalMenu() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         InkWell(
// //           onTap: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (context) {
// //               return OrderList();
// //             }));
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Icon(
// //                       Icons.assignment_outlined,
// //                       color: Colors.green,
// //                     ),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_orders,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //         InkWell(
// //           onTap: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (context) {
// //               return ProfileEdit();
// //             })).then((value) {
// //               onPopped(value);
// //             });
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Icon(
// //                       Icons.person,
// //                       color: Colors.blueAccent,
// //                     ),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_profile,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //         InkWell(
// //           onTap: () {
// //             Navigator.push(context, MaterialPageRoute(builder: (context) {
// //               return Address();
// //             }));
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Icon(
// //                       Icons.location_on,
// //                       color: Colors.amber,
// //                     ),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_address,
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //         /*InkWell(
// //           onTap: () {
// //             ToastComponent.showDialog("Coming soon", context,
// //                 gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
// //           },
// //           child: Column(
// //             children: [
// //               Container(
// //                   height: 40,
// //                   width: 40,
// //                   decoration: BoxDecoration(
// //                     color: MyTheme.light_grey,
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child:
// //                         Icon(Icons.message_outlined, color: Colors.redAccent),
// //                   )),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   "Message",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                       color: MyTheme.font_grey, fontWeight: FontWeight.w300),
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),*/
// //       ],
// //     );
// //   }

// //   buildVerticalMenu() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         children: [
// //           InkWell(
// //             onTap: () {
// //               ToastComponent.showDialog(AppLocalizations.of(context).common_coming_soon, context,
// //                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
// //             },
// //             child: Visibility(
// //               visible: false,
// //               child: Padding(
// //                 padding: const EdgeInsets.only(bottom: 16.0),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                         height: 40,
// //                         width: 40,
// //                         decoration: BoxDecoration(
// //                           color: Colors.amber,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Icon(
// //                             Icons.notifications_outlined,
// //                             color: Colors.white,
// //                           ),
// //                         )),
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                       child: Text(
// //                         AppLocalizations.of(context).profile_screen_notification,
// //                         textAlign: TextAlign.center,
// //                         style:
// //                             TextStyle(color: MyTheme.font_grey, fontSize: 14),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //           InkWell(
// //             onTap: () {
// //               Navigator.push(context, MaterialPageRoute(builder: (context) {
// //                 return OrderList();
// //               }));
// //             },
// //             child: Padding(
// //               padding: const EdgeInsets.only(bottom: 16.0),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                       height: 40,
// //                       width: 40,
// //                       decoration: BoxDecoration(
// //                         color: Colors.green,
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Icon(
// //                           Icons.credit_card_rounded,
// //                           color: Colors.white,
// //                         ),
// //                       )),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: Text(
// //                       AppLocalizations.of(context).profile_screen_purchase_history,
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           ),
// //           club_point_addon_installed.$
// //               ? InkWell(
// //                   onTap: () {
// //                     Navigator.push(context,
// //                         MaterialPageRoute(builder: (context) {
// //                       return Clubpoint();
// //                     }));
// //                   },
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(bottom: 16.0),
// //                     child: Row(
// //                       children: [
// //                         Container(
// //                             height: 40,
// //                             width: 40,
// //                             decoration: BoxDecoration(
// //                               color: Colors.orange,
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Icon(
// //                                 Icons.monetization_on_outlined,
// //                                 color: Colors.white,
// //                               ),
// //                             )),
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                           child: Text(
// //                             AppLocalizations.of(context).profile_screen_earning_points,
// //                             textAlign: TextAlign.center,
// //                             style: TextStyle(
// //                                 color: MyTheme.font_grey, fontSize: 14),
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 )
// //               : Container(),
// //           refund_addon_installed.$
// //               ? InkWell(
// //             onTap: () {
// //               Navigator.push(context,
// //                   MaterialPageRoute(builder: (context) {
// //                     return RefundRequest();
// //                   }));
// //             },
// //             child: Padding(
// //               padding: const EdgeInsets.only(bottom: 16.0),
// //               child: Row(
// //                 children: [
// //                   Container(
// //                       height: 40,
// //                       width: 40,
// //                       decoration: BoxDecoration(
// //                         color: Colors.pinkAccent,
// //                         shape: BoxShape.circle,
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(8.0),
// //                         child: Icon(
// //                           Icons.double_arrow,
// //                           color: Colors.white,
// //                         ),
// //                       )),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //                     child: Text(
// //                       AppLocalizations.of(context).profile_screen_refund_requests,
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                           color: MyTheme.font_grey, fontSize: 14),
// //                     ),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           )
// //               : Container(),
// //         ],
// //       ),
// //     );
// //   }

// //   buildCountersRow() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       children: [
// //         Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 8.0),
// //               child: Text(
// //                 _cartCounterString,
// //                 style: TextStyle(
// //                     fontSize: 16,
// //                     color: MyTheme.font_grey,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //             Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_in_your_cart,
// //                   style: TextStyle(
// //                     color: MyTheme.medium_grey,
// //                   ),
// //                 )),
// //           ],
// //         ),
// //         Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 8.0),
// //               child: Text(
// //                 _wishlistCounterString,
// //                 style: TextStyle(
// //                     fontSize: 16,
// //                     color: MyTheme.font_grey,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //             Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_in_wishlist,
// //                   style: TextStyle(
// //                     color: MyTheme.medium_grey,
// //                   ),
// //                 )),
// //           ],
// //         ),
// //         Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(top: 8.0),
// //               child: Text(
// //                 _orderCounterString,
// //                 style: TextStyle(
// //                     fontSize: 16,
// //                     color: MyTheme.font_grey,
// //                     fontWeight: FontWeight.w600),
// //               ),
// //             ),
// //             Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_in_ordered,
// //                   style: TextStyle(
// //                     color: MyTheme.medium_grey,
// //                   ),
// //                 )),
// //           ],
// //         )
// //       ],
// //     );
// //   }

// //   buildTopSection() {
// //     return Column(
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
// //           child: Container(
// //             width: 120,
// //             height: 120,
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(100),
// //               border: Border.all(
// //                   color: Color.fromRGBO(112, 112, 112, .3), width: 2),
// //               //shape: BoxShape.rectangle,
// //             ),
// //             child: ClipRRect(
// //                 clipBehavior: Clip.hardEdge,
// //                 borderRadius: BorderRadius.all(Radius.circular(100.0)),
// //                 child: FadeInImage.assetNetwork(
// //                   placeholder: 'assets/placeholder.png',
// //                   image: AppConfig.BASE_PATH + "${avatar_original.$}",
// //                   fit: BoxFit.fill,
// //                 )),
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.only(top: 8.0),
// //           child: Text(
// //             "${user_name.$}",
// //             style: TextStyle(
// //                 fontSize: 14,
// //                 color: MyTheme.font_grey,
// //                 fontWeight: FontWeight.w600),
// //           ),
// //         ),
// //         Padding(
// //             padding: const EdgeInsets.only(top: 4.0),
// //             child:
// //                 Text(
// //                   //if user email is not available then check user phone if user phone is not available use empty string
// //                     "${user_email.$ != "" && user_email.$ != null?
// //                     user_email.$:user_phone.$ != "" && user_phone.$ != null?user_phone.$:''}",
// //                     style: TextStyle(
// //                       color: MyTheme.medium_grey,
// //                     ),
// //                   )
// //         ),
// //         Visibility(
// //           visible: wallet_system_status.$,
// //           child: Padding(
// //             padding: const EdgeInsets.only(top: 16.0),
// //             child: Container(
// //               height: 24,
// //               child: FlatButton(
// //                 color: Colors.green,
// //                 // 	rgb(50,205,50)
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: const BorderRadius.only(
// //                   topLeft: const Radius.circular(16.0),
// //                   bottomLeft: const Radius.circular(16.0),
// //                   topRight: const Radius.circular(16.0),
// //                   bottomRight: const Radius.circular(16.0),
// //                 )),
// //                 child: Text(
// //                   AppLocalizations.of(context).profile_screen_check_balance,
// //                   style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.w600),
// //                 ),
// //                 onPressed: () {
// //                   Navigator.push(context, MaterialPageRoute(builder: (context) {
// //                     return Wallet();
// //                   }));
// //                 },
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   AppBar buildAppBar(BuildContext context) {
// //     return AppBar(
// // backgroundColor: Colors.white,
// //       centerTitle: true,
// //       leading: GestureDetector(
// //         child: widget.show_back_button
// //             ? Builder(
// //                 builder: (context) => IconButton(
// //                   icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
// //                   onPressed: () => Navigator.of(context).pop(),
// //                 ),
// //               )
// //             : Builder(
// //                 builder: (context) => GestureDetector(
// //                   onTap: () {
// //                     _scaffoldKey.currentState.openDrawer();
// //                   },
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                         vertical: 18.0, horizontal: 0.0),
// //                     child: Container(
// //                       child: Image.asset(
// //                         'assets/hamburger.png',
// //                         height: 16,
// //                         color: MyTheme.dark_grey,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //       ),
// //       title: Text(
// //         AppLocalizations.of(context).profile_screen_account,
// //         style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
// //       ),
// //       elevation: 0.0,
// //       titleSpacing: 0,
// //     );
// //   }
// // }
