import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login.dart';
import 'messenger_list.dart';

class CategoryList extends StatefulWidget {
  CategoryList(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
           backgroundColor: Colors.white,
          key: _scaffoldKey,
          drawer: MainDrawer(),
          // backgroundColor: Color(0xfff1eafb),
          appBar: buildAppBar(context),
          body: Stack(children: [
            CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  buildCategoryList(),
                  Container(
                    height: widget.is_base_category ? 60 : 90,
                  )
                ]))
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: widget.is_base_category || widget.is_top_category
                  ? Container(
                      height: 0,
                    )
                  : buildBottomContainer(),
            ),
          Positioned(
                  top: 250,
                  child: GestureDetector(
                    onTap: () {
                      if (is_logged_in == true) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MessengerList();
                        }));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      }
                    },
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Container(
                        height: 30,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: RichText(
                            text: TextSpan(
                              text: 'Live Chat  ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              children: [
                                WidgetSpan(
                                  child: RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(
                                        Icons.message,
                                        color: Colors.amber,
                                        size: 20,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),  ])),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
       backgroundColor: Colors.white,
    
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color:MyTheme.green_accent_color_d0
            // gradient: LinearGradient(colors: [
            //   // Color(0xff0fc744),
            //   // Color(0xff3fcad2)
            //   Color.fromRGBO(206, 35, 43, 1),
            //   Color.fromRGBO(237, 101, 85, 1),
            // ], begin: Alignment.topCenter,end:Alignment.bottomCenter),
            ,borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20))),
      ),
      // shape: OutlineInputBorder(

      // borderSide: BorderSide.none,
      //   borderRadius: BorderRadius.horizontal(
      //       right: Radius.circular(15), left: Radius.circular(15))),
      leading: widget.is_base_category
          ? GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Builder(
                builder: (context) => Padding(
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
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.arrow_back, color: MyTheme.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      title: Text(
        getAppBarTitle(),
        style: TextStyle(fontSize: 20, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = widget.parent_category_name == ""
        ? (widget.is_top_category
            ? AppLocalizations.of(context).category_list_screen_top_categories
            : AppLocalizations.of(context).category_list_screen_categories)
        : widget.parent_category_name;

    return name;
  }

  buildCategoryList() {
    var future = widget.is_top_category
        ? CategoryRepository().getTopCategories()
        : CategoryRepository()
            .getCategories(parent_id: widget.parent_category_id);
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("category list error");
            print(snapshot.error.toString());
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var categoryResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: categoryResponse.categories.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                    child: buildCategoryItemCard(categoryResponse, index),
                  );
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: MyTheme.shimmer_base,
                          highlightColor: MyTheme.shimmer_highlighted,
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .7,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  Card buildCategoryItemCard(categoryResponse, index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 0.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 80,
            height: 80,
            child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16), right: Radius.zero),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH +
                      categoryResponse.categories[index].banner,
                  fit: BoxFit.cover,
                ))),
        Container(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: Text(
                  categoryResponse.categories[index].name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 8, 4),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (categoryResponse
                                .categories[index].number_of_children >
                            0) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CategoryList(
                              parent_category_id:
                                  categoryResponse.categories[index].id,
                              parent_category_name:
                                  categoryResponse.categories[index].name,
                            );
                          }));
                        } else {
                          ToastComponent.showDialog(
                              AppLocalizations.of(context)
                                  .category_list_screen_no_subcategories,
                              context,
                              gravity: Toast.CENTER,
                              duration: Toast.LENGTH_LONG);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .category_list_screen_view_subcategories,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: categoryResponse.categories[index]
                                            .number_of_children >
                                        0
                                    ? MyTheme.medium_grey
                                    : MyTheme.light_grey,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      " | ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MyTheme.medium_grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CategoryProducts(
                            category_id: categoryResponse.categories[index].id,
                            category_name:
                                categoryResponse.categories[index].name,
                          );
                        }));
                      },
                      child: Text(
                        AppLocalizations.of(context)
                            .category_list_screen_view_products,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.medium_grey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)
                            .category_list_screen_all_products_of +
                        " " +
                        widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
