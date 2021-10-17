import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

class FoodNearbyView extends StatelessWidget {
  const FoodNearbyView({
    Key? key,
    this.func, this.product,
  }) : super(key: key);

  final ProductModel? product;
  final VoidCallback? func;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: 200,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: product?.image != null ? CachedNetworkImage(
                      imageUrl: "${product?.image}",
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Transform.scale(
                        scale: 0.5,
                        child: CircularProgressIndicator(),
                      ),
                    ): Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2,
                    top: 10,
                  ),
                  child: Text(
                    product?.name ?? "Loading",
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "roboto",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
