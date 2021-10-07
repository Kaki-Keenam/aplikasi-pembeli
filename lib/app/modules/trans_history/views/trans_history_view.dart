import 'package:flutter/material.dart';

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
      body: Obx(() => ListView.builder(
          itemCount: controller.transaction?.length,
          itemBuilder: (context, index) {
            return TransactionView(
              trans: controller.transaction?[index],
            );
          },
        ),
      ),
    );
  }
}
