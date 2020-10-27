package com.atguigu.crud.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * 对返回结果进行统一封装
 *
 * @author 风清扬
 * @date 2020/10/24 11:34
 */
public class Msg {
    //状态码:100(成功) 200(失败)
    private int code;
    //提示信息
    private String message;
    //用户要返回给浏览器的数据
    private Map<String, Object> data = new HashMap<>();

    public static Msg success() {
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMessage("处理成功");
        return msg;
    }

    public static Msg fail() {
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setMessage("处理失败");
        return msg;
    }

    public Msg add(String key, Object value) {
        this.getData().put(key, value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }
}
