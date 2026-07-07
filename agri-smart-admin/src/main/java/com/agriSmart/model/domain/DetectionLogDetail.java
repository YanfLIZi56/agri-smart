package com.agriSmart.model.domain;

import java.math.BigDecimal;

import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 检测日志详情对象 detection_log_detail
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
public class DetectionLogDetail extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 详情ID */
    private Long id;

    /** 所属日志ID（detection_log.id） */
    @Excel(name = "所属日志ID", readConverterExp = "d=etection_log.id")
    private Long logId;

    /** 类别名称（模型输出标签） */
    @Excel(name = "类别名称", readConverterExp = "模型输出标签")
    private String label;

    /** 置信度（0-1） */
    @Excel(name = "置信度", readConverterExp = "0-1")
    private BigDecimal conf;

    /** 位置信息（JSON格式：检测任务存[x1,y1,x2,y2]；分割任务存多边形点集数组） */
    @Excel(name = "位置信息", readConverterExp = "J=SON格式：检测任务存[x1,y1,x2,y2]；分割任务存多边形点集数组")
    private String bbox;

    /** 关联crop表ID（corp.id） */
    @Excel(name = "关联crop表ID", readConverterExp = "c=orp.id")
    private Long linkedEncyclopedia;

    private String cropName;

    private String varietyName;

    private Integer cropStatus;


    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setLogId(Long logId) 
    {
        this.logId = logId;
    }

    public Long getLogId() 
    {
        return logId;
    }
    public void setLabel(String label) 
    {
        this.label = label;
    }

    public String getLabel() 
    {
        return label;
    }
    public void setConf(BigDecimal conf)
    {
        this.conf = conf;
    }

    public BigDecimal getConf()
    {
        return conf;
    }
    public void setBbox(String bbox)
    {
        this.bbox = bbox;
    }

    public String getBbox()
    {
        return bbox;
    }
    public void setLinkedEncyclopedia(Long linkedEncyclopedia) 
    {
        this.linkedEncyclopedia = linkedEncyclopedia;
    }

    public Long getLinkedEncyclopedia() 
    {
        return linkedEncyclopedia;
    }

    @Override
    public String toString() {
        return "DetectionLogDetail{" +
                "id=" + id +
                ", logId=" + logId +
                ", label='" + label + '\'' +
                ", conf=" + conf +
                ", bbox='" + bbox + '\'' +
                ", linkedEncyclopedia=" + linkedEncyclopedia +
                ", cropName='" + cropName + '\'' +
                ", varietyName='" + varietyName + '\'' +
                ", status=" + cropStatus +
                '}';
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public String getVarietyName() {
        return varietyName;
    }

    public void setVarietyName(String varietyName) {
        this.varietyName = varietyName;
    }

    public Integer getCropStatus() {
        return cropStatus;
    }

    public void setCropStatus(Integer status) {
        this.cropStatus = status;
    }
}
