package com.agriSmart.plot.domain;

import java.math.BigDecimal;
import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 片区信息对象 farm_plot
 * 
 * @author 羊离子
 * date  2026-04-09
 */
public class FarmPlot extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 片区ID */
    @Excel(name = "片区ID")
    private Long id;

    /** 片区名称 */
    @Excel(name = "片区名称")
    private String name;

    /** 地理位置（经纬度或文字描述） */
    @Excel(name = "地理位置")
    private String location;

    /** 面积（公顷） */
    @Excel(name = "面积(公顷ha/hm^2)")
    private BigDecimal area;

    /** 边界坐标 */
    private List<Coordinate> coordinates;

    /** 管理者ID */
    private Long managerId;

    /** 管理者名称 */
    @Excel(name = "管理者")
    private String managerName;

    /** 片区类型(plot_type.id) */
    private Long plotTypeId;

    @Excel(name = "片区类型")
    private String plotType;

    /** 状态 */
    @Excel(name = "状态")
    private Integer status;

    /** 片区与农作物关联信息 */
    private List<PlotCrop> plotCropList;

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

    public void setLocation(String location) 
    {
        this.location = location;
    }

    public String getLocation() 
    {
        return location;
    }

    public void setArea(BigDecimal area) 
    {
        this.area = area;
    }

    public BigDecimal getArea() 
    {
        return area;
    }

    public void setManagerId(Long managerId) 
    {
        this.managerId = managerId;
    }

    public Long getManagerId() 
    {
        return managerId;
    }

    public void setPlotTypeId(Long plotTypeId) 
    {
        this.plotTypeId = plotTypeId;
    }

    public Long getPlotTypeId() 
    {
        return plotTypeId;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }

    public List<PlotCrop> getPlotCropList()
    {
        return plotCropList;
    }

    public void setPlotCropList(List<PlotCrop> plotCropList)
    {
        this.plotCropList = plotCropList;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getPlotType() {
        return plotType;
    }

    public void setPlotType(String plotType) {
        this.plotType = plotType;
    }

    @Override
    public String toString() {
        return "FarmPlot{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", area=" + area +
                ", managerId=" + managerId +
                ", managerName='" + managerName + '\'' +
                ", plotTypeId=" + plotTypeId +
                ", plotType='" + plotType + '\'' +
                ", status=" + status +
                ", plotCropList=" + plotCropList +
                '}';
    }

    public List<Coordinate> getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(List<Coordinate> coordinates) {
        this.coordinates = coordinates;
    }
}
