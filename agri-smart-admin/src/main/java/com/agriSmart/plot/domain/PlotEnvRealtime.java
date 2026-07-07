package com.agriSmart.plot.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 片区环境实时数据对象 plot_env_realtime
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public class PlotEnvRealtime extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 片区ID（farm_plot.id） */
    @Excel(name = "片区ID", readConverterExp = "f=arm_plot.id")
    private Long plotId;

    /** 采集时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "采集时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date collectTime;

    /** 实际值 */
    @Excel(name = "实际值")
    private BigDecimal envValue;

    /** 阈值类型 */
    private Long alertTypeId;

    @Excel(name = "阈值类型")
    private String alertType;

    @Excel(name = "阈值类型")
    private String unit;

    @Excel(name = "所属片区")
    private String plotName;

    public String getPlotName() {
        return plotName;
    }

    public void setPlotName(String plotName) {
        this.plotName = plotName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

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

    public void setCollectTime(Date collectTime) 
    {
        this.collectTime = collectTime;
    }

    public Date getCollectTime() 
    {
        return collectTime;
    }

    public void setEnvValue(BigDecimal envValue) 
    {
        this.envValue = envValue;
    }

    public BigDecimal getEnvValue() 
    {
        return envValue;
    }

    public void setAlertTypeId(Long alertTypeId) 
    {
        this.alertTypeId = alertTypeId;
    }

    public Long getAlertTypeId() 
    {
        return alertTypeId;
    }

    @Override
    public String toString() {
        return "PlotEnvRealtime{" +
                "id=" + id +
                ", plotId=" + plotId +
                ", collectTime=" + collectTime +
                ", envValue=" + envValue +
                ", alertTypeId=" + alertTypeId +
                ", alertType='" + alertType + '\'' +
                '}';
    }

    public String getAlertType() {
        return alertType;
    }

    public void setAlertType(String alertType) {
        this.alertType = alertType;
    }
}
