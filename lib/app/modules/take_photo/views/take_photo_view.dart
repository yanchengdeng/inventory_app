import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/app/apis/apis.dart';
import 'package:inventory_app/app/utils/logger.dart';
import 'package:inventory_app/app/widgets/toast.dart';
import '../controllers/take_photo_controller.dart';

class TakePhotoView extends GetView<TakePhotoController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('拍照'),
        centerTitle: true,
      ),
      body: Obx(() =>
      controller.initializeControllerFuture == null? Center(child: Container(color: Colors.black)) :
         Center(
          child: FutureBuilder<void>(
            future: controller.initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Container(
                  alignment: AlignmentDirectional.topCenter,
                    child: CameraPreview(controller.cameraController)
                );
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          try{
            await controller.initializeControllerFuture;
            final image = await controller.cameraController.takePicture();
            Log.d("拍照成功${image.path}");
            FileApi.uploadFile(image.path);
          }catch(e){
            Log.d("拍照异常${e}");
          }
        },
        child: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }


}
