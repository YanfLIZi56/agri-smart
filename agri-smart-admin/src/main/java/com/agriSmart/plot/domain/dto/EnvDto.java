package com.agriSmart.plot.domain.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

public class EnvDto {

    private Long plotId;

    private String alertType;

    private Long alertTypeId;

    private BigDecimal minValue;

    private BigDecimal maxValue;

    private String unit;

    private BigDecimal envValue;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date collectTime;

    public Long getPlotId() {
        return plotId;
    }

    public void setPlotId(Long plotId) {
        this.plotId = plotId;
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }

    public BigDecimal getMinValue() {
        return minValue;
    }

    public void setMinValue(BigDecimal minValue) {
        this.minValue = minValue;
    }

    public BigDecimal getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(BigDecimal maxValue) {
        this.maxValue = maxValue;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getEnvValue() {
        return envValue;
    }

    public void setEnvValue(BigDecimal envValue) {
        this.envValue = envValue;
    }

    public Date getCollectTime() {
        return collectTime;
    }

    public void setCollectTime(Date collectTime) {
        this.collectTime = collectTime;

    }

    public Long getAlertTypeId() {
        return alertTypeId;
    }

    public void setAlertTypeId(Long alertTypeId) {
        this.alertTypeId = alertTypeId;
    }

    @Override
    public String toString() {
        return "EnvDto{" +
                "plotId=" + plotId +
                ", alertType='" + alertType + '\'' +
                ", alertTypeId=" + alertTypeId +
                ", minValue=" + minValue +
                ", maxValue=" + maxValue +
                ", unit='" + unit + '\'' +
                ", envValue=" + envValue +
                ", collectTime=" + collectTime +
                '}';
    }
}
