import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'components/home_top_bar.dart';
import 'components/child_card_widget.dart';
import 'components/add_child_button.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return SafeArea(
      child: Column(
        children: [
          const HomeTopBar(), 
          
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: controller.childrenList.length,
                      itemBuilder: (context, index) {
                        final child = controller.childrenList[index];
                        return ChildCardWidget(child: child, index: index);
                      },
                    ),
                    const SizedBox(height: 20),
                    const AddChildButton(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}