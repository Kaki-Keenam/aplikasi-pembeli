
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/modules/components/modal_view/favorite_food_view.dart';
import 'package:kakikeenam/app/modules/components/widgets/custom_textfield.dart';
import 'package:kakikeenam/app/modules/components/widgets/loading_view.dart';
import 'package:kakikeenam/app/routes/app_pages.dart';

import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        print("list : ${controller.listFav[1].title}");
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
              IconButton(
                onPressed: () {},
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
                    child: Obx(
                      () => CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomTextField(
                  hintText: "Cari disini",
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder<DocumentSnapshot?>(
            stream: controller.getListFav(),
            builder: (context, snapshot) {
              var data = snapshot.data?["favorites"] ?? null;
              var favorite = controller.setDataList(data);
              if (snapshot.hasData) {
                return favorite?.length == 0
                    ? Center(
                        child: Text("Belum ada Favorit"),
                      )
                    : ListView.builder(
                        itemCount: favorite?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return FavoriteFoodView(
                            popularFoods: favorite?[index],
                            direction: Axis.vertical,
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            func: () => Get.toNamed(Routes.DETAILITEM,
                                arguments: favorite?[index]),
                          );
                        },
                      );
              }
              return LoadingView();
            },
          ),
        ),
      ),
    );
  }
}
