import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/markers_model.dart';

class DetailMarker extends StatelessWidget {
  const DetailMarker({
    Key? key,
    required this.listNear,
    this.onPageChanged,
    this.index,
  }) : super(key: key);

  final List<Markers>? listNear;
  final ValueChanged<int>? onPageChanged;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 68.0),
        child: SizedBox(
          height: Get.width * 0.3, // card height
          child: PageView.builder(
            itemCount: listNear?.length,
            controller: PageController(viewportFraction: 0.9),
            onPageChanged: onPageChanged,
            itemBuilder: (_, i) {
              return Transform.scale(
                scale: i == index ? 1 : 0.9,
                child: Container(
                  height: Get.width * 0.3,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.5, 0.5),
                        color: Color(0xff000000).withOpacity(0.12),
                        blurRadius: 20,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 9, top: 7, bottom: 7, right: 9),
                        child: Container(
                          height: 94.0,
                          width: 94.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: listNear?[i].image ?? "",
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, right: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 2,
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  listNear?[i].name ?? "",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 17,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    "${listNear?[i].id}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 10,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    listNear?[i].street ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
