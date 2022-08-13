package com.sgm.rfidapp.dialog

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.app.ProgressDialog
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.honeywell.rfidservice.EventListener
import com.honeywell.rfidservice.RfidManager
import com.honeywell.rfidservice.TriggerMode
import com.honeywell.rfidservice.rfid.RfidReader
import com.sgm.rfidapp.BlueAdapter
import com.sgm.rfidapp.MainActivity
import com.sgm.rfidapp.R
import com.sgm.rfidapp.data.BtDeviceInfo


/**
 * @author  : yanc
 * @date : 2022/7/6
 * @time : 23:09
 * @desc :
 */
class BlueToothDialog(context: Activity, rfidMgr: RfidManager) :
    Dialog(context, R.style.TipDialogStyle) {

    private lateinit var recycleView: RecyclerView
    private lateinit var mBtnConnect: Button
    private lateinit var mBtnCreateReader: Button
    private lateinit var mTvInfo: TextView
    private lateinit var macAddress: String
    private var mContext = context
    private lateinit var tvScan: TextView

    private var mRfidMgr = rfidMgr
    private val mHandler = Handler()
    private var mWaitDialog : ProgressDialog? = null

    ///蓝牙adapter
    private lateinit var mBluetoothAdapter: BluetoothAdapter
    private var mDevices = mutableListOf<BtDeviceInfo>()
    private var mAdapter: BlueAdapter = BlueAdapter()

    private val mFindBluetoothReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                BluetoothAdapter.ACTION_DISCOVERY_STARTED -> {
                    //开始扫描
                    tvScan.text = "搜索中..."
//                    mWaitDialog = ProgressDialog.show(mContext,"","搜索蓝牙设备中...")
                }
                BluetoothDevice.ACTION_FOUND -> {
                    val device =
                        intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)

                    val name =
                        intent.getStringExtra(BluetoothDevice.EXTRA_NAME) + ""

                    val rssi =
                        intent.getShortExtra(BluetoothDevice.EXTRA_RSSI, 0)

                    device?.let {
                        mDevices.add(BtDeviceInfo(macAddress = device, rssi = rssi, name = name, isSelected = false))
                        mAdapter.setNewInstance(mDevices)
                    }
                    Log.i(
                        "yancheng---Bluetooth",
                        "onReceive: ===============>${mDevices.toString()}"
                    )
                }

                //扫描结束
                BluetoothAdapter.ACTION_DISCOVERY_FINISHED -> {
                    tvScan.text = "搜索"
                   closeWaitingDialog()
                }
            }
        }
    }

    private fun closeWaitingDialog(){
        mWaitDialog?.dismiss()
        mWaitDialog = null
    }


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    @SuppressLint("MissingPermission")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.dialog_blue_tooth)
        recycleView = findViewById(R.id.recycleView)
        mBtnConnect = findViewById(R.id.btn_connect)
        mBtnCreateReader = findViewById(R.id.btn_create_reader)
        mTvInfo = findViewById(R.id.tv_info)
        tvScan = findViewById(R.id.tvScan)

        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        recycleView.adapter = mAdapter
        val  dividerLine = DividerItemDecoration(context,DividerItemDecoration.VERTICAL)
        context.getDrawable(R.drawable.list_line)?.let { dividerLine.setDrawable(it) }
        recycleView.addItemDecoration(dividerLine)
        recycleView.layoutManager = LinearLayoutManager(context)
        mAdapter.setOnItemClickListener { _, _, position ->
            if (isSearchBlueTooth()) {
                return@setOnItemClickListener
            }
            mAdapter.data.forEach { it.isSelected = false }
            mAdapter.data[position].isSelected = true
            mAdapter.notifyDataSetChanged()
            showBtn()
        }
        //连接
        mBtnConnect.setOnClickListener {
            if (mAdapter.data.isEmpty()){
                Toast.makeText(context, "请点击右上角搜索", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            if (mAdapter.data.find { it.isSelected } == null){
                Toast.makeText(context, "请选择需要连接的底座", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }
            if (isConnected()) {
                disconnect()
            } else {
                connect()
            }
        }

        //创建读写
        mBtnCreateReader.setOnClickListener {

            if (mAdapter.data.isEmpty()){
                Toast.makeText(context, "请点击右上角搜索", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            if (mAdapter.data.find { it.isSelected } == null){
                Toast.makeText(context, "请选择需要连接的底座", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            mWaitDialog = ProgressDialog.show(mContext,"","创建读写器...")
            mHandler.postDelayed({
                mRfidMgr.createReader()
                closeWaitingDialog()
                mBtnCreateReader.setTextColor(Color.rgb(0, 128, 0))
                dismiss()
            }, 1500)
        }

        //扫描
        tvScan.setOnClickListener {
            if (isSearchBlueTooth()) {
                return@setOnClickListener
            }

            if (mBluetoothAdapter.enable()) {
                autoSearchBlueTooth()
            } else {
                Toast.makeText(context, "请打开蓝牙", Toast.LENGTH_SHORT).show()
            }
        }
        initBlueBroadCast()
    }

    // 是否在搜索蓝牙中
    private fun  isSearchBlueTooth() : Boolean{
        return tvScan.text.contains("搜索中")
    }


    private fun initBlueBroadCast() {
        mContext.registerReceiver(
            mFindBluetoothReceiver,
            IntentFilter(BluetoothDevice.ACTION_FOUND)
        )
        mContext.registerReceiver(
            mFindBluetoothReceiver,
            IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED)
        )
        mContext.registerReceiver(
            mFindBluetoothReceiver,
            IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
        )
    }

    private fun connect() {

        val selectedDevice = mAdapter.data.firstOrNull() { it.isSelected }
        selectedDevice?.apply {
            mRfidMgr.addEventListener(mEventListener)
            mRfidMgr.connect(macAddress.address)
        }

    }

    private val mEventListener: EventListener = object : EventListener {
        override fun onDeviceConnected(o: Any) {
            macAddress = o as String
            mContext.runOnUiThread(Runnable {
                showBtn()
            })
        }

        override fun onDeviceDisconnected(o: Any) {
            mContext.runOnUiThread(Runnable {
                showBtn()
            })
        }

        override fun onReaderCreated(b: Boolean, rfidReader: RfidReader) {
            (mContext as MainActivity).mReader = rfidReader
        }

        override fun onRfidTriggered(b: Boolean) {}
        override fun onTriggerModeSwitched(triggerMode: TriggerMode) {}
    }


    //自动搜索蓝牙
    @SuppressLint("MissingPermission", "NotifyDataSetChanged")
    private fun autoSearchBlueTooth() {
        mDevices = mutableListOf()
        mAdapter.notifyDataSetChanged()
        mBluetoothAdapter.cancelDiscovery()
        mBluetoothAdapter.startDiscovery()
        mHandler.postDelayed({ stopScan() }, (5 * 1000).toLong())
    }


    @SuppressLint("MissingPermission")
    private fun stopScan() {
        mBluetoothAdapter.cancelDiscovery()
    }

    private fun disconnect() {
        mRfidMgr.disconnect()
        mRfidMgr.removeEventListener(mEventListener)
    }


    private fun isConnected(): Boolean {
        return mRfidMgr.isConnected
    }

    @SuppressLint("SetTextI18n", "ResourceAsColor")
    private fun showBtn() {
        mTvInfo.setTextColor(Color.rgb(128, 128, 128))
        if (isConnected()) {
            mTvInfo.text = "$macAddress 已连接."
            mTvInfo.setTextColor(Color.rgb(0, 128, 0))
            mBtnConnect.isEnabled = true
            mBtnConnect.text = "断开"
            mBtnCreateReader.isEnabled = true
        } else {
            mTvInfo.text = "未连接设备"
            mBtnConnect.isEnabled = true
            mBtnConnect.text = "连接"
            mBtnCreateReader.isEnabled = false
            mTvInfo.setTextColor(Color.rgb(204, 204, 204))
        }
    }
}