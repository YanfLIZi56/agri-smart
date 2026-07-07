package com.agriSmart.plot.service.impl;

import java.util.List;

import com.agriSmart.common.core.redis.RedisCache;
import com.agriSmart.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import com.agriSmart.plot.mapper.PlotTypeMapper;
import com.agriSmart.plot.domain.PlotType;
import com.agriSmart.plot.service.IPlotTypeService;

/**
 * 片区类型Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Service
public class PlotTypeServiceImpl implements IPlotTypeService 
{
    @Autowired
    private PlotTypeMapper plotTypeMapper;

    /**
     * 查询片区类型
     * 
     * @param id 片区类型主键
     * @return 片区类型
     */
    @Override
    public PlotType selectPlotTypeById(Long id)
    {
        return plotTypeMapper.selectPlotTypeById(id);
    }

    /**
     * 查询片区类型列表
     * 
     * @param plotType 片区类型
     * @return 片区类型
     */
    @Override
    public List<PlotType> selectPlotTypeList(PlotType plotType)
    {
        return plotTypeMapper.selectPlotTypeList(plotType);
    }

    /**
     * 新增片区类型
     * 
     * @param plotType 片区类型
     * @return 结果
     */
    @Override
    public int insertPlotType(PlotType plotType)
    {
        plotType.setCreateTime(DateUtils.getNowDate());
        return plotTypeMapper.insertPlotType(plotType);
    }

    /**
     * 修改片区类型
     * 
     * @param plotType 片区类型
     * @return 结果
     */
    @Override
    public int updatePlotType(PlotType plotType)
    {
        plotType.setUpdateTime(DateUtils.getNowDate());
        return plotTypeMapper.updatePlotType(plotType);
    }

    /**
     * 批量删除片区类型
     * 
     * @param ids 需要删除的片区类型主键
     * @return 结果
     */
    @Override
    public int deletePlotTypeByIds(Long[] ids)
    {
        return plotTypeMapper.deletePlotTypeByIds(ids);
    }

    /**
     * 删除片区类型信息
     * 
     * @param id 片区类型主键
     * @return 结果
     */
    @Override
    public int deletePlotTypeById(Long id)
    {
        return plotTypeMapper.deletePlotTypeById(id);
    }
}
