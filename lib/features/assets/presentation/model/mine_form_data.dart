import 'package:flutter/material.dart';

class MineFormData {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  MineFormData({
    TextEditingController? nameController,
    TextEditingController? addressController,
    TextEditingController? phoneController,
    TextEditingController? emailController,
  }) : nameController = nameController ?? TextEditingController(),
       addressController = addressController ?? TextEditingController(),
       phoneController = phoneController ?? TextEditingController(),
       emailController = emailController ?? TextEditingController();

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
}
