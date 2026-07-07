package com.agriSmart.alert.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 预警阈值配置对象 alert_threshold
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public class AlertThreshold extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 片区 */
    private Long plotId;

    @Excel(name = "片区")
    private String plotName;

    /** 预警类型ID */

    private Long alertTypeId;

    @Excel(name = "预警类型")
    private String alertType;

    /** 下限阈值（低于此值触发预警，可为空） */
    @Excel(name = "下限阈值", readConverterExp = "低=于此值触发预警，可为空")
    private BigDecimal minValue;

    /** 上限阈值（高于此值触发预警，可为空） */
    @Excel(name = "上限阈值", readConverterExp = "高=于此值触发预警，可为空")
    private BigDecimal maxValue;

    @Excel(name = "单位")
    private String unit;

    /** 是否启用：0-停用，1-启用 */
    @Excel(name = "是否启用：0-停用，1-启用")
    private Integer enabled;

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

    public void setEnabled(Integer enabled) 
    {
        this.enabled = enabled;
    }

    public Integer getEnabled() 
    {
        return enabled;
    }

    @Override
    public String toString() {
        return "AlertThreshold{" +
                "id=" + id +
                ", plotId=" + plotId +
                ", plotName='" + plotName + '\'' +
                ", alertTypeId=" + alertTypeId +
                ", alertType='" + alertType + '\'' +
                ", minValue=" + minValue +
                ", maxValue=" + maxValue +
                ", unit='" + unit + '\'' +
                ", enabled=" + enabled +
                '}';
    }

    public String getPlotName() {
        return plotName;
    }

    public void setPlotName(String plotName) {
        this.plotName = plotName;
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

}
