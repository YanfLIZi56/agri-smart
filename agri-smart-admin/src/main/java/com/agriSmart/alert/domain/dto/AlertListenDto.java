package com.agriSmart.alert.domain.dto;


import com.agriSmart.plot.domain.Coordinate;

import java.util.Map;

public class AlertListenDto {
    private Long devId;
    private String message;
    private Coordinate coordinate;
    private Integer count;
    private Map<String, Integer> classCounts;

    public Long getDevId() {
        return devId;
    }

    public void setDevId(Long devId) {
        this.devId = devId;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public Map<String, Integer> getClassCounts() {
        return classCounts;
    }

    public void setClassCounts(Map<String, Integer> classCounts) {
        this.classCounts = classCounts;
    }

    public Coordinate getCoordinate() {
        return coordinate;
    }

    public void setCoordinate(Coordinate coordinate) {
        this.coordinate = coordinate;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString() {
        return "AlertListenDto{" +
                "devId=" + devId +
                ", message='" + message + '\'' +
                ", coordinate=" + coordinate +
                ", count=" + count +
                ", classCounts=" + classCounts +
                '}';
    }
}
