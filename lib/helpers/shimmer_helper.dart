import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';

class ShimmerHelper {
  buildBasicShimmer(
      {double height = double.infinity, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: MyTheme.shimmer_base,
      highlightColor: MyTheme.shimmer_highlighted,
      child: Container(
        height: height,
        width: width,
        color: Colors.white,
      ),
    );
  }

  buildListShimmer({item_count = 10,item_height = 100.0}) {
    return ListView.builder(
      itemCount: item_count,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
          child: ShimmerHelper().buildBasicShimmer(height: item_height),
        );
      },
    );
  }

  buildProductGridShimmer({scontroller, item_count = 10}) {
    return GridView.builder(
      itemCount: item_count,
      controller: scontroller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7),
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.shimmer_base,
            highlightColor: MyTheme.shimmer_highlighted,
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  buildSquareGridShimmer({scontroller, item_count = 10}) {
    return GridView.builder(
      itemCount: item_count,
      controller: scontroller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1),
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.shimmer_base,
            highlightColor: MyTheme.shimmer_highlighted,
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
