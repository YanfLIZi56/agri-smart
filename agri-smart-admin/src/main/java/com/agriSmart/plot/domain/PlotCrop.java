package com.agriSmart.plot.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 片区与农作物关联对象 plot_crop
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
public class PlotCrop extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    private Long id;

    /** 片区ID（farm_plot.id） */
    @Excel(name = "片区ID", readConverterExp = "f=arm_plot.id")
    private Long plotId;

    /** 农作物ID（crop.id） */
    @Excel(name = "农作物ID", readConverterExp = "c=rop.id")
    private Long cropId;

    /** 农作物名称 */
    private String cropName;

    /** 农作物类型 */
    private String cropType;

    /** 农作物别名 */
    private String cropAlias;

    /** 数量 */
    @Excel(name = "数量")
    private Long nums;

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
    public void setCropId(Long cropId) 
    {
        this.cropId = cropId;
    }

    public Long getCropId() 
    {
        return cropId;
    }
    public void setNums(Long nums) 
    {
        this.nums = nums;
    }

    public Long getNums() 
    {
        return nums;
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public String getCropType() {
        return cropType;
    }

    public void setCropType(String cropType) {
        this.cropType = cropType;
    }

    public String getCropAlias() {
        return cropAlias;
    }

    public void setCropAlias(String cropAlias) {
        this.cropAlias = cropAlias;
    }

    @Override
    public String toString() {
        return "PlotCrop{" +
                "id=" + id +
                ", plotId=" + plotId +
                ", cropId=" + cropId +
                ", cropName='" + cropName + '\'' +
                ", cropType='" + cropType + '\'' +
                ", cropAlias='" + cropAlias + '\'' +
                ", nums=" + nums +
                '}';
    }
}
