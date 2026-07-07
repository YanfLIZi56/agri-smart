package com.agriSmart.plot.service;

import java.util.List;

import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.plot.domain.PlotEnvRealtime;

/**
 * 片区环境实时数据Service接口
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public interface IPlotEnvRealtimeService 
{
    /**
     * 查询片区环境实时数据
     * 
     * @param id 片区环境实时数据主键
     * @return 片区环境实时数据
     */
    public PlotEnvRealtime selectPlotEnvRealtimeById(Long id);

    /**
     * 查询片区环境实时数据列表
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 片区环境实时数据集合
     */
    public List<PlotEnvRealtime> selectPlotEnvRealtimeList(PlotEnvRealtime plotEnvRealtime);

    /**
     * 新增片区环境实时数据
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 结果
     */
    public AjaxResult insertPlotEnvRealtime(PlotEnvRealtime plotEnvRealtime);

    /**
     * 修改片区环境实时数据
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 结果
     */
    public AjaxResult updatePlotEnvRealtime(PlotEnvRealtime plotEnvRealtime);

    /**
     * 批量删除片区环境实时数据
     * 
     * @param ids 需要删除的片区环境实时数据主键集合
     * @return 结果
     */
    public int deletePlotEnvRealtimeByIds(Long[] ids);

    /**
     * 删除片区环境实时数据信息
     * 
     * @param id 片区环境实时数据主键
     * @return 结果
     */
    public int deletePlotEnvRealtimeById(Long id);

}
