import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/entity/UploadLabelParams.dart';
import 'package:inventory_app/app/utils/logger.dart';
import '../../mould_read_result/controllers/mould_read_result_controller.dart';
import '../controllers/take_photo_controller.dart';

class TakePhotoView extends GetView<TakePhotoController> {
  var photoType = Get.arguments['photoType'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('拍照'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.initializeControllerFuture == null
            ? Center(child: Container(color: Colors.black))
            : Center(
                child: FutureBuilder<void>(
                  future: controller.initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return Container(
                          alignment: AlignmentDirectional.topCenter,
                          child: CameraPreview(controller.cameraController));
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            EasyLoading.show(status: "拍照中....");
            await controller.initializeControllerFuture;
            final image = await controller.cameraController.takePicture();
            Log.d("拍照成功${image.path}");

            final MouldReadResultController resultController =
                Get.find<MouldReadResultController>();
            resultController.refreshImage(
                PhotoInfo(fullPath: image.path, photoType: photoType));
            EasyLoading.dismiss();
            Get.back();
          } catch (e) {
            Log.d("拍照异常${e}");
          }
        },
        child: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
