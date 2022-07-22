// import 'package:flutter/material.dart';
// import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
// import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
// import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/string_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class FlashDealProducts extends StatefulWidget {
//   FlashDealProducts({Key key, this.flash_deal_id, this.flash_deal_name})
//       : super(key: key);
//   final int flash_deal_id;
//   final String flash_deal_name;

//   @override
//   _FlashDealProductsState createState() => _FlashDealProductsState();
// }

// class _FlashDealProductsState extends State<FlashDealProducts> {
//    var _page = 1;
//   bool _isInitial = true;
//   ScrollController _xcrollController = ScrollController();
//   bool _showLoadingContainer = false;
//   int _totalData = 0;
//   List<dynamic> _productList = [];
//   int _totalProductData = 0;
//   int _productPage = 1;
//   bool _isProductInitial = true; String _searchKey = "";

//   TextEditingController _searchController = new TextEditingController();

//   Future<dynamic> _future;

//   List<dynamic> _searchList;
//   List<dynamic> _fullList;
//   ScrollController _scrollController;

//   @override
//   void initState() {
//   // Future.delayed(Duration(microseconds: 200)).then((_){
//   //   _onRefresh().currentState?.show();
//   // });

//      fetchData();

//     _xcrollController.addListener(() {
//       Future.delayed(Duration(seconds: 2));
//       //print("position: " + _xcrollController.position.pixels.toString());
//       //print("max: " + _xcrollController.position.maxScrollExtent.toString());

//       if (_xcrollController.position.pixels ==
//           _xcrollController.position.maxScrollExtent) {
//         setState(() {
//           _page++;
//         });
//         _showLoadingContainer = true;
//         fetchData();
//       }
//     });
//     // TODO: implement initState
//     _future =
//         ProductRepository().getFlashDealProducts(id: widget.flash_deal_id);
//     _searchList = [];
//     _fullList = [];
//     super.initState();
//   }

//   _buildSearchList(search_key) async {
//     _searchList.clear();
//     print(_fullList.length);

//     if (search_key.isEmpty) {
//       _searchList.addAll(_fullList);
//       setState(() {});
//       //print("_searchList.length on empty " + _searchList.length.toString());
//       //print("_fullList.length on empty " + _fullList.length.toString());
//     } else {
//       for (var i = 0; i < _fullList.length; i++) {
//         if (StringHelper().stringContains(_fullList[i].name, search_key)) {
//           _searchList.add(_fullList[i]);
//           setState(() {});
//         }
//       }

//       //print("_searchList.length with txt " + _searchList.length.toString());
//       //print("_fullList.length with txt " + _fullList.length.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//           // backgroundColor: Colors.white,
//           backgroundColor: Color(0xffeafbf0),
//           appBar: buildAppBar(context),
//           body: Stack(
//             children: [
//               buildProductList(context),
//               Align(
//                   alignment: Alignment.bottomCenter,
//                   child: buildLoadingContainer())
//             ],
//           )),
//     );
//   }

//   bool shouldProductBoxBeVisible(product_name, search_key) {
//     if (search_key == "") {
//       return true; //do not check if the search key is empty
//     }
//     return StringHelper().stringContains(product_name, search_key);
//   }

