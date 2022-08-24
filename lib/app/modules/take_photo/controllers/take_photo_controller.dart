import 'package:camera/camera.dart';
import 'package:get/get.dart';

class TakePhotoController extends GetxController {
  late CameraDescription firstCamera;
  late CameraController cameraController;
  var _initializeControllerFuture = Rx<Future<void>?>(null);
  set initializeControllerFuture(value) =>
      _initializeControllerFuture.value = value;
  get initializeControllerFuture => _initializeControllerFuture.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;

    cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture.value = cameraController.initialize();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    cameraController.dispose();
  }
}
