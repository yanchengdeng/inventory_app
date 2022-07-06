package com.luojie.erapp.inventory_app

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.honeywell.rfidservice.RfidManager
import com.honeywell.rfidservice.rfid.RfidReader
import com.luojie.erapp.inventory_app.dialog.BlueToothDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "mould_read_result/blue_teeth"

    //授权返回
    private val PERMISSION_REQUEST_CODE = 1
    private val mPermissions = listOf(Manifest.permission.ACCESS_COARSE_LOCATION)
    private val mRequestPermissions = mutableListOf<String>()

    ///初始化rfid_sdk
    private val INIT_RFID_SDK = "initRfidSdk"

    ///rfid 开始通过蓝牙获取信息
    private val START_READ_RFID_DATA = "startReadRfid"

    ///rfid 停止通过蓝牙获取信息
    private val STOP_READ_RFID_DATA = "stopReadRfidSdk"

    ///rfidManager
    private lateinit var rfidMgr: RfidManager

    /// rfid读取类
    lateinit var mRfidReader: RfidReader
    private lateinit var blueToothDialog: BlueToothDialog


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                INIT_RFID_SDK -> {
                    if (requestPermissions()) {
                        initBlueTooth()
                    } else {
                        requestPermissions()
                    }
                }
                START_READ_RFID_DATA -> {

                }
                STOP_READ_RFID_DATA -> {

                }
            }
        }
    }

    //初始化蓝牙
    private fun initBlueTooth() {

        rfidMgr = RfidManager.getInstance(this)
        if (blueToothDialog == null) {
            blueToothDialog = BlueToothDialog(rfidMgr)
//            blueToothDialog.showNow(fragmentManager!!, "dialog")
        } else if (blueToothDialog.isAdded) {
//            blueToothDialog.showNow(fragmentManager!!, "dialog")
        }
    }

    private fun requestPermissions(): Boolean {
        if (Build.VERSION.SDK_INT >= 23) {
            for (i in mPermissions.indices) {
                if (ContextCompat.checkSelfPermission(
                        this,
                        mPermissions[i]
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    mRequestPermissions.add(mPermissions[i])
                }
            }
            if (mRequestPermissions.isNotEmpty()) {
                ActivityCompat.requestPermissions(
                    this,
                    mPermissions.toTypedArray(),
                    PERMISSION_REQUEST_CODE
                )
                return false
            }
        }
        return true
    }


}
