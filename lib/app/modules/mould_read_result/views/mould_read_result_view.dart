import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../style/text_style.dart';
import '../controllers/mould_read_result_controller.dart';
/**
 * 模具读取结果
 */

class MouldReadResultView extends GetView<MouldReadResultController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('读取结果'),
        centerTitle: true,
      ),
      body: Container(child: topInfoWidget()),
    );
  }

  Widget getReadButton() {
    if (controller.isReadData.value) {
      return Text('开始读取');
    } else {
      return Text("停止读取");
    }
  }

  ///顶部信息
  Widget topInfoWidget() {
    return Container(
      margin: EdgeInsetsDirectional.all(10),
      child: Card(
        color: Colors.blue,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(10),
              alignment: AlignmentDirectional.topStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('固定资产编号：1111111111', style: textBoldNumberWhiteStyle()),
                  Text('SGM车型：222', style: textLitleWhiteTextStyle()),
                  Text('零件号：3333333', style: textLitleWhiteTextStyle()),
                  Text('工装&模具名称：4444', style: textLitleWhiteTextStyle()),
                  Obx(() => (Visibility(
                      visible: controller.isShowAllInfo.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('工装&模具尺寸(mm)：33333*222*11',
                              style: textLitleWhiteTextStyle()),
                          Text('工装&模具重量(kg)：44',
                              style: textLitleWhiteTextStyle()),
                          Text('使用单位：xxxxxx', style: textLitleWhiteTextStyle()),
                          Text('制造单位：xxxxx', style: textLitleWhiteTextStyle()),
                          Text('工装模具使用模次：xxxxx',
                              style: textLitleWhiteTextStyle()),
                          Text('工装模具寿命：xxxxx',
                              style: textLitleWhiteTextStyle()),
                        ],
                      )))),
                ],
              ),
            ),
            InkWell(
              onTap: () => {
                controller.isShowAllInfo.value = !controller.isShowAllInfo.value
              },
              child: Container(
                padding: EdgeInsetsDirectional.all(10),
                child: Obx(() => (controller.isShowAllInfo.value
                    ? Image(
                        image: AssetImage('images/icon_arrow_up.png'),
                        width: 20,
                        height: 20,
                      )
                    : Image(
                        image: AssetImage('images/icon_arrow_down.png'),
                        width: 20,
                        height: 20,
                      ))),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  // await _initializeControllerFuture;

                  // Attempt to take a picture and then get the location
                  // where the image file is saved.
                  // final image = await _controller.takePicture();
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            )
          ],
        ),
      ),
    );
  }

  // 底部信息
  Widget bottomInfoWidget() {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 130,
        ),
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.red,
              size: 10,
            ),
            Text('标签编号', style: textBoldNumberBlueStyle()),
            Text(
              '(经纬度xxxx)',
              style: textNormalListTextStyle(),
            ),
            ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Text('');
              },
            )
          ],
        ),
        Image(
          image: AssetImage('images/account_header.png'),
          width: 100,
          height: 100,
        ),
        Image(
          image: AssetImage('images/account_header.png'),
          width: 100,
          height: 100,
        ),
        Image(
          image: AssetImage('images/account_header.png'),
          width: 100,
          height: 100,
        ),
        Image(
          image: AssetImage('images/account_header.png'),
          width: 100,
          height: 100,
        ),
        Image(
          image: AssetImage('images/account_header.png'),
          width: 100,
          height: 100,
        )
      ],
    );
  }
}
