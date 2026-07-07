package com.agriSmart.plot.service.impl;

import java.math.BigDecimal;
import java.util.List;

import com.agriSmart.alert.domain.AlertThreshold;
import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.common.utils.DateUtils;
import com.agriSmart.plot.domain.Coordinate;
import com.agriSmart.plot.domain.PlotEnvRealtime;
import com.agriSmart.plot.domain.dto.EnvDto;
import com.agriSmart.plot.domain.vo.PlotAndEnvVo;
import com.agriSmart.utils.ParseStr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.agriSmart.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.agriSmart.plot.domain.PlotCrop;
import com.agriSmart.plot.mapper.FarmPlotMapper;
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.service.IFarmPlotService;

/**
 * 片区信息Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Service
public class FarmPlotServiceImpl implements IFarmPlotService
{
    @Autowired
    private FarmPlotMapper farmPlotMapper;

    /**
     * 查询片区信息
     * 
     * @param id 片区信息主键
     * @return 片区信息
     */
    @Override
    public FarmPlot selectFarmPlotById(Long id)
    {
        FarmPlot farmPlot = farmPlotMapper.selectFarmPlotById(id);
        if (farmPlot != null){
            farmPlot.setCoordinates(farmPlotMapper.selectCoordByPlotId(id));
        }
        return farmPlot;
    }

    /**
     * 查询片区信息列表
     * 
     * @param farmPlot 片区信息
     * @return 片区信息
     */
    @Override
    public List<FarmPlot> selectFarmPlotList(FarmPlot farmPlot)
    {
        return farmPlotMapper.selectFarmPlotList(farmPlot);
    }

    /** 判断环境阈值是否合法 */
    private boolean isEnvThreshold(String threshold) {
        BigDecimal[] thresholds = ParseStr.parseThreshold(threshold);
        if (thresholds == null) {
            return true;
        }
        return thresholds[0].compareTo(thresholds[1]) >= 0;
    }

    /**
     * 新增片区信息
     *
     * @param farmPlot 片区信息
     * @return 结果
     */
    @Transactional
    @Override
    public int insertFarmPlot(FarmPlot farmPlot)
    {
        farmPlot.setCreateTime(DateUtils.getNowDate());
        int rows = farmPlotMapper.insertFarmPlot(farmPlot);
        insertPlotCrop(farmPlot);
        insertCoordinates(farmPlot);
        return rows;
    }

    /**
     * 修改片区信息
     * 
     * @param farmPlot 片区信息
     * @return 结果
     */
    @Transactional
    @Override
    public AjaxResult updateFarmPlot(FarmPlot farmPlot)
    {
        farmPlot.setUpdateTime(DateUtils.getNowDate());
        farmPlotMapper.deletePlotCropByPlotId(farmPlot.getId());
        farmPlotMapper.deleteCoordinateByPlotId(farmPlot.getId());
        insertPlotCrop(farmPlot);
        insertCoordinates(farmPlot);
        int i = farmPlotMapper.updateFarmPlot(farmPlot);
        if (i != 1){
            return AjaxResult.error();
        }


        return AjaxResult.success();
    }

    /**
     * 批量删除片区信息
     * 
     * @param ids 需要删除的片区信息主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteFarmPlotByIds(Long[] ids)
    {
        farmPlotMapper.deletePlotCropByPlotIds(ids);
        farmPlotMapper.deleteCoordinateByPlotIds(ids);
        return farmPlotMapper.deleteFarmPlotByIds(ids);
    }

    /**
     * 删除片区信息信息
     * 
     * @param id 片区信息主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteFarmPlotById(Long id)
    {
        farmPlotMapper.deletePlotCropByPlotId(id);
        farmPlotMapper.deleteCoordinateByPlotId(id);
        return farmPlotMapper.deleteFarmPlotById(id);
    }

    /**
     * 查询片区信息详情
     *
     * @param id 片区信息主键
     * @return 片区信息
     */
    @Override
    public PlotAndEnvVo selectFarmPlotAndEnvById(Long id) {
        FarmPlot farmPlot = farmPlotMapper.selectFarmPlotById(id);
        List<AlertThreshold> thresholds = farmPlotMapper.selectEnvByPlotId(id);
        List<PlotEnvRealtime> realtime = farmPlotMapper.selectRealtimeByPlotId(id);
        List<EnvDto> envDtos = ParseStr.parseEnv(thresholds, realtime);

        PlotAndEnvVo plotAndEnvVo = new PlotAndEnvVo();
        plotAndEnvVo.setId(farmPlot.getId());
        plotAndEnvVo.setName(farmPlot.getName());
        plotAndEnvVo.setLocation(farmPlot.getLocation());
        plotAndEnvVo.setArea(farmPlot.getArea());
        plotAndEnvVo.setManagerId(farmPlot.getManagerId());
        plotAndEnvVo.setRemark(farmPlot.getRemark());
        plotAndEnvVo.setPlotTypeId(farmPlot.getPlotTypeId());
        plotAndEnvVo.setStatus(farmPlot.getStatus());
        plotAndEnvVo.setPlotType(farmPlot.getPlotType());
        plotAndEnvVo.setManagerName(farmPlot.getManagerName());
        plotAndEnvVo.setPlotCropList(farmPlot.getPlotCropList());
        plotAndEnvVo.setEnvDtos(envDtos);
        farmPlot.setCoordinates(farmPlotMapper.selectCoordByPlotId(id));

        return plotAndEnvVo;
    }

    public void insertCoordinates(FarmPlot farmPlot){
        List<Coordinate> coordinates = farmPlot.getCoordinates();
        Long id = farmPlot.getId();
        if (StringUtils.isNotNull(coordinates)){
            for (Coordinate coordinate : coordinates) {
                coordinate.setPlotId(id);
            }
            if (!coordinates.isEmpty()){
                farmPlotMapper.batchCoordinate(coordinates);

            }
        }
    }

    /**
     * 新增片区与农作物关联信息
     * 
     * @param farmPlot 片区信息对象
     */
    public void insertPlotCrop(FarmPlot farmPlot)
    {
        List<PlotCrop> plotCropList = farmPlot.getPlotCropList();
        Long id = farmPlot.getId();
        if (StringUtils.isNotNull(plotCropList))
        {
            List<PlotCrop> list = new ArrayList<PlotCrop>();
            for (PlotCrop plotCrop : plotCropList)
            {
                plotCrop.setPlotId(id);
                list.add(plotCrop);
            }
            if (!list.isEmpty())
            {
                farmPlotMapper.batchPlotCrop(list);
            }
        }
    }
}
