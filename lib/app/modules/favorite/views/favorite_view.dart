import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/model_view/favorite_food_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_text_field.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: AppBar(
            elevation: 0,
            title: Text(
              "Favorites",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              SizedBox(
                width: 20,
              ),
            ],
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: NewCustomTextField(
                  title: "Cari",
                  hint: "Cari disini",
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Obx(
            () => controller.food?.length == 0
                ? Center(
                    child: Text("Belum ada Favorit"),
                  )
                : ListView.builder(
                    itemCount: controller.food?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return FavoriteFoodView(
                        product: controller.food?[index],
                        direction: Axis.vertical,
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        func: () => Get.toNamed(Routes.DETAILITEM,
                            arguments: controller.food?[index]),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
