import 'package:get/get.dart';

import '../controllers/add_resep_controller.dart';

class AddResepBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddResepController>(
      () => AddResepController(),
    );
  }
}
