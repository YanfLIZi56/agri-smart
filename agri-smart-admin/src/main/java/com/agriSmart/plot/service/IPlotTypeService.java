package com.agriSmart.plot.service;

import java.util.List;
import com.agriSmart.plot.domain.PlotType;

/**
 * 片区类型Service接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
public interface IPlotTypeService 
{
    /**
     * 查询片区类型
     * 
     * @param id 片区类型主键
     * @return 片区类型
     */
    public PlotType selectPlotTypeById(Long id);

    /**
     * 查询片区类型列表
     * 
     * @param plotType 片区类型
     * @return 片区类型集合
     */
    public List<PlotType> selectPlotTypeList(PlotType plotType);

    /**
     * 新增片区类型
     * 
     * @param plotType 片区类型
     * @return 结果
     */
    public int insertPlotType(PlotType plotType);

    /**
     * 修改片区类型
     * 
     * @param plotType 片区类型
     * @return 结果
     */
    public int updatePlotType(PlotType plotType);

    /**
     * 批量删除片区类型
     * 
     * @param ids 需要删除的片区类型主键集合
     * @return 结果
     */
    public int deletePlotTypeByIds(Long[] ids);

    /**
     * 删除片区类型信息
     * 
     * @param id 片区类型主键
     * @return 结果
     */
    public int deletePlotTypeById(Long id);
}
