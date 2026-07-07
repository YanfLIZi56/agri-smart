package com.agriSmart.crop.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 农作物信息对象 crop
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
public class Crop extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    @Excel(name = "主键")
    private Long id;

    /** 农作物名称 */
    @Excel(name = "农作物名称")
    private String name;

    /** 别名 */
    @Excel(name = "别名")
    private String alias;

    /** 症状描述 */
    private String symptoms;

    /** 病因描述 */
    private String causes;

    /** 防治方法 */
    private String prevention;

    /** 品种 variety.id */
    private Long varietyId;

    @Excel(name = "品种")
    private String varietyName;

    /** 状态 */
    @Excel(name = "状态")
    private Integer status;

    /** 图片路径（多张用逗号分隔） */
    private String images;

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

    public void setAlias(String alias) 
    {
        this.alias = alias;
    }

    public String getAlias() 
    {
        return alias;
    }

    public void setSymptoms(String symptoms) 
    {
        this.symptoms = symptoms;
    }

    public String getSymptoms() 
    {
        return symptoms;
    }

    public void setCauses(String causes) 
    {
        this.causes = causes;
    }

    public String getCauses() 
    {
        return causes;
    }

    public void setPrevention(String prevention) 
    {
        this.prevention = prevention;
    }

    public String getPrevention() 
    {
        return prevention;
    }

    public void setVarietyId(Long varietyId) 
    {
        this.varietyId = varietyId;
    }

    public Long getVarietyId() 
    {
        return varietyId;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }

    public void setImages(String images) 
    {
        this.images = images;
    }

    public String getImages() 
    {
        return images;
    }

    public String getVarietyName() {
        return varietyName;
    }

    public void setVarietyName(String varietyName) {
        this.varietyName = varietyName;
    }

    @Override
    public String toString() {
        return "Crop{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", alias='" + alias + '\'' +
                ", symptoms='" + symptoms + '\'' +
                ", causes='" + causes + '\'' +
                ", prevention='" + prevention + '\'' +
                ", varietyId=" + varietyId +
                ", varietyName='" + varietyName + '\'' +
                ", status=" + status +
                ", images='" + images + '\'' +
                '}';
    }
}
