package com.luojie.erapp.inventory_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "mould_read_result/blue_teeth"

    ///初始化rfid_sdk
    private val INIT_RFID_SDK = "initRfidSdk"
    ///rfid 开始通过蓝牙获取信息
    private val START_READ_RFID_DATA = "startReadRfid"
    ///rfid 停止通过蓝牙获取信息
    private val STOP_READ_RFID_DATA = "stopReadRfidSdk"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            when(call.method){
                INIT_RFID_SDK ->{
                    result.success("hha")

                }
                START_READ_RFID_DATA ->{

                }
                STOP_READ_RFID_DATA ->{

                }
            }
        }
    }
}
