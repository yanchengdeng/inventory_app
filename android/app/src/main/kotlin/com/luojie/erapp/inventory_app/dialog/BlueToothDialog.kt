package com.luojie.erapp.inventory_app.dialog

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.app.Dialog
import android.app.ProgressDialog
import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.core.app.ActivityCompat
import com.honeywell.rfidservice.EventListener
import com.honeywell.rfidservice.RfidManager
import com.honeywell.rfidservice.TriggerMode
import com.honeywell.rfidservice.rfid.RfidReader
import com.luojie.erapp.inventory_app.MainActivity
import com.luojie.erapp.inventory_app.R
import com.luojie.erapp.inventory_app.data.BtDeviceInfo

/**
 * @author  : yanc
 * @date : 2022/7/6
 * @time : 23:09
 * @desc :
 */
class BlueToothDialog(context: Activity,rfidMgr: RfidManager) : Dialog(context,R.style.TipDialogStyle) {

    private lateinit var  mLv: ListView
    private lateinit var mBtnConnect :Button
    private lateinit var mBtnCreateReader : Button
    private lateinit var mTvInfo : TextView
    private lateinit var macAddress : String
    private var mContext  = context
    private lateinit var tvScan : TextView

    private var mRfidMgr = rfidMgr
    private val mHandler = Handler()

    ///蓝牙adapter
    private lateinit var mBluetoothAdapter: BluetoothAdapter
    private var mDevices  = mutableListOf<BtDeviceInfo>()
    private var mSelectedIdx = -1
    private var mAdapter: MyAdapter? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.dialog_blue_tooth)
        mLv =  findViewById(R.id.lv)
        mBtnConnect = findViewById(R.id.btn_connect)
        mBtnCreateReader = findViewById(R.id.btn_create_reader)
        mTvInfo = findViewById(R.id.tv_info)
        tvScan = findViewById(R.id.tvScan)

        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        mAdapter = MyAdapter(context, mDevices)
        mLv.adapter = mAdapter
        mLv.onItemClickListener = mItemClickListener

        //连接
        mBtnConnect.setOnClickListener {
            if (isConnected()){
                disconnect()
            }else{
                connect()
            }
        }

        tvScan.setOnClickListener{
            if (tvScan.text.contains("搜索中")){
                return@setOnClickListener
            }
            autoSearchBlueTooth()
        }
    }

    private fun connect() {
        if (mSelectedIdx == -1 || mSelectedIdx >= mDevices.size) {
            return
        }
        mRfidMgr.addEventListener(mEventListener)
        mRfidMgr.connect(mDevices[mSelectedIdx].dev.address)
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
            (mContext as MainActivity).mRfidReader = rfidReader

        }

        override fun onRfidTriggered(b: Boolean) {}
        override fun onTriggerModeSwitched(triggerMode: TriggerMode) {}
    }

    override fun show() {
        super.show()
    }

    //自动搜索蓝牙
    private fun autoSearchBlueTooth() {
        mDevices = mutableListOf()
        mSelectedIdx = -1
        mAdapter!!.notifyDataSetChanged()

        mBluetoothAdapter.startLeScan(mLeScanCallback)
        tvScan.text = "搜索中..."
        mHandler.postDelayed({ stopScan() }, (5 * 1000).toLong())
    }


    private fun stopScan() {
        mBluetoothAdapter.stopLeScan(mLeScanCallback)
        tvScan.text="搜索"
    }

    private fun disconnect() {
        mRfidMgr.disconnect()
    }


    private var mPrevListUpdateTime: Long = 0
    @SuppressLint("MissingPermission")
    private val mLeScanCallback =
        BluetoothAdapter.LeScanCallback { device, rssi, _ ->
            if (device.name != null && device.name.isNotEmpty()) {
                synchronized(mDevices) {
                    var newDevice = true
                    for (info in mDevices) {
                        if (device.address == info.dev.address) {
                            newDevice = false
                            info.rssi = rssi
                        }
                    }
                    if (newDevice) {
                        mDevices.add(BtDeviceInfo(device, rssi))
                    }
                    val cur = System.currentTimeMillis()
                    if (newDevice || cur - mPrevListUpdateTime > 500) {
                        mPrevListUpdateTime = cur
                        mContext.runOnUiThread(Runnable { mAdapter!!.notifyDataSetChanged() })
                    }
                }
            }
        }


    private fun isConnected(): Boolean {
        return mRfidMgr.isConnected
    }
    inner class MyAdapter(private val ctx: Context, ls: List<BtDeviceInfo>?) :
        ArrayAdapter<BtDeviceInfo?>(ctx, 0, ls!!) {
        @SuppressLint("MissingPermission")
        override fun getView(position: Int, v: View?, parent: ViewGroup): View {
            var v = v
            val vh: ViewHolder
            if (v == null) {
                val inflater = LayoutInflater.from(ctx)
                v = inflater.inflate(R.layout.list_item_bt_device, null)
                vh = ViewHolder()
                vh.tvName = v!!.findViewById<TextView>(R.id.tvName)
                vh.tvAddr = v.findViewById<TextView>(R.id.tvAddr)
                vh.tvRssi = v.findViewById<TextView>(R.id.tvRssi)
                v.setTag(vh)
            } else {
                vh = v.tag as ViewHolder
            }
            val item: BtDeviceInfo = mDevices.get(position)
            vh.tvName!!.text = item.dev.name
            vh.tvAddr!!.text = item.dev.address
            vh.tvRssi!!.text = item.rssi.toString()
            if (position == mSelectedIdx) {
                v.setBackgroundColor(Color.rgb(220, 220, 220))
            } else {
                v.setBackgroundColor(Color.argb(0, 0, 0, 0))
            }
            return v
        }

         inner class ViewHolder {
            var tvName: TextView? = null
            var tvAddr: TextView? = null
            var tvRssi: TextView? = null
        }
    }

    private val mItemClickListener =
        AdapterView.OnItemClickListener { _, _, i, _ ->
            mSelectedIdx = i
            mAdapter?.notifyDataSetChanged()
            showBtn()
        }


    @SuppressLint("SetTextI18n")
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
            mBtnConnect.isEnabled = mSelectedIdx != -1
            mBtnConnect.text = "连接"
            mBtnCreateReader.isEnabled = false
        }
    }
}