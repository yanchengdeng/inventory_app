package com.luojie.erapp.inventory_app

import android.Manifest
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.github.dfqin.grantor.PermissionListener
import com.github.dfqin.grantor.PermissionsUtil
import com.honeywell.aidc.*
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

    ///初始化rfid_sdk
    private val INIT_RFID_SDK = "initRfidSdk"

    ///rfid 开始通过蓝牙获取信息
    private val START_READ_RFID_DATA = "startReadRfid"

    ///rfid 停止通过蓝牙获取信息
    private val STOP_READ_RFID_DATA = "stopReadRfidSdk"

    ///读取经纬度
    private val GET_GPS_LAT_LNG = "getGpsLatLng"


    ///扫描标签
    private val SCAN_LABEL = "scan_label"

    private var barcodeReader: BarcodeReader? = null
    private var manager: AidcManager? = null

    ///rfidManager
    private  var rfidMgr: RfidManager? = null

    /// rfid读取类
    lateinit var mReader: RfidReader
    private  var blueToothDialog: BlueToothDialog? = null
    // 读写信息
    private var mTagDataList = mutableListOf<String>()
    private var mIsReadBtnClicked = false

    private var readLabelResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.w("yancheng","onCreate------")
        initBarCodeReader()
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.w("yancheng","configureFlutterEngine------")
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                INIT_RFID_SDK -> {

                }
                START_READ_RFID_DATA -> {
                    rfidMgr?.addEventListener(mEventListener)
                    mIsReadBtnClicked = true
                    read()
                    this.readLabelResult = result



                    rfidMgr?.apply {
                        /// 判断蓝牙是否连接
                        if (isConnected){
                            /// 判断是否读取rfid
                            if (isReaderAvailable()) {
                                result.success()
                            }else{

                            }
                        }else{
                            ///是否连接定位
                            PermissionsUtil.requestPermission(this@MainActivity,object :PermissionListener{
                                /**
                                 * 通过授权
                                 * @param permission
                                 */
                                override fun permissionGranted(permission: Array<out String>) {
                                    initBlueTooth()
                                }

                                /**
                                 * 拒绝授权
                                 * @param permission
                                 */
                                override fun permissionDenied(permission: Array<out String>) {
                                    Toast.makeText(this@MainActivity,"拒绝无法正常使用",Toast.LENGTH_LONG).show();
                                }

                            }, Manifest.permission.ACCESS_FINE_LOCATION)
                        }

                    }
                }
                STOP_READ_RFID_DATA -> {
                    rfidMgr?.removeEventListener(mEventListener)
                    mIsReadBtnClicked = false
                    stopRead()
                }

                GET_GPS_LAT_LNG ->{

                    PermissionsUtil.requestPermission(this,object :PermissionListener{
                        /**
                         * 通过授权
                         * @param permission
                         */
                        override fun permissionGranted(permission: Array<out String>) {
                            LocationUtils.getInstance(this@MainActivity).addressCallback =
                                LocationUtils.AddressCallback { lat, lng ->
                                    Log.d(
                                        "定位地址","${lat},${lng}")
                                    result.success("${lat},${lng}")
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

                SCAN_LABEL ->{
//                    doListenBarcodeReader(result)

                    startActivity(Intent(context,ReadResultActivity::class.java))

                }
            }
        }
    }


    private fun initBarCodeReader(){
        AidcManager.create(this) { aidcManager ->
            manager = aidcManager
            try {
                barcodeReader = manager?.createBarcodeReader()
            } catch (e: InvalidScannerNameException) {
                Toast.makeText(
                    this@MainActivity,
                    "Invalid Scanner Name Exception: " + e.message,
                    Toast.LENGTH_SHORT
                ).show()
            } catch (e: Exception) {
                Toast.makeText(
                    this@MainActivity,
                    "Exception: " + e.message,
                    Toast.LENGTH_SHORT
                ).show()
            }
        }


    }

    private fun doListenBarcodeReader(result: MethodChannel.Result) {
        if (barcodeReader != null) {
            barcodeReader?.claim()
            // register bar code event listener
            barcodeReader!!.addBarcodeListener(object :BarcodeReader.BarcodeListener{
                override fun onBarcodeEvent(event: BarcodeReadEvent) {
                        result.success(event.barcodeData)

                }

                override fun onFailureEvent(p0: BarcodeFailureEvent) {
                    Toast.makeText(this@MainActivity, "扫描失败，重新试试", Toast.LENGTH_SHORT)
                        .show()
                }

            })

            // set the trigger mode to client control
            try {
                barcodeReader!!.setProperty(
                    BarcodeReader.PROPERTY_TRIGGER_CONTROL_MODE,
                    BarcodeReader.TRIGGER_CONTROL_MODE_AUTO_CONTROL
                )
            } catch (e: UnsupportedPropertyException) {
                Toast.makeText(this, "Failed to apply properties", Toast.LENGTH_SHORT)
                    .show()
            }
            // register trigger state change listener
            barcodeReader!!.addTriggerListener {
                Log.d("yancheng","${it.state}")

            }
            val properties: MutableMap<String, Any> = HashMap()
            // Set Symbologies On/Off
            properties[BarcodeReader.PROPERTY_CODE_128_ENABLED] = true
            properties[BarcodeReader.PROPERTY_GS1_128_ENABLED] = true
            properties[BarcodeReader.PROPERTY_QR_CODE_ENABLED] = true
            properties[BarcodeReader.PROPERTY_CODE_39_ENABLED] = true
            properties[BarcodeReader.PROPERTY_DATAMATRIX_ENABLED] = true
            properties[BarcodeReader.PROPERTY_UPC_A_ENABLE] = true
            properties[BarcodeReader.PROPERTY_EAN_13_ENABLED] = false
            properties[BarcodeReader.PROPERTY_AZTEC_ENABLED] = false
            properties[BarcodeReader.PROPERTY_CODABAR_ENABLED] = false
            properties[BarcodeReader.PROPERTY_INTERLEAVED_25_ENABLED] = false
            properties[BarcodeReader.PROPERTY_PDF_417_ENABLED] = false
            // Set Max Code 39 barcode length
            properties[BarcodeReader.PROPERTY_CODE_39_MAXIMUM_LENGTH] = 10
            // Turn on center decoding
            properties[BarcodeReader.PROPERTY_CENTER_DECODE] = true
            // Enable bad read response
            properties[BarcodeReader.PROPERTY_NOTIFICATION_BAD_READ_ENABLED] = true
            // Sets time period for decoder timeout in any mode
            properties[BarcodeReader.PROPERTY_DECODER_TIMEOUT] = 400
            // Apply the settings
            barcodeReader!!.setProperties(properties)
        }else{
            initBarCodeReader()
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
                readLabelResult?.success(mTagDataList);
            }
        }

    override fun onResume() {
        super.onResume()
        Log.w("yancheng","onResume------")
        if (barcodeReader != null) {
            try {
                barcodeReader!!.claim()
            } catch (e: ScannerUnavailableException) {
                e.printStackTrace()
                Toast.makeText(this, "Scanner unavailable", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onPause() {
        super.onPause()
        Log.w("yancheng","onPause------")
        if (barcodeReader != null) {
            // release the scanner claim so we don't get any scanner
            // notifications while paused.
            barcodeReader!!.release()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        // create the AidcManager providing a Context and a
        // CreatedCallback implementation.
        Log.w("yancheng","onCreate------")
        // create the AidcManager providing a Context and a
        // CreatedCallback implementation.

    }

    override fun onStop() {
        super.onStop()
        Log.w("yancheng","onStop------")

        if (barcodeReader != null) {
            // close BarcodeReader to clean up resources.
            barcodeReader!!.close()
            barcodeReader = null
        }

        if (manager != null) {
            // close AidcManager to disconnect from the scanner service.
            // once closed, the object can no longer be used.
            manager!!.close()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.w("yancheng","onDestroy------")
    }




}
