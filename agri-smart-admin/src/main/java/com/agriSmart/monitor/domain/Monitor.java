package com.agriSmart.monitor.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 监控管理对象 monitor
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
public class Monitor extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 监控名称 */
    @Excel(name = "监控名称")
    private String name;

    /** rtsp流地址 */
    @Excel(name = "rtsp流地址")
    private String rtspUrl;

    /** 型号 */
    @Excel(name = "型号")
    private String monitorType;

    /** 状态 */
    @Excel(name = "状态")
    private Long status;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }

    public void setRtspUrl(String rtspUrl) 
    {
        this.rtspUrl = rtspUrl;
    }

    public String getRtspUrl() 
    {
        return rtspUrl;
    }

    public void setMonitorType(String monitorType) 
    {
        this.monitorType = monitorType;
    }

    public String getMonitorType() 
    {
        return monitorType;
    }

    public void setStatus(Long status) 
    {
        this.status = status;
    }

    public Long getStatus() 
    {
        return status;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("rtspUrl", getRtspUrl())
            .append("monitorType", getMonitorType())
            .append("status", getStatus())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
