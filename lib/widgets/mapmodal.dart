import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shugo/screens/homepage.dart';

Future<dynamic> MaptypeModal(BuildContext context) {
  final mapController = Get.find<MapController>();
  final controller = Get.put(MapController());

  return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: 350.0,
          color: Colors.transparent,
          child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.selectedIndex.value = 0;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/clusterMap.jpg")),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Text("Cluster Map")
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.selectedIndex.value = 1;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/mapIcon.jpg")),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Text("Point Map")
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      });
}
