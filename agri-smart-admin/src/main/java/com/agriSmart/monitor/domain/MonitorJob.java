package com.agriSmart.monitor.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 监控任务对象 monitor_job
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
public class MonitorJob extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 监控ID */
    private Long monitorId;

    @Excel(name = "监控名")
    private String monitorName;

    @Excel(name = "监控类型")
    private String monitorType;

    /** 模型ID */
    private Long modelConfigId;

    private Boolean modelConfigIsDel;

    private Boolean modelConfigIsActive;

    @Excel(name = "使用的模型")
    private String modelName;

    @Excel(name = "模型版本")
    private String modelVersion;

    /** 持续时间(秒) */
    @Excel(name = "持续时间(秒)")
    private Long duration;

    /** 状态 */
    @Excel(name = "状态")
    private Long status;

    /** 结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setMonitorId(Long monitorId) 
    {
        this.monitorId = monitorId;
    }

    public Long getMonitorId() 
    {
        return monitorId;
    }

    public void setModelConfigId(Long modelConfigId) 
    {
        this.modelConfigId = modelConfigId;
    }

    public Long getModelConfigId() 
    {
        return modelConfigId;
    }

    public void setDuration(Long duration) 
    {
        this.duration = duration;
    }

    public Long getDuration() 
    {
        return duration;
    }

    public void setStatus(Long status) 
    {
        this.status = status;
    }

    public Long getStatus() 
    {
        return status;
    }

    public void setEndTime(Date endTime) 
    {
        this.endTime = endTime;
    }

    public Date getEndTime() 
    {
        return endTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("monitorId", getMonitorId())
            .append("modelConfigId", getModelConfigId())
            .append("duration", getDuration())
            .append("status", getStatus())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("endTime", getEndTime())
            .append("remark", getRemark())
            .toString();
    }

    public Boolean getModelConfigIsDel() {
        return modelConfigIsDel;
    }

    public void setModelConfigIsDel(Boolean modelConfigIsDel) {
        this.modelConfigIsDel = modelConfigIsDel;
    }

    public Boolean getModelConfigIsActive() {
        return modelConfigIsActive;
    }

    public void setModelConfigIsActive(Boolean modelConfigIsActive) {
        this.modelConfigIsActive = modelConfigIsActive;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getModelVersion() {
        return modelVersion;
    }

    public void setModelVersion(String modelVersion) {
        this.modelVersion = modelVersion;
    }

    public String getMonitorName() {
        return monitorName;
    }

    public void setMonitorName(String monitorName) {
        this.monitorName = monitorName;
    }

    public String getMonitorType() {
        return monitorType;
    }

    public void setMonitorType(String monitorType) {
        this.monitorType = monitorType;
    }
}
