import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:kakikeenam/app/modules/components/model_view/review_view.dart';
import 'package:kakikeenam/app/modules/vendor_detail/controllers/vendor_detail_controller.dart';

class ReviewsView extends GetView<VendorDetailController> {
  final String? vendorId;
  const ReviewsView({Key? key, this.vendorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder<ReviewModel>(
            future: controller.getReviews(vendorId!),
            builder: (context, review) {
              if (review.hasData) {
                return ListView.builder(
                    itemCount: review.data?.results?.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return ReviewView(
                        review: review.data?.results?[index],
                      );
                    });
              }
              return Container();
            }));
  }
}
