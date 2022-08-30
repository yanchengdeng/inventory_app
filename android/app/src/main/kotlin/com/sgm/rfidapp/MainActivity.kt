package com.sgm.rfidapp

import android.Manifest
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.blankj.utilcode.util.GsonUtils
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.PermissionUtils
import com.blankj.utilcode.util.ToastUtils
import com.honeywell.aidc.*
import com.honeywell.aidc.BarcodeReader.BarcodeListener
import com.honeywell.aidc.BarcodeReader.TriggerListener
import com.honeywell.rfidservice.EventListener
import com.honeywell.rfidservice.RfidManager
import com.honeywell.rfidservice.TriggerMode
import com.honeywell.rfidservice.rfid.OnTagReadListener
import com.honeywell.rfidservice.rfid.RfidReader
import com.honeywell.rfidservice.rfid.TagAdditionData
import com.honeywell.rfidservice.rfid.TagReadOption
import com.sgm.rfidapp.data.LABEL
import com.sgm.rfidapp.data.RfidData
import com.sgm.rfidapp.dialog.BlueToothDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class MainActivity : FlutterActivity(),BarcodeListener,
TriggerListener {
    private val CHANNEL = "mould_read_result/blue_teeth"

    ///rfid 开始通过蓝牙获取信息
    private val START_READ_RFID_DATA = "startReadRfid"

    ///rfid 停止通过蓝牙获取信息
    private val STOP_READ_RFID_DATA = "stopReadRfidSdk"

    ///初始化rfid 读取与扫描
    private val INIT_RFID_AND_SCAN = "init_rfid_and_scan"


    ///检查定位权限
    private val  CHECK_LOCATION_PERMISSION = "check_location_permission"

    //释放扫描 和rfid
    private val RELEASE_SCAN_AND_RFID = "release_scan_and_rfid"

    //条形码读取
    private var barcodeReader: BarcodeReader? = null
    private var manager: AidcManager? = null

    ///rfidManager
    private  var rfidMgr: RfidManager? = null

    /// rfid读取类
    var mReader: RfidReader? = null
    private var blueToothDialog: BlueToothDialog? = null

    // 读写信息
    private var mTagDataList = mutableListOf<String>()
    private var mIsReadBtnClicked = false

    private lateinit var eventChannel : FlutterEventChannel

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
         eventChannel = FlutterEventChannel.getInstance()
        flutterEngine?.plugins?.add(eventChannel)
        initBarCodeReader()

    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                START_READ_RFID_DATA -> {
                    if (rfidMgr?.readerAvailable() == true) {
                        mIsReadBtnClicked = true
                        read()
                        result.success(true)
                    } else {
                        ///是否连接定位
                        PermissionUtils.permission(Manifest.permission.ACCESS_FINE_LOCATION)
                            .callback(object : PermissionUtils.FullCallback {
                                override fun onGranted(granted: MutableList<String>) {
                                    initBlueTooth()
                                }

                                override fun onDenied(
                                    deniedForever: MutableList<String>,
                                    denied: MutableList<String>
                                ) {
                                    toast("拒绝无法正常使用")
                                }
                            }).request()
                    }
                }
                STOP_READ_RFID_DATA -> {
                    mIsReadBtnClicked = false
                    stopRead()
                    result.success(true)
                    Log.w("yancheng", "停止读取 RFID--")
                }
                INIT_RFID_AND_SCAN -> {
                    initRfid()
                    try {
                        barcodeReader?.apply {
                            claim()
                        }
                    }catch (e : ScannerUnavailableException){
                        toast("Scanner unavailable")
                    }

                    result.success(true)
                    Log.w("yancheng", "初始化 RFID 和扫描功能--")
                }

                CHECK_LOCATION_PERMISSION ->{
                   var isGranted =  PermissionUtils.isGranted(Manifest.permission.ACCESS_FINE_LOCATION)
                    if (isGranted){
                        result.success(isGranted)
                    }else{
                        PermissionUtils.permission(Manifest.permission.ACCESS_FINE_LOCATION)
                            .callback(object : PermissionUtils.FullCallback {
                                override fun onGranted(granted: MutableList<String>) {
                                    result.success(true)
                                }

                                override fun onDenied(
                                    deniedForever: MutableList<String>,
                                    denied: MutableList<String>
                                ) {
                                    toast("拒绝无法正常使用")
                                }
                            }).request()
                    }
                }

                RELEASE_SCAN_AND_RFID ->{
                    barcodeReader?.apply {
                        release()
                    }
                    stopRead()
                    result.success(true)
                    Log.w("yancheng", "释放扫描功能 rifd--")
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }


    //初始化扫描管理
    private fun initBarCodeReader(){
        AidcManager.create(this) { aidcManager ->
            manager = aidcManager
            try {
                barcodeReader = manager?.createBarcodeReader()
                doListenBarcodeReader()
            } catch (e: InvalidScannerNameException) {
                toast("扫描：Invalid Scanner Name Exception:${e.message}")
                Log.e("yancheng","扫描异常Invalid Scanner Name Exception:${e.message}")
            } catch (e: Exception) {
                toast("扫描${e.message}")
                Log.e("yancheng","扫描异常${e.message}")
            }
        }
    }

    //添加扫描配置及监听事件
    private fun doListenBarcodeReader() {
        barcodeReader?.apply {
           addBarcodeListener(this@MainActivity)
            setProperty(
                BarcodeReader.PROPERTY_TRIGGER_CONTROL_MODE,
                BarcodeReader.TRIGGER_CONTROL_MODE_AUTO_CONTROL
            )
            addTriggerListener(this@MainActivity)


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
            setProperties(properties)
        }
    }


    //初始化 rfid
    private fun initRfid() {
        rfidMgr = RfidManager.getInstance(this)
        rfidMgr?.addEventListener(mEventListener)

    }

    //初始化蓝牙
    private fun initBlueTooth() {

        if (blueToothDialog == null) {
            blueToothDialog = BlueToothDialog(this, rfidMgr!!)
            val window = blueToothDialog?.window
            val height = resources.displayMetrics.heightPixels
            val width = resources.displayMetrics.widthPixels
            window?.setLayout(width - 100, height - 150)
            blueToothDialog?.show()
        } else if (!blueToothDialog?.isShowing!!) {
            blueToothDialog?.show()
        }
    }



    private val mEventListener: EventListener = object : EventListener {
        override fun onDeviceConnected(o: Any) {
            Log.d("yancheng","onDeviceConnecteddevices连接")
        }
        override fun onDeviceDisconnected(o: Any) {
            Log.d("yancheng","onDeviceDisconnecteddevices连接")
        }
        override fun onReaderCreated(b: Boolean, rfidReader: RfidReader) {
            Log.d("yancheng","onReaderCreated"+rfidReader)
        }
        override fun onRfidTriggered(trigger: Boolean) {
            if (mIsReadBtnClicked || !trigger) {
                mIsReadBtnClicked = false
                stopRead()
                Log.w("yancheng","mEventListener--stopRead----")
            } else {
                read()
                Log.w("yancheng","mEventListener--read----")
            }
        }

        override fun onTriggerModeSwitched(triggerMode: TriggerMode) {}
    }


    private fun isReaderAvailable(): Boolean {
        return mReader?.available() == true
    }

    private fun read() {
        if (isReaderAvailable()) {
            //每次读取 需要清除原有数据 ，防止 标签数据也融合进来
            mTagDataList.clear()
            mReader?.setOnTagReadListener(dataListener)
            mReader?.read(TagAdditionData.get("None"), TagReadOption())
        }
    }

    private fun stopRead() {
        if (isReaderAvailable()) {
            mReader?.stopRead()
            mReader?.removeOnTagReadListener(dataListener)
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
                GlobalScope.launch(Dispatchers.Main) {
                    eventChannel.sendEventData(GsonUtils.toJson(RfidData(LABEL.RFID.type, mTagDataList)))
                }.start()
                LogUtils.d("yancheng rfid 读取",mTagDataList)
            }
        }

    override fun onStop() {
        super.onStop()

    }

    override fun onDestroy() {
        super.onDestroy()
        Log.w("yancheng", "onStop----操作关闭RFID 和扫描功能--")
        closeRfidAndScan()
    }


    /**
     * 关闭RFID 和扫描功能
     */
    private fun closeRfidAndScan() {
        barcodeReader?.apply {
            removeBarcodeListener(this@MainActivity)
            removeTriggerListener(this@MainActivity)
            close()
            barcodeReader = null
        }
        manager?.apply {
            close()
        }

        mReader?.stopRead()
        rfidMgr?.disconnect()
        rfidMgr?.removeEventListener(mEventListener)
        blueToothDialog?.dismiss()
        mTagDataList.clear()
        blueToothDialog = null
    }

    //主线程中 弹toast 提示
    @OptIn(DelicateCoroutinesApi::class)
    private fun toast(msg: String) {
        GlobalScope.launch(Dispatchers.Main) {
            ToastUtils.showLong(msg)
        }.start()
    }

    override fun onBarcodeEvent(event: BarcodeReadEvent?) {
        GlobalScope.launch(Dispatchers.Main) {
            mTagDataList.clear()
            event?.barcodeData?.let {
                mTagDataList.add(it)
                eventChannel.sendEventData(
                    GsonUtils.toJson(
                        RfidData(
                            LABEL.SCAN.type,
                            mTagDataList
                        )
                    )
                )
            }
            LogUtils.d("yancheng 条形码扫描：","${event?.barcodeData}")
        }.start()
    }

    override fun onFailureEvent(p0: BarcodeFailureEvent?) {
        toast("扫描失败，重新试试")
    }

    override fun onTriggerEvent(p0: TriggerStateChangeEvent?) {
    }

}
