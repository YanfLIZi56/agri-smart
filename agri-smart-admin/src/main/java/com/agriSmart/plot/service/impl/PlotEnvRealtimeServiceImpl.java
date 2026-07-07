package com.agriSmart.plot.service.impl;

import java.math.BigDecimal;
import java.util.*;

import com.agriSmart.alert.domain.AlertHistory;
import com.agriSmart.alert.domain.AlertThreshold;
import com.agriSmart.alert.mapper.AlertHistoryMapper;
import com.agriSmart.alert.mapper.AlertThresholdMapper;
import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.common.utils.DateUtils;
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.mapper.FarmPlotMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.plot.mapper.PlotEnvRealtimeMapper;
import com.agriSmart.plot.domain.PlotEnvRealtime;
import com.agriSmart.plot.service.IPlotEnvRealtimeService;
import org.springframework.transaction.annotation.Transactional;

import static com.agriSmart.constant.PlotConstant.*;

/**
 * 片区环境实时数据Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@Service
public class PlotEnvRealtimeServiceImpl implements IPlotEnvRealtimeService 
{
    @Autowired
    private PlotEnvRealtimeMapper plotEnvRealtimeMapper;
    @Autowired
    private AlertThresholdMapper alertThresholdMapper;
    @Autowired
    private FarmPlotMapper farmPlotMapper;
    @Autowired
    private AlertHistoryMapper alertHistoryMapper;

    /**
     * 查询片区环境实时数据
     * 
     * @param id 片区环境实时数据主键
     * @return 片区环境实时数据
     */
    @Override
    public PlotEnvRealtime selectPlotEnvRealtimeById(Long id)
    {
        return plotEnvRealtimeMapper.selectPlotEnvRealtimeById(id);
    }

    /**
     * 查询片区环境实时数据列表
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 片区环境实时数据
     */
    @Override
    public List<PlotEnvRealtime> selectPlotEnvRealtimeList(PlotEnvRealtime plotEnvRealtime)
    {
        return plotEnvRealtimeMapper.selectPlotEnvRealtimeList(plotEnvRealtime);
    }

    /**
     * 新增片区环境实时数据
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 结果
     */
    @Override
    public AjaxResult insertPlotEnvRealtime(PlotEnvRealtime plotEnvRealtime)
    {
        plotEnvRealtime.setCreateTime(DateUtils.getNowDate());
        plotEnvRealtime.setCollectTime(DateUtils.getNowDate());
        int i = plotEnvRealtimeMapper.insertPlotEnvRealtime(plotEnvRealtime);
        return handleEnv(plotEnvRealtime, i);
    }

    /**
     * 修改片区环境实时数据
     * 
     * @param plotEnvRealtime 片区环境实时数据
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public AjaxResult updatePlotEnvRealtime(PlotEnvRealtime plotEnvRealtime) {
        plotEnvRealtime.setUpdateTime(DateUtils.getNowDate());
        plotEnvRealtime.setCollectTime(DateUtils.getNowDate());
        int i = plotEnvRealtimeMapper.updatePlotEnvRealtime(plotEnvRealtime);
        return handleEnv(plotEnvRealtime, i);
    }

    private AjaxResult handleEnv(PlotEnvRealtime plotEnvRealtime, int i) {
        if (i == 0) {
            return AjaxResult.error();
        }

        FarmPlot farmPlot = farmPlotMapper.selectFarmPlotById(plotEnvRealtime.getPlotId());
        if (farmPlot.getStatus().equals(PLOT_STATUS_STOP)) {
            return AjaxResult.success();
        }

        AlertThreshold alertThreshold = new AlertThreshold();
        alertThreshold.setPlotId(plotEnvRealtime.getPlotId());
        alertThreshold.setAlertTypeId(plotEnvRealtime.getAlertTypeId());
        List<AlertThreshold> alertThresholds = alertThresholdMapper.selectAlertThresholdList(alertThreshold);

        if (alertThresholds.size() == 1) {
            BigDecimal min = alertThresholds.getFirst().getMinValue();
            BigDecimal max = alertThresholds.getFirst().getMaxValue();
            BigDecimal envValue = plotEnvRealtime.getEnvValue();

            if (envValue != null) {
                boolean isException = false;

                if (min != null && max != null) {
                    isException = envValue.compareTo(min) < 0 || envValue.compareTo(max) > 0;
                } else if (min != null) {
                    isException = envValue.compareTo(min) < 0;
                } else if (max != null) {
                    isException = envValue.compareTo(max) > 0;
                }

                handleAlertHistory(plotEnvRealtime, alertThresholds.getFirst(), isException, envValue, min, max);

                updatePlotStatusIfNeeded(plotEnvRealtime.getPlotId(), isException);
            }
        }
        return AjaxResult.success();
    }

    public void handleAlertHistory(PlotEnvRealtime realtime, AlertThreshold threshold,
                                    boolean isException, BigDecimal envValue,
                                    BigDecimal min, BigDecimal max) {
        AlertHistory unrecoveredAlert = alertHistoryMapper.selectUnrecoveredAlert(
                realtime.getPlotId(),
                realtime.getAlertTypeId()
        );

        if (isException) {
            if (unrecoveredAlert == null) {
                AlertHistory newAlert = new AlertHistory();
                newAlert.setPlotId(realtime.getPlotId());
                newAlert.setAlertTypeId(realtime.getAlertTypeId());
                newAlert.setTriggerValue(envValue);
                newAlert.setMinValue(min);
                newAlert.setMaxValue(max);
                newAlert.setStatus(0);
                newAlert.setTriggerTime(DateUtils.getNowDate());
                newAlert.setCreateTime(DateUtils.getNowDate());
                newAlert.setRemark("设备数据异常");

                alertHistoryMapper.insertAlertHistory(newAlert);
            } else {
                unrecoveredAlert.setUpdateTime(DateUtils.getNowDate());
                alertHistoryMapper.updateAlertHistory(unrecoveredAlert);
            }
        } else {
            if (unrecoveredAlert != null) {
                Date recoverTime = DateUtils.getNowDate();
                unrecoveredAlert.setStatus(1);
                unrecoveredAlert.setRecoveryTime(recoverTime);

                long durationMillis = recoverTime.getTime() - unrecoveredAlert.getTriggerTime().getTime();
                int durationMinutes = (int) (durationMillis / (1000 * 60));
                unrecoveredAlert.setDurationMinutes(durationMinutes);
                unrecoveredAlert.setUpdateTime(recoverTime);
                unrecoveredAlert.setRemark("数据恢复正常");

                alertHistoryMapper.updateAlertHistory(unrecoveredAlert);
            }
        }
    }

    public void updatePlotStatusIfNeeded(Long plotId, boolean currentIsException) {
        if (currentIsException) {
            FarmPlot farmPlot = farmPlotMapper.selectFarmPlotById(plotId);
            if (farmPlot != null && !farmPlot.getStatus().equals(PLOT_STATUS_STOP)
                    && !farmPlot.getStatus().equals(PLOT_STATUS_EXCEPTION)) {
                FarmPlot updateFarmPlot = new FarmPlot();
                updateFarmPlot.setId(plotId);
                updateFarmPlot.setStatus(PLOT_STATUS_EXCEPTION);
                farmPlotMapper.updateFarmPlot(updateFarmPlot);
            }
        } else {
            checkIfAllNormalByHistoryAndUpdate(plotId);
        }
    }

    public void checkIfAllNormalByHistoryAndUpdate(Long plotId) {
        int unrecoveredAlerts = alertHistoryMapper.selectUnrecoveredAlertsByPlotId(plotId);

        if (unrecoveredAlerts == 0) {
            FarmPlot farmPlot = farmPlotMapper.selectFarmPlotById(plotId);
            if (farmPlot != null && !farmPlot.getStatus().equals(PLOT_STATUS_STOP)) {
                FarmPlot updateFarmPlot = new FarmPlot();
                updateFarmPlot.setId(plotId);
                updateFarmPlot.setStatus(PLOT_STATUS_NORMAL);
                farmPlotMapper.updateFarmPlot(updateFarmPlot);
            }
        }
    }

    private void recoverAlertHistoryForDeletedData(PlotEnvRealtime realtime) {
        if (realtime == null || realtime.getPlotId() == null || realtime.getAlertTypeId() == null) {
            return;
        }

        AlertHistory unrecoveredAlert = alertHistoryMapper.selectUnrecoveredAlert(
                realtime.getPlotId(),
                realtime.getAlertTypeId()
        );

        if (unrecoveredAlert != null) {
            Date recoverTime = DateUtils.getNowDate();
            unrecoveredAlert.setStatus(1);
            unrecoveredAlert.setRecoveryTime(recoverTime);

            long durationMillis = recoverTime.getTime() - unrecoveredAlert.getTriggerTime().getTime();
            int durationMinutes = (int) (durationMillis / (1000 * 60));
            unrecoveredAlert.setDurationMinutes(durationMinutes);
            unrecoveredAlert.setUpdateTime(recoverTime);
            unrecoveredAlert.setRemark("设备数据脱离而恢复");

            alertHistoryMapper.updateAlertHistory(unrecoveredAlert);
        }
    }

    /**
     * 批量删除片区环境实时数据
     * 
     * @param ids 需要删除的片区环境实时数据主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deletePlotEnvRealtimeByIds(Long[] ids)
    {
        List<PlotEnvRealtime> realtimeList = plotEnvRealtimeMapper.selectPlotEnvRealtimeByIds(ids);
        for (PlotEnvRealtime realtime : realtimeList) {
            recoverAlertHistoryForDeletedData(realtime);
        }

        int result = plotEnvRealtimeMapper.deletePlotEnvRealtimeByIds(ids);

        List<FarmPlot> farmPlots = farmPlotMapper.selectFarmPlotByIds(realtimeList);
        for (FarmPlot farmPlot : farmPlots) {
            checkIfAllNormalByHistoryAndUpdate(farmPlot.getId());
        }

        return result;
    }

    /**
     * 删除片区环境实时数据信息
     *
     * @param id 片区环境实时数据主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deletePlotEnvRealtimeById(Long id)
    {
        PlotEnvRealtime plotEnvRealtime = plotEnvRealtimeMapper.selectPlotEnvRealtimeById(id);
        int result = plotEnvRealtimeMapper.deletePlotEnvRealtimeById(id);

//        if (result > 0 && plotEnvRealtime != null) {
//            recalculatePlotStatus(plotEnvRealtime.getPlotId());
//        }

        return result;
    }
}
