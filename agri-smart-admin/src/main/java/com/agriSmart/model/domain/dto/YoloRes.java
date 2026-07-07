package com.agriSmart.model.domain.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;
import java.util.List;

public class YoloRes {

    private String code;
    private String msg;
    private String filename;
    private String result;
    private String origin;
    private Long count;
    private List<Detection> detections;
    private Long time;
    private String density;

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public static class Detection
    {
        @JsonProperty("class")
        private String className;
        private BigDecimal conf;
        private String bbox;

        public String getClassName() {
            return className;
        }

        public void setClassName(String className) {
            this.className = className;
        }

        public BigDecimal getConf() {
            return conf;
        }

        public void setConf(BigDecimal conf) {
            this.conf = conf;
        }

        public String getBbox() {
            return bbox;
        }

        public void setBbox(String bbox) {
            this.bbox = bbox;
        }
    }

    public String getDensity() {
        return density;
    }

    public void setDensity(String density) {
        this.density = density;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }

    public List<Detection> getDetections() {
        return detections;
    }

    public void setDetections(List<Detection> detections) {
        this.detections = detections;
    }

    public Long getTime() {
        return time;
    }

    public void setTime(Long time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "YoloRes{" +
                "code='" + code + '\'' +
                ", msg='" + msg + '\'' +
                ", filename='" + filename + '\'' +
                ", result='" + result + '\'' +
                ", count=" + count +
                ", detections=" + detections +
                ", time=" + time +
                '}';
    }
}
