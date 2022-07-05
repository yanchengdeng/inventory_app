package com.luojie.erapp.inventory_app

import android.bluetooth.BluetoothAdapter
import androidx.annotation.NonNull
import com.honeywell.rfidservice.RfidManager
import com.honeywell.rfidservice.rfid.RfidReader
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
    ///rfidManager
    private lateinit var rfidMgr : RfidManager
    /// rfid读取类
    lateinit var mRfidReader : RfidReader
    ///蓝牙adapter
    lateinit var mBluetoothAdapter: BluetoothAdapter

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            when(call.method){
                INIT_RFID_SDK ->{
                    checkPermission

                    rfidMgr = RfidManager.getInstance(this)

                }
                START_READ_RFID_DATA ->{

                }
                STOP_READ_RFID_DATA ->{

                }
            }
        }
    }
}