//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Color(0xffeafbf0),
//       flexibleSpace: Container(
//           decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [
//           // Color(0xff0fc744),
//           // Color(0xff3fcad2)
//           Color.fromRGBO(206, 35, 43, 1),
//           Color.fromRGBO(237, 101, 85, 1),
//         ]),
//         borderRadius: BorderRadius.horizontal(
//             left: Radius.circular(16), right: Radius.circular(16)),
//       )),
//       toolbarHeight: 75,
//       /*bottom: PreferredSize(
//           child: Container(
//             color: MyTheme.textfield_grey,
//             height: 1.0,
//           ),
//           preferredSize: Size.fromHeight(4.0)),*/
//       leading: Builder(
//         builder: (context) => IconButton(
//           icon: Icon(Icons.arrow_back, color: MyTheme.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       title: Container(
//           width: 250,
//           child: TextField(
//             controller: _searchController,
//             onChanged: (txt) {
//               print(txt);
//               _buildSearchList(txt);
//               // print(_searchList.toString());
//               // print(_searchList.length);
//             },
//             onTap: () {},
//             autofocus: true,
//             decoration: InputDecoration(
//                 hintText:
//                     "${AppLocalizations.of(context).flash_deal_products_screen_search_products_from} : " +
//                         widget.flash_deal_name,
//                 hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.white),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.white, width: 0.0),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.white, width: 0.0),
//                 ),
//                 contentPadding: EdgeInsets.only(left: 5)),
//           )),
//       elevation: 0.0,
//       titleSpacing: 0,
//       actions: <Widget>[
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//           child: IconButton(
//             icon: Icon(Icons.search, color: MyTheme.white),
//             onPressed: () {},
//           ),
//         ),
//       ],
//     );
//   }

//   buildProductList(context) {
//     return FutureBuilder(
//         future: _future,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             //snapshot.hasError
//             //print("product error");
//             //print(snapshot.error.toString());
//             return Container();
//           } else if (snapshot.hasData) {
//             var productResponse = snapshot.data;
//             if (_fullList.length == 0) {
//               _fullList.addAll(productResponse.products);
//               _searchList.addAll(productResponse.products);
//               //print('xcalled');
//             }

//             //print('called');

//             return SingleChildScrollView(
//               controller: _xcrollController,
//               physics: const BouncingScrollPhysics(
//                   parent: AlwaysScrollableScrollPhysics()),
//               child: GridView.builder(
//                 // 2
//                 //addAutomaticKeepAlives: true,
//                 itemCount: _fullList.length,
//                 controller: _scrollController,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 0,
//                     mainAxisSpacing: 0,
//                     childAspectRatio: 0.618),
//                 padding: EdgeInsets.all(5),
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   // 3
//                   return ProductCard(
//                       id: _searchList[index].id,
//                       image: _searchList[index].thumbnail_image,
//                       name: _searchList[index].name,
//                       main_price: _searchList[index].main_price,
//                       stroked_price: _searchList[index].stroked_price,
//                       has_discount: _searchList[index].has_discount);
//                 },
//               ),
//             );
//           } else {
//             return ShimmerHelper()
//                 .buildProductGridShimmer(scontroller: _scrollController);
//           }
//         });
//   }

//   buildLoadingContainer() {
//     return Container(
//       height: _showLoadingContainer ? 36 : 0,
//       width: double.infinity,
//       color: Colors.white,
//       child: Center(
//         child: Text(_totalData == _productList.length
//             ? AppLocalizations.of(context).common_no_more_products
//             : AppLocalizations.of(context).common_loading_more_products),
//       ),
//     );
//   }

//   Future<void> _onRefresh() {

//     // fetchData();
//     //  reset();
//   }

//   reset() {
//     _productList.clear();
//     _isInitial = true;
//     _totalData = 0;
//     _page = 1;
//     _showLoadingContainer = false;
//     setState(() {});
//   }

//   fetchData() async {
//     var productResponse = await ProductRepository().getCategoryProducts(
//         id: widget.flash_deal_id, page: _page, name: _searchKey);
//     _productList.addAll(productResponse.products);
//     _isInitial = false;
//     _totalData = productResponse.meta.total;
//     _showLoadingContainer = false;
//     setState(() {});
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:active_ecommerce_flutter/my_theme.dart';
// // import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
// // import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
// // import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
// // import 'package:active_ecommerce_flutter/helpers/string_helper.dart';
// // import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // class FlashDealProducts extends StatefulWidget {
// //   FlashDealProducts({Key key, this.flash_deal_id, this.flash_deal_name})
// //       : super(key: key);
// //   final int flash_deal_id;
// //   final String flash_deal_name;

