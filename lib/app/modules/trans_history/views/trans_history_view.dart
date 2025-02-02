import 'package:flutter/material.dart';
import 'package:kakikeenam/app/utils/strings.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/modules/components/model_view/transaction_view.dart';

import '../controllers/trans_history_controller.dart';

class TransHistoryView extends GetView<TransHistoryController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.trans_title),
        centerTitle: true,
      ),
      body: Obx(() => controller.transaction != null ? ListView.separated(
        separatorBuilder: (context, index){
          return SizedBox(height: 10,);
        },
          itemCount: controller.transaction!.length,
          itemBuilder: (context, index) {
            return TransactionView(
              trans: controller.transaction?[index],
            );
          },
        ): Center(child: Lottie.asset(Strings.no_data)),
      )
    );
  }
}
