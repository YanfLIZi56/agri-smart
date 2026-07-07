package com.agriSmart.model.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 模型配置对象 model_config
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public class ModelConfig extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 模型显示名称 */
    @Excel(name = "模型显示名称")
    private String modelName;

    /** 模型类型 */
    @Excel(name = "模型类型")
    private Integer modelType;

    /** 版本号 */
    @Excel(name = "版本号")
    private String version;

    /** 模型文件路径 */
    @Excel(name = "模型文件路径")
    private String filePath;

    /** 状态 */
    @Excel(name = "状态")
    private Integer isActive;

    private Integer isDelete;

    /** 模型大小 */
    @Excel(name = "模型大小(Mb)")
    private String modelSize;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setModelName(String modelName) 
    {
        this.modelName = modelName;
    }

    public String getModelName() 
    {
        return modelName;
    }

    public void setModelType(Integer modelType) 
    {
        this.modelType = modelType;
    }

    public Integer getModelType() 
    {
        return modelType;
    }

    public void setVersion(String version) 
    {
        this.version = version;
    }

    public String getVersion() 
    {
        return version;
    }

    public void setFilePath(String filePath) 
    {
        this.filePath = filePath;
    }

    public String getFilePath() 
    {
        return filePath;
    }

    public void setIsActive(Integer isActive) 
    {
        this.isActive = isActive;
    }

    public Integer getIsActive() 
    {
        return isActive;
    }

    public String getModelSize() {
        return modelSize;
    }

    public void setModelSize(String modelSize) {
        this.modelSize = modelSize;
    }

    @Override
    public String toString() {
        return "ModelConfig{" +
                "id=" + id +
                ", modelName='" + modelName + '\'' +
                ", modelType=" + modelType +
                ", version='" + version + '\'' +
                ", filePath='" + filePath + '\'' +
                ", isActive=" + isActive +
                ", isDelete=" + isDelete +
                ", modelSize='" + modelSize + '\'' +
                '}';
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
    }
}
