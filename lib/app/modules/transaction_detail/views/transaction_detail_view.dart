import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_detail_controller.dart';

class TransactionDetailView extends GetView<TransactionDetailController> {
  final transId = Get.arguments as String;
  @override
  Widget build(BuildContext context) {
    print('transId ${transId}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      elevation: 0,
      centerTitle: true,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Get.back();
        },
      ),
    ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: Get.height * 0.3,
            child: Stack(
              children: [
                Positioned(
                  top: Get.height * 0.06,
                  child: Container(
                    width: Get.width * 0.89,
                    height: Get.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber[600],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        StreamBuilder<TransactionModel>(
                          stream: controller.detailTrans(transId),
                          builder: (context, trans) {
                            if(trans.hasData){
                              return Text('${NumberFormat.currency(name: "id", decimalDigits: 0, symbol: "Rp",).format(trans.data?.product?[0].price)}', style: TextStyle(fontSize: 28, fontFamily: 'inter', fontWeight: FontWeight.w600, color: Colors.white),);
                            }
                            return Container();
                          }
                        ),
                        SizedBox(height: 10,),
                        Text('Pembayaran Tunai', style: TextStyle(fontSize: 20,fontFamily: 'inter', fontWeight: FontWeight.w600, color: Colors.white),),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.amber),
                          color: Colors.grey,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/cash.png', ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: Offset(0, 15),
                              spreadRadius: -6,
                              blurRadius: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Text('Detail Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'inter'),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('Tanggal Pesan', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif')),
              StreamBuilder<TransactionModel?>(
                stream: controller.detailTrans(transId),
                builder: (context, trans) {
                  if(trans.hasData){
                    return Text(DateFormat('EEE, d MMM yyyy').format(DateTime.parse(trans.data?.orderDate ?? ""),), style: TextStyle(fontSize: 16, fontFamily: 'inter'));
                  }
                  return Container();
                }
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Produk', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif')),
              StreamBuilder<TransactionModel?>(
                stream: controller.detailTrans(transId),
                builder: (context, trans) {
                  if(trans.hasData){
                    return Text('${trans.data?.product?[0].name}', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif'));
                  }
                  return Container();
                }
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Penjual', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif')),
              StreamBuilder<TransactionModel?>(
                stream: controller.detailTrans(transId),
                builder: (context, trans) {
                  if(trans.hasData){
                    return Text('${trans.data?.storeName}', style: TextStyle(fontSize: 16, fontFamily: 'sans-serif'));
                  }
                  return Container();
                }
              )
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              StreamBuilder<TransactionModel?>(
                stream: controller.detailTrans(transId),
                builder: (context, trans) {
                  if(trans.hasData){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: trans.data?.state == 'REJECTED'
                            ? Colors.red
                            : trans.data?.state == 'PROPOSED'
                            ? Colors.yellow
                            : trans.data?.state == 'OTW'
                            ? Colors.orangeAccent
                            : trans.data?.state == 'ARRIVED'
                            ? Colors.blueAccent
                            : trans.data?.state == 'TRANSACTION_FINISHED'
                            ? Colors.green
                            : Colors.grey,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
                        child: Center(
                          child: Text(
                            trans.data?.state == 'REJECTED'
                                ? 'DIBATALKAN'
                                : trans.data?.state == 'PROPOSED'
                                ? 'DIAJUKAN'
                                : trans.data?.state == 'OTW'
                                ? 'DIJALAN'
                                : trans.data?.state == 'ARRIVED'
                                ? 'SAMPAI'
                                : trans.data?.state == 'TRANSACTION_FINISHED'
                                ? 'SELESAI'
                                : 'KENDALA',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                }
              ),
            ],
          ),
          SizedBox(height: 20,),
          Container(
            width: Get.width * 0.89,
            height: Get.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            child: StreamBuilder<TransactionModel?>(
              stream: controller.detailTrans(transId),
              builder: (context,trans) {
                if(trans.hasData){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: trans.data?.product?[0].image !=  null
                        ? CachedNetworkImage(
                      imageUrl: "${trans.data?.product?[0].image}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Transform.scale(
                        scale: 0.5,
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : Icon(Icons.error),
                  );
                }
                return Container();
              }
            ),
          ),
        ],
      ),
    );
  }
}
