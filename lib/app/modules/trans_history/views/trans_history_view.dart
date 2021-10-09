import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/components/model_view/transaction_view.dart';

import '../controllers/trans_history_controller.dart';

class TransHistoryView extends GetView<TransHistoryController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori Transaksi'),
        centerTitle: true,
      ),
      body: controller.transaction != null ? Obx(() => ListView.builder(
          itemCount: controller.transaction?.length,
          itemBuilder: (context, index) {
            return TransactionView(
              trans: controller.transaction?[index],
            );
          },
        ),
      ): Center(child: Lottie.asset('assets/animation/no-data.zip')),
    );
  }
}
