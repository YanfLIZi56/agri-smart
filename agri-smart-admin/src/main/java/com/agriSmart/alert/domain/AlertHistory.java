package com.agriSmart.alert.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 预警历史记录对象 alert_history
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
public class AlertHistory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 片区ID */
    private Long plotId;

    @Excel(name = "所属片区")
    private String plotName;

    /** 预警类型ID */
    private Long alertTypeId;

    @Excel(name = "预警类型")
    private String alertType;

    /** 实际值 */
    @Excel(name = "实际值")
    private BigDecimal triggerValue;

    /** 下限阈值 */
    @Excel(name = "下限阈值")
    private BigDecimal minValue;

    /** 上限阈值 */
    @Excel(name = "上限阈值")
    private BigDecimal maxValue;

    /** 预警状态 */
    @Excel(name = "预警状态")
    private Integer status;

    /** 触发时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "触发时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date triggerTime;

    /** 恢复时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "恢复时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date recoveryTime;

    /** 持续时长(minute) */
    @Excel(name = "持续时长(minute)")
    private Integer durationMinutes;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setPlotId(Long plotId) 
    {
        this.plotId = plotId;
    }

    public Long getPlotId() 
    {
        return plotId;
    }

    public void setAlertTypeId(Long alertTypeId) 
    {
        this.alertTypeId = alertTypeId;
    }

    public Long getAlertTypeId() 
    {
        return alertTypeId;
    }

    public void setTriggerValue(BigDecimal triggerValue) 
    {
        this.triggerValue = triggerValue;
    }

    public BigDecimal getTriggerValue() 
    {
        return triggerValue;
    }

    public void setMinValue(BigDecimal minValue) 
    {
        this.minValue = minValue;
    }

    public BigDecimal getMinValue() 
    {
        return minValue;
    }

    public void setMaxValue(BigDecimal maxValue) 
    {
        this.maxValue = maxValue;
    }

    public BigDecimal getMaxValue() 
    {
        return maxValue;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }

    public void setTriggerTime(Date triggerTime) 
    {
        this.triggerTime = triggerTime;
    }

    public Date getTriggerTime() 
    {
        return triggerTime;
    }

    public void setRecoveryTime(Date recoveryTime) 
    {
        this.recoveryTime = recoveryTime;
    }

    public Date getRecoveryTime() 
    {
        return recoveryTime;
    }

    public void setDurationMinutes(Integer durationMinutes)
    {
        this.durationMinutes = durationMinutes;
    }

    public Integer getDurationMinutes()
    {
        return durationMinutes;
    }

    @Override
    public String toString() {
        return "AlertHistory{" +
                "id=" + id +
                ", plotId=" + plotId +
                ", plotName='" + plotName + '\'' +
                ", alertTypeId=" + alertTypeId +
                ", alertType='" + alertType + '\'' +
                ", triggerValue=" + triggerValue +
                ", minValue=" + minValue +
                ", maxValue=" + maxValue +
                ", status=" + status +
                ", triggerTime=" + triggerTime +
                ", recoveryTime=" + recoveryTime +
                ", durationMinutes=" + durationMinutes +
                '}';
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }

    public String getPlotName() {
        return plotName;
    }

    public void setPlotName(String plotName) {
        this.plotName = plotName;
    }
}
