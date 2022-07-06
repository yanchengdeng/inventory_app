package com.luojie.erapp.inventory_app.dialog

import android.annotation.SuppressLint
import android.app.ProgressDialog
import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
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
class BlueToothDialog(rfidMgr: RfidManager) : DialogFragment() {

    private lateinit var  mLv: ListView
    private lateinit var mBtnConnect :Button
    private lateinit var mBtnCreateReader : Button
    private lateinit var mTvInfo : TextView
    private lateinit var macAddress : String

    private var mRfidMgr = rfidMgr
    private var mWaitDialog: ProgressDialog? = null
    private val mHandler = Handler()

    ///蓝牙adapter
    lateinit var mBluetoothAdapter: BluetoothAdapter
    private var mDevices  = mutableListOf<BtDeviceInfo>()
    private var mSelectedIdx = -1
    private var mAdapter: MyAdapter? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.dialog_blue_tooth,container)
        mLv =  view.findViewById(R.id.lv)
        mBtnConnect = view.findViewById(R.id.btn_connect)
        mBtnCreateReader = view.findViewById(R.id.btn_create_reader)
        mTvInfo = view.findViewById(R.id.tv_info)


        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        mAdapter =
            context?.let { MyAdapter(it, mDevices) }
        mLv.adapter = mAdapter
        mLv.setOnItemClickListener(mItemClickListener)
        autoSearchBlueTooth()


        //连接
        mBtnConnect.setOnClickListener {
            if (isConnected()){
                disconnect()
            }else{
                connect()
            }
        }

        return view
    }

    private fun connect() {
        if (mSelectedIdx == -1 || mSelectedIdx >= mDevices.size) {
            return
        }
        mRfidMgr.addEventListener(mEventListener)
        mRfidMgr.connect(mDevices[mSelectedIdx].dev.address)
        mWaitDialog = ProgressDialog.show(activity, null, "连接中...")
    }

    private val mEventListener: EventListener = object : EventListener {
        override fun onDeviceConnected(o: Any) {
            macAddress = o as String
            activity?.runOnUiThread(Runnable {
                showBtn()
                closeWaitDialog()
            })
        }

        override fun onDeviceDisconnected(o: Any) {
            activity?.runOnUiThread(Runnable {
                showBtn()
                closeWaitDialog()
            })
        }

        override fun onReaderCreated(b: Boolean, rfidReader: RfidReader) {
            (activity as MainActivity).mRfidReader = rfidReader

        }

        override fun onRfidTriggered(b: Boolean) {}
        override fun onTriggerModeSwitched(triggerMode: TriggerMode) {}
    }

    //自动搜索蓝牙
    @SuppressLint("MissingPermission")
    private fun autoSearchBlueTooth() {


        mDevices = mutableListOf()
        mSelectedIdx = -1
        mAdapter!!.notifyDataSetChanged()
        mBluetoothAdapter.startLeScan(mLeScanCallback)

        mWaitDialog = ProgressDialog.show(activity, null, "搜索周围蓝牙设备中...")
        mWaitDialog?.setCancelable(false)

        mHandler.postDelayed({ stopScan() }, (5 * 1000).toLong())
    }


    @SuppressLint("MissingPermission")
    private fun stopScan() {
        mBluetoothAdapter.stopLeScan(mLeScanCallback)
        closeWaitDialog()
    }

    private fun disconnect() {
        mRfidMgr.disconnect()
    }

    private fun closeWaitDialog() {
        if (mWaitDialog != null) {
            mWaitDialog?.dismiss()
            mWaitDialog = null
        }
    }

    private var mPrevListUpdateTime: Long = 0
    @SuppressLint("MissingPermission")
    private val mLeScanCallback =
        BluetoothAdapter.LeScanCallback { device, rssi, scanRecord ->
            if (device.name != null && !device.name.isEmpty()) {
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
                        activity?.runOnUiThread(Runnable { mAdapter!!.notifyDataSetChanged() })
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
        AdapterView.OnItemClickListener { adapterView, view, i, l ->
            mSelectedIdx = i
            mAdapter?.notifyDataSetChanged()
            showBtn()
        }


    @SuppressLint("SetTextI18n")
    private fun showBtn() {
        mTvInfo.setTextColor(Color.rgb(128, 128, 128))
        if (isConnected()) {
            mTvInfo.text = "${macAddress} 已连接."
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