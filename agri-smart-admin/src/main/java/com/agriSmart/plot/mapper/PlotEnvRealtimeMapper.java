package com.agriSmart.plot.mapper;

import java.util.List;
import com.agriSmart.plot.domain.PlotEnvRealtime;

/**
 * 片区环境实时数据Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public interface PlotEnvRealtimeMapper 
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
    public int insertPlotEnvRealtime(PlotEnvRealtime plotEnvRealtime);

    /**
     * 修改片区环境实时数据
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 结果
     */
    public int updatePlotEnvRealtime(PlotEnvRealtime plotEnvRealtime);

    /**
     * 删除片区环境实时数据
     * 
     * @param id 片区环境实时数据主键
     * @return 结果
     */
    public int deletePlotEnvRealtimeById(Long id);

    /**
     * 批量删除片区环境实时数据
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePlotEnvRealtimeByIds(Long[] ids);

    List<PlotEnvRealtime> selectPlotEnvRealtimeByIds(Long[] ids);
}