// //   @override
// //   _FlashDealProductsState createState() => _FlashDealProductsState();
// // }

// // class _FlashDealProductsState extends State<FlashDealProducts> {
// //    var _page = 1;
// //   bool _isInitial = true;
// //   ScrollController _xcrollController = ScrollController();
// //   bool _showLoadingContainer = false;
// //   int _totalData = 0;
// //   List<dynamic> _productList = [];
// //   int _totalProductData = 0;
// //   int _productPage = 1;
// //   bool _isProductInitial = true; String _searchKey = "";

// //   TextEditingController _searchController = new TextEditingController();

// //   Future<dynamic> _future;

// //   List<dynamic> _searchList;
// //   List<dynamic> _fullList;
// //   ScrollController _scrollController;

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     _future =
// //         ProductRepository().getFlashDealProducts(id: widget.flash_deal_id);
// //     _searchList = [];
// //     _fullList = [];
// //     super.initState();
// //   }

// //   _buildSearchList(search_key) async {
// //     _searchList.clear();
// //     print(_fullList.length);

// //     if (search_key.isEmpty) {
// //       _searchList.addAll(_fullList);
// //       setState(() {});
// //       //print("_searchList.length on empty " + _searchList.length.toString());
// //       //print("_fullList.length on empty " + _fullList.length.toString());
// //     } else {
// //       for (var i = 0; i < _fullList.length; i++) {
// //         if (StringHelper().stringContains(_fullList[i].name, search_key)) {
// //           _searchList.add(_fullList[i]);
// //           setState(() {});
// //         }
// //       }

// //       //print("_searchList.length with txt " + _searchList.length.toString());
// //       //print("_fullList.length with txt " + _fullList.length.toString());
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
// //       child: Scaffold(
// //           // backgroundColor: Colors.white,
// //           backgroundColor: Color(0xffeafbf0),
// //           appBar: buildAppBar(context),
// //           body: Stack(
// //             children: [
// //               buildProductList(context),
// //               Align(
// //                   alignment: Alignment.bottomCenter,
// //                   child: buildLoadingContainer())
// //             ],
// //           )),
// //     );
// //   }

// //   bool shouldProductBoxBeVisible(product_name, search_key) {
// //     if (search_key == "") {
// //       return true; //do not check if the search key is empty
// //     }
// //     return StringHelper().stringContains(product_name, search_key);
// //   }

