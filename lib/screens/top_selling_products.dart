import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopSellingProducts extends StatefulWidget {
  @override
  _TopSellingProductsState createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
                   backgroundColor: Color(0xffeafbf0),
       // backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(flexibleSpace: Container(
        decoration: BoxDecoration(
          color: MyTheme.green_accent_color_d0
        //     gradient: LinearGradient(colors: [
        //   // Color(0xff0fc744),
        //   // Color(0xff3fcad2)
        //   Color.fromRGBO(206, 35, 43, 1),
        //   Color.fromRGBO(237, 101, 85, 1),
        // ], begin: Alignment.topCenter,end:Alignment.bottomCenter)
        
        ,borderRadius: BorderRadius.horizontal(left: Radius.circular(20),right: Radius.circular(20))),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).top_selling_products_screen_top_selling_products,
        style: TextStyle(fontSize: 20, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getBestSellingProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("product error");
            print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            print(productResponse.toString());
            return SingleChildScrollView(
              child: GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: productResponse.products.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.618),
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    id: productResponse.products[index].id,
                    image: productResponse.products[index].thumbnail_image,
                    name: productResponse.products[index].name,
                    main_price: productResponse.products[index].main_price,
                    stroked_price:
                        productResponse.products[index].stroked_price,
                    has_discount: productResponse.products[index].has_discount,
                  );
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
