import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      child: Container(
        height: 150,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 1),
              spreadRadius: 0.4,
              blurRadius: 0.4
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: product?.image != null ? CachedNetworkImage(
                imageUrl: "${product?.image}",
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Transform.scale(
                  scale: 0.5,
                  child: CircularProgressIndicator(),
                ),
              ): Icon(Icons.error),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                product?.name ?? "Loading",
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "roboto",
                ),
              ),
            ),
            SizedBox(height: 5,),
            product?.price?.isNegative == false ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                NumberFormat.currency(
                  name: "id",
                  decimalDigits: 0,
                  symbol: "Rp",
                ).format(product?.price).toString(),
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ): Text('${product?.price}'),
          ],
        ),
      ),
    );
  }
}
