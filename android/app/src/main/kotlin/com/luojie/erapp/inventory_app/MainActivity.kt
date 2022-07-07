package com.luojie.erapp.inventory_app

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
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
    private  var rfidMgr: RfidManager? = null

    /// rfid读取类
    lateinit var mRfidReader: RfidReader
    private  var blueToothDialog: BlueToothDialog? = null


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
            blueToothDialog = BlueToothDialog(MainActivity@this,rfidMgr!!)
            val window = blueToothDialog?.window
            val height = resources.displayMetrics.heightPixels
            val width = resources.displayMetrics.widthPixels
            window?.setLayout(width -100,height-150)
            blueToothDialog?.show()
        } else if (!blueToothDialog?.isShowing!!) {
            blueToothDialog?.show()
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


    override fun onResume() {
        super.onResume()
        Log.w("yancheng","onResume------")
    }

    override fun onPause() {
        super.onPause()
        Log.w("yancheng","onPause------")
    }


}
