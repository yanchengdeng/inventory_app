package com.luojie.erapp.inventory_app

import android.Manifest
import android.content.pm.PackageManager
import android.location.Address
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.github.dfqin.grantor.PermissionListener
import com.github.dfqin.grantor.PermissionsUtil
import com.honeywell.rfidservice.EventListener
import com.honeywell.rfidservice.RfidManager
import com.honeywell.rfidservice.TriggerMode
import com.honeywell.rfidservice.rfid.OnTagReadListener
import com.honeywell.rfidservice.rfid.RfidReader
import com.honeywell.rfidservice.rfid.TagAdditionData
import com.honeywell.rfidservice.rfid.TagReadOption
import com.luojie.erapp.inventory_app.dialog.BlueToothDialog
import com.luojie.erapp.inventory_app.utils.LocationUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "mould_read_result/blue_teeth"

    //授权返回
    private val PERMISSION_REQUEST_CODE = 100
    private val mPermissions = listOf(Manifest.permission.ACCESS_COARSE_LOCATION)

    ///初始化rfid_sdk
    private val INIT_RFID_SDK = "initRfidSdk"

    ///rfid 开始通过蓝牙获取信息
    private val START_READ_RFID_DATA = "startReadRfid"

    ///rfid 停止通过蓝牙获取信息
    private val STOP_READ_RFID_DATA = "stopReadRfidSdk"

    ///读取经纬度
    private val GET_GPS_LAT_LNG = "getGpsLatLng"

    ///rfidManager
    private  var rfidMgr: RfidManager? = null

    /// rfid读取类
    lateinit var mReader: RfidReader
    private  var blueToothDialog: BlueToothDialog? = null
    // 读写信息
    private var mTagDataList = mutableListOf<String>()
    private var mIsReadBtnClicked = false


    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                INIT_RFID_SDK -> {
                    checkPermission()
                    result.success("已连接：$")
                }
                START_READ_RFID_DATA -> {
                    rfidMgr?.addEventListener(mEventListener)
                    mIsReadBtnClicked = true
                    read()
                    result.success(listOf("ok--reading"))
                }
                STOP_READ_RFID_DATA -> {
                    rfidMgr?.removeEventListener(mEventListener)
                    mIsReadBtnClicked = false
                    stopRead()
                    result.success(listOf("ok--stop reading"))
                }

                GET_GPS_LAT_LNG ->{

                    PermissionsUtil.requestPermission(this,object :PermissionListener{
                        /**
                         * 通过授权
                         * @param permission
                         */
                        override fun permissionGranted(permission: Array<out String>) {
                            LocationUtils.getInstance(this@MainActivity).addressCallback = object : LocationUtils.AddressCallback{
                                override fun onGetAddress(address: Address?) {
                                    val countryName = address!!.countryName //国家

                                    val adminArea = address!!.adminArea //省

                                    val locality = address!!.locality //市

                                    val subLocality = address!!.subLocality //区

                                    val featureName = address!!.featureName //街道

                                    Log.d(
                                        "定位地址",
                                        countryName +","+adminArea+","+locality+","+subLocality+","+featureName
                                    )
                                }

                                override fun onGetLocation(lat: Double, lng: Double) {
                                    Log.d(
                                        "定位地址","${lat},${lng}")
                                    result.success("${lat},${lng}")
                                }

                            }
                        }

                        /**
                         * 拒绝授权
                         * @param permission
                         */
                        override fun permissionDenied(permission: Array<out String>) {
                            Toast.makeText(this@MainActivity,"拒绝无法正常使用",Toast.LENGTH_LONG).show();
                        }

                    }, Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION)


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


    @RequiresApi(Build.VERSION_CODES.M)
    private fun checkPermission(){
        if (PackageManager.PERMISSION_GRANTED != checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)){
            //判断是否以授权相机权限，没有则授权
            ActivityCompat.requestPermissions(
                this,
                mPermissions.toTypedArray(),
                PERMISSION_REQUEST_CODE
            )
        }else{
            initBlueTooth()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (requestCode == PERMISSION_REQUEST_CODE){
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED){
                initBlueTooth()
            }else{
                Toast.makeText(MainActivity@this,"请授权",Toast.LENGTH_LONG).show()
            }
        }
    }

    private val mEventListener: EventListener = object : EventListener {
        override fun onDeviceConnected(o: Any) {}
        override fun onDeviceDisconnected(o: Any) {}
        override fun onReaderCreated(b: Boolean, rfidReader: RfidReader) {}
        override fun onRfidTriggered(trigger: Boolean) {
            if (mIsReadBtnClicked || !trigger) {
                mIsReadBtnClicked = false
                stopRead()
            } else {
                read()
            }
        }

        override fun onTriggerModeSwitched(triggerMode: TriggerMode) {}
    }


    private fun isReaderAvailable(): Boolean {
        return mReader.available()
    }

    private fun read() {
        if (isReaderAvailable()) {
            mTagDataList.clear()
            mReader.setOnTagReadListener(dataListener)
            mReader.read(TagAdditionData.get("None"), TagReadOption())
        }
    }

    private fun stopRead() {
        if (isReaderAvailable()) {
            mReader.stopRead()
            mReader.removeOnTagReadListener(dataListener)
        }
    }

    private val dataListener =
        OnTagReadListener { t ->
            synchronized(mTagDataList) {
                for (trd in t) {
                    val epc = trd.epcHexStr
                    if (!mTagDataList.contains(epc)) {
                        mTagDataList.add(epc)
                    }
                }
                Log.w("yancheng","mTagDataList------$mTagDataList")
            }
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
