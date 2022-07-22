import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
class ProductCard extends StatefulWidget {

  int id;
  String image;
  String name;
  String main_price;
  String stroked_price;
  bool has_discount;

  ProductCard({Key key,this.id, this.image, this.name, this.main_price,this.stroked_price,this.has_discount}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48 ) / 2);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id,);
        }));
      },
      child: Card(semanticContainer: false,
      color: MyTheme.green_accent_color_fb,
     //color: Colors.amber,
         //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 0.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  // height: 158,
                   height: (( MediaQuery.of(context).size.width - 28 ) / 2) + 1,
                     //height: (MediaQuery.of(context).size.width - 36) / 3.5,
                  child: ClipRRect(
                    // clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(00), bottom: Radius.circular(0)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: AppConfig.BASE_PATH + widget.image,
                        fit: BoxFit.cover,
                      ))),
              Container(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 13,
                            height: 1.2,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Text(
                        widget.main_price,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                   widget.has_discount ? Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        widget.stroked_price,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          decoration:TextDecoration.lineThrough,
                            color: MyTheme.medium_grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
