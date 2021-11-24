
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/markers_model.dart';
import 'package:kakikeenam/app/modules/vendor_detail/views/components/product_view.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';
import 'package:kakikeenam/app/utils/strings.dart';

import '../controllers/vendor_detail_controller.dart';
import 'components/reviews_view.dart';

class VendorDetailView extends GetView<VendorDetailController> {
  final vendor = Get.arguments as Markers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text("Detail Pedagang", style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color: AppColor.primary,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          margin: EdgeInsets.only(bottom: 15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: vendor.image != null ? CachedNetworkImage(
                              imageUrl: "${vendor.image}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(),
                              ),
                            ): Image.asset(Strings.avatar)
                          ),
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${vendor.name}', style: TextStyle(color:Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),
                            SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.circle, color: Colors.green, size: 20,),
                                SizedBox(width: 10,),
                                Text("Sedang aktif"),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Text('Kualitas Layanan'),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          size: 20,
                          color: Colors.orange,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "${vendor.rating} Reviews",
                            style: TextStyle(fontSize: 10, fontFamily: "inter"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Section 2 - Search Result
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: Get.height,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: TabBar(
                  indicatorColor: AppColor.primary,
                    tabs: [
                      Tab(child: Text('Produk', style: TextStyle(color: Colors.black54),),),
                      Tab(child: Text('Ulasan', style: TextStyle(color: Colors.black54),),),
                    ],

                ),
                body: TabBarView(
                  children: [
                    ProductView(vendorId: vendor.id,),
                    ReviewsView(vendorId: vendor.id,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
