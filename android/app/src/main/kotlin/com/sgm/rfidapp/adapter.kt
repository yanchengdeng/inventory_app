package com.sgm.rfidapp

import android.annotation.SuppressLint
import android.os.Build
import androidx.annotation.RequiresApi
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.sgm.rfidapp.data.BtDeviceInfo

/**
 *@Describe ：纪要说明
 *@Author : yanc
 *@Date : 2022/7/8
 *@Time : 10:39
 **/

class BlueAdapter : BaseQuickAdapter<BtDeviceInfo, BaseViewHolder>(layoutResId = R.layout.list_item_bt_device) {


    /**
     * Implement this method and use the helper to adapt the view to the given item.
     *
     * 实现此方法，并使用 helper 完成 item 视图的操作
     *
     * @param holder A fully initialized helper.
     * @param item   The item that needs to be displayed.
     */
    @RequiresApi(Build.VERSION_CODES.M)
    @SuppressLint("ResourceType")
    override fun convert(holder: BaseViewHolder, item: BtDeviceInfo) {

        holder.setText(R.id.tvName,item.name ?: "未知名称")
        holder.setText(R.id.tvAddr,item.macAddress.address)
        holder.setText(R.id.tvRssi,item.rssi.toString())

        if (item.isSelected){
            holder.setBackgroundColor(R.id.rlBg,context.getColor(R.color.gray_cccccc))
        }else{
            holder.setBackgroundColor(R.id.rlBg,context.getColor(R.color.white))
        }
    }
}