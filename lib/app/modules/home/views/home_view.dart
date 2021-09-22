
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/data/models/carousels_model.dart';
import 'package:kakikeenam/app/data/models/food_model.dart';
import 'package:kakikeenam/app/modules/components/modal_view/food_nearby_view.dart';
import 'package:kakikeenam/app/modules/components/modal_view/food_place_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height * 0.3),
        child: AppBar(
          elevation: 0,
          titleSpacing: 10,
          title: Text(
            "Kaki Keenam",
          ),
          actions: [
            IconButton(
              onPressed: () {
              },
              icon: Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
              ),
            ),
            Container(
              width: 45,
              height: 45,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: Obx(() => CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: authC.user.value.photoUrl == null
                            ? Image.asset(
                          "assets/images/person.png",
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          authC.user.value.photoUrl ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: Get.height * 0.1),
                      width: Get.width,
                      height: Get.height * 0.18,
                      child: Swiper(
                        onIndexChanged: (index) {
                          controller.currentIndex.value = index;
                        },
                        autoplay: true,
                        layout: SwiperLayout.DEFAULT,
                        itemCount: corousels.length,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: AssetImage(
                                    corousels[index].image ?? "",
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          controller.map<Widget>(corousels, (index, image) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 6,
                          width: 6,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentIndex.value == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Jajanan terdekat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 200,
              width: Get.width,
              child: ListView.builder(
                itemCount: nearFoods.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FoodNearbyView(
                    nearFoods: nearFoods[index],
                    func: () => Get.toNamed(Routes.DETAILITEM, arguments: nearFoods[index]),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Makanan di daerahmu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 120,
              width: Get.width,
              child: ListView.builder(
                itemCount: popularFoods.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FoodPlaceView(
                    popularFoods: popularFoods[index],
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black54,
                    ),
                    func: () => Get.toNamed(Routes.DETAILITEM, arguments: popularFoods[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