// //   AppBar buildAppBar(BuildContext context) {
// //     return AppBar(
// //       backgroundColor: Color(0xffeafbf0),
// //       flexibleSpace: Container(
// //           decoration: BoxDecoration(
// //         gradient: LinearGradient(colors: [
// //           // Color(0xff0fc744),
// //           // Color(0xff3fcad2)
// //           Color.fromRGBO(206, 35, 43, 1),
// //           Color.fromRGBO(237, 101, 85, 1),
// //         ]),
// //         borderRadius: BorderRadius.horizontal(
// //             left: Radius.circular(16), right: Radius.circular(16)),
// //       )),
// //       toolbarHeight: 75,
// //       /*bottom: PreferredSize(
// //           child: Container(
// //             color: MyTheme.textfield_grey,
// //             height: 1.0,
// //           ),
// //           preferredSize: Size.fromHeight(4.0)),*/
// //       leading: Builder(
// //         builder: (context) => IconButton(
// //           icon: Icon(Icons.arrow_back, color: MyTheme.white),
// //           onPressed: () => Navigator.of(context).pop(),
// //         ),
// //       ),
// //       title: Container(
// //           width: 250,
// //           child: TextField(
// //             controller: _searchController,
// //             onChanged: (txt) {
// //               print(txt);
// //               _buildSearchList(txt);
// //               // print(_searchList.toString());
// //               // print(_searchList.length);
// //             },
// //             onTap: () {},
// //             autofocus: true,
// //             decoration: InputDecoration(
// //                 hintText:
// //                     "${AppLocalizations.of(context).flash_deal_products_screen_search_products_from} : " +
// //                         widget.flash_deal_name,
// //                 hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.white),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(color: MyTheme.white, width: 0.0),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderSide: BorderSide(color: MyTheme.white, width: 0.0),
// //                 ),
// //                 contentPadding: EdgeInsets.only(left: 5)),
// //           )),
// //       elevation: 0.0,
// //       titleSpacing: 0,
// //       actions: <Widget>[
// //         Padding(
// //           padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
// //           child: IconButton(
// //             icon: Icon(Icons.search, color: MyTheme.white),
// //             onPressed: () {},
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   buildProductList(context) {
// //     return FutureBuilder(
// //         future: _future,
// //         builder: (context, snapshot) {
// //           if (snapshot.hasError) {
// //             //snapshot.hasError
// //             //print("product error");
// //             //print(snapshot.error.toString());
// //             return Container();
// //           } else if (snapshot.hasData) {
// //             var productResponse = snapshot.data;
// //             if (_fullList.length == 0) {
// //               _fullList.addAll(productResponse.products);
// //               _searchList.addAll(productResponse.products);
// //               //print('xcalled');
// //             }

// //             //print('called');

// //             return SingleChildScrollView(
// //               controller: _xcrollController,
// //               physics: const BouncingScrollPhysics(
// //                   parent: AlwaysScrollableScrollPhysics()),
// //               child: GridView.builder(
// //                 // 2
// //                 //addAutomaticKeepAlives: true,
// //                 itemCount: _fullList.length,
// //                 controller: _scrollController,
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                     crossAxisSpacing: 0,
// //                     mainAxisSpacing: 0,
// //                     childAspectRatio: 0.618),
// //                 padding: EdgeInsets.all(5),
// //                 physics: NeverScrollableScrollPhysics(),
// //                 shrinkWrap: true,
// //                 itemBuilder: (context, index) {
// //                   // 3
// //                   return ProductCard(
// //                       id: _searchList[index].id,
// //                       image: _searchList[index].thumbnail_image,
// //                       name: _searchList[index].name,
// //                       main_price: _searchList[index].main_price,
// //                       stroked_price: _searchList[index].stroked_price,
// //                       has_discount: _searchList[index].has_discount);
// //                 },
// //               ),
// //             );
// //           } else {
// //             return ShimmerHelper()
// //                 .buildProductGridShimmer(scontroller: _scrollController);
// //           }
// //         });
// //   }

// //   buildLoadingContainer() {
// //     return Container(
// //       height: _showLoadingContainer ? 36 : 0,
// //       width: double.infinity,
// //       color: Colors.white,
// //       child: Center(
// //         child: Text(_totalData == _productList.length
// //             ? AppLocalizations.of(context).common_no_more_products
// //             : AppLocalizations.of(context).common_loading_more_products),
// //       ),
// //     );
// //   }

// //   Future<void> _onRefresh() {
// //     // reset();
// //     // fetchData();
// //   }

// //   reset() {
// //     _productList.clear();
// //     _isInitial = true;
// //     _totalData = 0;
// //     _page = 1;
// //     _showLoadingContainer = false;
// //     setState(() {});
// //   }

// //   fetchData() async {
// //     var productResponse = await ProductRepository().getCategoryProducts(
// //         id: widget.flash_deal_id, page: _page, name: _searchKey);
// //     _productList.addAll(productResponse.products);
// //     _isInitial = false;
// //     _totalData = productResponse.meta.total;
// //     _showLoadingContainer = false;
// //     setState(() {});
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/string_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlashDealProducts extends StatefulWidget {
  FlashDealProducts({Key key, this.flash_deal_id, this.flash_deal_name })
      : super(key: key);
  final int flash_deal_id;
  final String flash_deal_name;

  @override
  _FlashDealProductsState createState() => _FlashDealProductsState();
}

class _FlashDealProductsState extends State<FlashDealProducts> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  // List<dynamic> _productList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int _totalData = 0;
  bool _showLoadingContainer = false;
  
  Future<dynamic> _future;

  List<dynamic> _searchList;
  List<dynamic> _fullList;

  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    var productResponse = await ProductRepository().getFlashDealProducts(
        id: widget.flash_deal_id, page: _page, );
    // .getFlashDealProducts(id: widget.flash_deal_id);
     _fullList.addAll(productResponse.products);
     print('Fulllist:${_fullList.length}');
    _isInitial = false;
    _totalData = productResponse.meta.total;
    print('totaldata $_totalData' );
    _showLoadingContainer = false;
  
    setState(() {});
  }

  reset() {
    _fullList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData ==  _fullList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }


  void initState() {
    // TODO: implement initState
    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      // print("position: " + _xcrollController.position.pixels.toString());
      // print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
    // TODO: implement initState
    _future = ProductRepository().getFlashDealProducts(
        id: widget.flash_deal_id, page: _page,);

    // getFlashDealProducts(id: widget.flash_deal_id);
    _searchList = [];
    _fullList = [];
    super.initState();
  }

  _buildSearchList(search_key) async {
    _searchList.clear();
    print(_fullList.length);

    if (search_key.isEmpty) {
      _searchList.addAll(_fullList);
      setState(() {});
      //print("_searchList.length on empty " + _searchList.length.toString());
      //print("_fullList.length on empty " + _fullList.length.toString());
    } else {
      for (var i = 0; i < _fullList.length; i++) {
        if (StringHelper().stringContains(_fullList[i].name, search_key)) {
          _searchList.add(_fullList[i]);
          setState(() {});
        }
      }

      //print("_searchList.length with txt " + _searchList.length.toString());
      //print("_fullList.length with txt " + _fullList.length.toString());
    }
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildProductList(context),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ),
      ),
    );
  }

  bool shouldProductBoxBeVisible(product_name, search_key) {
    if (search_key == "") {
      return true; //do not check if the search key is empty
    }
    return StringHelper().stringContains(product_name, search_key);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(16), right: Radius.circular(16)),
          color: MyTheme.green_accent_color_d0
            // gradient: LinearGradient(colors: [
            //   // Color(0xff0fc744),
            //   // Color(0xff3fcad2)
            //   Color.fromRGBO(206, 35, 43, 1),
            //   Color.fromRGBO(237, 101, 85, 1),
            // ], begin: Alignment.topCenter,end:Alignment.bottomCenter),
        ),
      ),
      toolbarHeight: 75,
      /*bottom: PreferredSize(
          child: Container(
            color: MyTheme.textfield_grey,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0)),*/
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
          width: 250,
          child: TextField(
            controller: _searchController,
            onChanged: (txt) {
              print(txt);
              _buildSearchList(txt);
              // print(_searchList.toString());
              // print(_searchList.length);
            },
            onTap: () {},
            autofocus: true,
            decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).flash_deal_products_screen_search_products_from} : " +
                        widget.flash_deal_name,
                hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                contentPadding: EdgeInsets.only(left: 10)),
          )),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            //print("product error");
            //print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            if (_fullList.length == 0) {
              _fullList.addAll(productResponse.products);
              _searchList.addAll(productResponse.products);
              //print('xcalled');
            }

            //print('called');

            return RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              displacement: 12,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                controller: _xcrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: GridView.builder(
                  // 2
                  //addAutomaticKeepAlives: true,
                  itemCount:  _fullList.length,
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 0.618),
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // 3
                    return ProductCard(
                        id:  _fullList[index].id,
                        image:  _fullList[index].thumbnail_image,
                        name:  _fullList[index].name,
                        main_price:  _fullList[index].main_price,
                        stroked_price:  _fullList[index].stroked_price,
                        has_discount:  _fullList[index].has_discount);
                  },
                ),
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
