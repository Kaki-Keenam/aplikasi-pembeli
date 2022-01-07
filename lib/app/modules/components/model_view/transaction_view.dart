import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/modules/trans_history/controllers/trans_history_controller.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

class TransactionView extends GetView<TransHistoryController> {
  const TransactionView({
    Key? key,
    this.func,
    this.trans,
    required this.index,
  }) : super(key: key);

  final TransactionModel? trans;
  final VoidCallback? func;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: trans?.isRated != null && trans?.isRated == true || trans?.state != "TRANSACTION_FINISHED" ? 130 : 200,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: Offset(0, 15),
                    spreadRadius: -6,
                    blurRadius: 15,
                  )
                ]),
            child: InkWell(
              onTap: () => Get.toNamed(Routes.TRANSACTION_DETAIL,
                  arguments: trans?.transactionId),
              onLongPress: () => controller.delTrans(trans!.transactionId!),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: trans?.product?[0].image != null
                          ? CachedNetworkImage(
                              imageUrl: "${trans?.product?[0].image}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Image.asset('assets/images/no-food.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width * 0.42,
                          child: Text(
                            "${trans?.product?[0].name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                fontFamily: "inter"),
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${trans?.storeName}",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF444444),
                              fontFamily: "inter"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
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
                                "${trans?.rating} Reviews",
                                style: TextStyle(
                                    fontSize: 10, fontFamily: "inter"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: trans?.state == 'REJECTED'
                                    ? Colors.red
                                    : trans?.state == 'PROPOSED'
                                        ? Colors.yellow
                                        : trans?.state == 'OTW'
                                            ? Colors.orangeAccent
                                            : trans?.state == 'ARRIVED'
                                                ? Colors.blueAccent
                                                : trans?.state ==
                                                        'TRANSACTION_FINISHED'
                                                    ? Colors.green
                                                    : Colors.grey,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 6),
                                child: Center(
                                  child: Text(
                                    trans?.state == 'REJECTED'
                                        ? 'DIBATALKAN'
                                        : trans?.state == 'PROPOSED'
                                            ? 'DIAJUKAN'
                                            : trans?.state == 'OTW'
                                                ? 'DIJALAN'
                                                : trans?.state == 'ARRIVED'
                                                    ? 'SAMPAI'
                                                    : trans?.state ==
                                                            'TRANSACTION_FINISHED'
                                                        ? 'SELESAI'
                                                        : 'KENDALA',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (trans?.isRated != null && trans?.isRated != true && trans?.state == "TRANSACTION_FINISHED")
            Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: Offset(0, 15),
                        spreadRadius: -6,
                        blurRadius: 15,
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                      child: TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Berikan Berikan Penilaian ke Pedagang",
                        titlePadding: EdgeInsets.all(20),
                        contentPadding: EdgeInsets.all(16),
                        content: Column(
                          children: [
                            RatingBar.builder(
                              minRating: 1,
                              itemSize: 35,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.orangeAccent,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                                controller.setRating = rating;
                              },
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      controller.feedBack(controller.user.photoUrl, index);
                                      Get.back();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.green,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Terimakasih',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Berikan Penilaian',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'inter',
                          color: Colors.black45,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     RatingBar.builder(
                  //           minRating: 1,
                  //           itemSize: 30,
                  //           itemBuilder: (context, _) => Icon(
                  //             Icons.star,
                  //             color: Colors.orangeAccent,
                  //           ),
                  //           onRatingUpdate: (rating) {
                  //             print(rating);
                  //             controller.setRating = rating;
                  //           },
                  //         ),
                  //     SizedBox(width: 20,),
                  //     ElevatedButton(onPressed: (){
                  //       controller.feedBack(controller.user.photoUrl, index);
                  //     }, child: Text("Kirim"),),
                  //
                  //   ],
                  // ),
                )),
        ],
      ),
    );
  }
}
