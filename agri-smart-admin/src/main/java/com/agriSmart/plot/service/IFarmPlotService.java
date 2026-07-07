package com.agriSmart.plot.service;

import java.util.List;

import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.domain.vo.PlotAndEnvVo;

/**
 * 片区信息Service接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
public interface IFarmPlotService 
{
    /**
     * 查询片区信息
     * 
     * @param id 片区信息主键
     * @return 片区信息
     */
    public FarmPlot selectFarmPlotById(Long id);

    /**
     * 查询片区信息列表
     * 
     * @param farmPlot 片区信息
     * @return 片区信息集合
     */
    public List<FarmPlot> selectFarmPlotList(FarmPlot farmPlot);

    /**
     * 新增片区信息
     * 
     * @param farmPlot 片区信息
     * @return 结果
     */
    public int insertFarmPlot(FarmPlot farmPlot);

    /**
     * 修改片区信息
     * 
     * @param farmPlot 片区信息
     * @return 结果
     */
    public AjaxResult updateFarmPlot(FarmPlot farmPlot);

    /**
     * 批量删除片区信息
     * 
     * @param ids 需要删除的片区信息主键集合
     * @return 结果
     */
    public int deleteFarmPlotByIds(Long[] ids);

    /**
     * 删除片区信息信息
     * 
     * @param id 片区信息主键
     * @return 结果
     */
    public int deleteFarmPlotById(Long id);

    PlotAndEnvVo selectFarmPlotAndEnvById(Long id);
}
