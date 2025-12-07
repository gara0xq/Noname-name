import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/add_child_controller.dart';
import '../../../auth/view/widget/custom_input_field.dart';
import '../widgets/gender_selection_card.dart';

class AddChildScreen extends StatelessWidget {
  final bool showSkipButton;

  AddChildScreen({super.key, bool? showSkipButton})
    : showSkipButton =
          showSkipButton ??
          (Get.arguments != null && Get.arguments['showSkipButton'] == true);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddChildController());

    return Scaffold(
      backgroundColor: AppColors.beigeBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSkipButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.offAllNamed("/main");
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkPrimary,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20),
                const SizedBox(height: 20),
                const Text(
                  "Add child",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: AppColors.darkPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Let's add first child",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                Obx(
                  () => Row(
                    spacing: 18,
                    children: [
                      GenderSelectionCard(
                        gender: 'male',
                        label: 'Boy',
                        color: AppColors.primaryOrange,
                        imagePath: 'assets/images/boy.png',
                        isSelected: controller.selectedGender.value == 'male',
                        onTap: () => controller.selectGender('male'),
                      ),
                      GenderSelectionCard(
                        gender: 'female',
                        label: 'Girl',
                        color: AppColors.primaryGreen,
                        imagePath: 'assets/images/girl.png',
                        isSelected:
                            controller.selectedGender.value == 'female',
                        onTap: () => controller.selectGender('female'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Form(
                  key: controller.formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      CustomInputField(
                        title: "Name",
                        controller: controller.nameController,
                        hint: "John",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      GestureDetector(
                        onTap: () => controller.selectBirthDate(context),
                        child: AbsorbPointer(
                          child: CustomInputField(
                            title: "Date",
                            controller: controller.birthDateController,
                            hint: "YYYY-MM-DD",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Birth date is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Obx(
                  () => InkWell(
                    onTap: controller.isLoading.value
                        ? null
                        : () => controller.addChild(
                            navigateToMain: showSkipButton,
                          ),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.darkPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: AppColors.beigeBackground,
                            )
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                color: AppColors.beigeBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
