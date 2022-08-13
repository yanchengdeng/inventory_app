package com.sgm.rfidapp;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

/**
 * data : 2022/8/13
 * time : 15:02
 * desc : EventChannel 通信
 * @author yanc
 */
public class FlutterEventChannel implements FlutterPlugin, EventChannel.StreamHandler {
    public static final String CHANNEL_NAME = "event_channel_rfid";
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
 
    private static volatile FlutterEventChannel instance;
 
    private FlutterEventChannel() {
    }
 
    public static FlutterEventChannel getInstance() {
        if (instance == null) {
            synchronized (FlutterEventChannel .class) {
                if (instance == null) {
                    instance = new FlutterEventChannel ();
                }
            }
        }
        return instance;
    }
 
    /**
     * 处理设置事件流的请求。
     *
     * @param arguments 流配置参数，可能为空。
     * @param events    用于向flutter接收器发射事件。
     */
    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.eventSink = events;
    }
 
    /**
     * 处理请求以删除最近创建的事件流。
     *
     * @param arguments 流配置参数，可能为空。
     */
    @Override
    public void onCancel(Object arguments) {
 
    }
 
    public void sendEventData(Object data) {
        if (eventSink != null) {
            eventSink.success(data);
        }
    }
 
    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        eventChannel = new EventChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
        eventChannel.setStreamHandler(this);
    }
 
    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        eventSink.endOfStream();
        eventChannel.setStreamHandler(null);
    }
}