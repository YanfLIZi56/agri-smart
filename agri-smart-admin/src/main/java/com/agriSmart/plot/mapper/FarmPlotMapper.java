package com.agriSmart.plot.mapper;

import java.util.List;

import com.agriSmart.alert.domain.AlertThreshold;
import com.agriSmart.plot.domain.Coordinate;
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.domain.PlotCrop;
import com.agriSmart.plot.domain.PlotEnvRealtime;
import com.agriSmart.plot.domain.dto.EnvDto;
import org.apache.ibatis.annotations.Mapper;

/**
 * 片区信息Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Mapper
public interface FarmPlotMapper 
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
    public int updateFarmPlot(FarmPlot farmPlot);

    /**
     * 删除片区信息
     * 
     * @param id 片区信息主键
     * @return 结果
     */
    public int deleteFarmPlotById(Long id);

    /**
     * 批量删除片区信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteFarmPlotByIds(Long[] ids);

    /**
     * 批量删除片区与农作物关联
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deletePlotCropByPlotIds(Long[] ids);
    
    /**
     * 批量新增片区与农作物关联
     * 
     * @param plotCropList 片区与农作物关联列表
     * @return 结果
     */
    public int batchPlotCrop(List<PlotCrop> plotCropList);
    

    /**
     * 通过片区信息主键删除片区与农作物关联信息
     * 
     * @param id 片区信息ID
     * @return 结果
     */
    public int deletePlotCropByPlotId(Long id);

    List<AlertThreshold> selectEnvByPlotId(Long id);

    List<PlotEnvRealtime> selectRealtimeByPlotId(Long id);

    List<FarmPlot> selectFarmPlotByIds(List<PlotEnvRealtime> ids);

    List<FarmPlot> selectFarmPlotByIds2(List<AlertThreshold> ids);

    List<Coordinate> selectCoordByPlotId(Long id);

    void batchCoordinate(List<Coordinate> coordinates);

    void deleteCoordinateByPlotId(Long id);

    void deleteCoordinateByPlotIds(Long[] ids);
}
