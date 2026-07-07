package com.agriSmart.alert.service.impl;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.agriSmart.alert.domain.AlertHistory;
import com.agriSmart.alert.mapper.AlertHistoryMapper;
import com.agriSmart.common.utils.DateUtils;
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.domain.PlotEnvRealtime;
import com.agriSmart.plot.mapper.FarmPlotMapper;
import com.agriSmart.plot.mapper.PlotEnvRealtimeMapper;
import com.agriSmart.plot.service.impl.PlotEnvRealtimeServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.alert.mapper.AlertThresholdMapper;
import com.agriSmart.alert.domain.AlertThreshold;
import com.agriSmart.alert.service.IAlertThresholdService;
import org.springframework.transaction.annotation.Transactional;

import static com.agriSmart.constant.PlotConstant.*;

/**
 * 预警阈值配置Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@Service
public class AlertThresholdServiceImpl implements IAlertThresholdService {
    @Autowired
    private AlertThresholdMapper alertThresholdMapper;
    @Autowired
    private FarmPlotMapper farmPlotMapper;
    @Autowired
    private PlotEnvRealtimeMapper plotEnvRealtimeMapper;
    @Autowired
    private AlertHistoryMapper alertHistoryMapper;
    @Autowired
    private PlotEnvRealtimeServiceImpl plotEnvRealtimeService;

    /**
     * 查询预警阈值配置
     *
     * @param id 预警阈值配置主键
     * @return 预警阈值配置
     */
    @Override
    public AlertThreshold selectAlertThresholdById(Long id) {
        return alertThresholdMapper.selectAlertThresholdById(id);
    }

    /**
     * 查询预警阈值配置列表
     *
     * @param alertThreshold 预警阈值配置
     * @return 预警阈值配置
     */
    @Override
    public List<AlertThreshold> selectAlertThresholdList(AlertThreshold alertThreshold) {
        return alertThresholdMapper.selectAlertThresholdList(alertThreshold);
    }

    /**
     * 新增预警阈值配置
     *
     * @param alertThreshold 预警阈值配置
     * @return 结果
     */
    @Transactional
    @Override
    public int insertAlertThreshold(AlertThreshold alertThreshold) {
        alertThreshold.setCreateTime(DateUtils.getNowDate());
        int result = alertThresholdMapper.insertAlertThreshold(alertThreshold);

        if (result > 0 && alertThreshold.getPlotId() != null) {
            recalculatePlotStatusWithNewThreshold(alertThreshold.getPlotId(), alertThreshold.getAlertTypeId());
        }
        return result;
    }

    /**
     * 修改预警阈值配置
     *
     * @param alertThreshold 预警阈值配置
     * @return 结果
     */
    @Transactional
    @Override
    public int updateAlertThreshold(AlertThreshold alertThreshold) {
        alertThreshold.setUpdateTime(DateUtils.getNowDate());
        int result = alertThresholdMapper.updateAlertThreshold(alertThreshold);

        if (result > 0 && alertThreshold.getPlotId() != null) {
            recalculatePlotStatusWithNewThreshold(alertThreshold.getPlotId(), alertThreshold.getAlertTypeId());
        }
        return result;
    }


    /**
     * 批量删除预警阈值配置
     * 
     * @param ids 需要删除的预警阈值配置主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteAlertThresholdByIds(Long[] ids)
    {
        List<AlertThreshold> thresholds = alertThresholdMapper.selectAlertThresholdByIds(ids);
        for (AlertThreshold threshold : thresholds){
            recoverAlertHistoryForDeletedData(threshold);
        }

        int result = alertThresholdMapper.deleteAlertThresholdByIds(ids);

        List<FarmPlot> farmPlots = farmPlotMapper.selectFarmPlotByIds2(thresholds);
        for (FarmPlot farmPlot : farmPlots) {
            plotEnvRealtimeService.checkIfAllNormalByHistoryAndUpdate(farmPlot.getId());
        }

        return result;
    }

    private void recalculatePlotStatusWithNewThreshold(Long plotId, Long alertTypeId) {
        FarmPlot farmPlot = farmPlotMapper.selectFarmPlotById(plotId);
        if (farmPlot == null || PLOT_STATUS_STOP.equals(farmPlot.getStatus())) {
            return;
        }

        AlertThreshold threshold = alertThresholdMapper.selectAlertThresholdByIdByPlotAndType(plotId, alertTypeId);
        if (threshold == null) {
            return;
        }

        PlotEnvRealtime queryParam = new PlotEnvRealtime();
        queryParam.setPlotId(plotId);
        queryParam.setAlertTypeId(alertTypeId);
        List<PlotEnvRealtime> realtimeList = plotEnvRealtimeMapper.selectPlotEnvRealtimeList(queryParam);

        if (realtimeList.size() == 1) {
            BigDecimal envValue = realtimeList.getFirst().getEnvValue();
            BigDecimal min = threshold.getMinValue();
            BigDecimal max = threshold.getMaxValue();
            if (envValue != null) {
                boolean isException = false;
                if (min != null && max != null) {
                    isException = envValue.compareTo(min) < 0 || envValue.compareTo(max) > 0;
                } else if (min != null) {
                    isException = envValue.compareTo(min) < 0;
                } else if (max != null) {
                    isException = envValue.compareTo(max) > 0;
                }

                handleAlertHistoryForThresholdChange(realtimeList.getFirst(), threshold, isException, envValue, min, max);

                plotEnvRealtimeService.updatePlotStatusIfNeeded(plotId, isException);
            }
        }
    }

    private void recoverAlertHistoryForDeletedData(AlertThreshold threshold) {
        if (threshold == null || threshold.getPlotId() == null || threshold.getAlertTypeId() == null) {
            return;
        }

        AlertHistory unrecoveredAlert = alertHistoryMapper.selectUnrecoveredAlert(
                threshold.getPlotId(),
                threshold.getAlertTypeId()
        );

        if (unrecoveredAlert != null) {
            Date recoverTime = DateUtils.getNowDate();
            unrecoveredAlert.setStatus(1);
            unrecoveredAlert.setRecoveryTime(recoverTime);

            long durationMillis = recoverTime.getTime() - unrecoveredAlert.getTriggerTime().getTime();
            int durationMinutes = (int) (durationMillis / (1000 * 60));
            unrecoveredAlert.setDurationMinutes(durationMinutes);
            unrecoveredAlert.setUpdateTime(recoverTime);
            unrecoveredAlert.setRemark("预警阈值配置删除而恢复");

            alertHistoryMapper.updateAlertHistory(unrecoveredAlert);
        }
    }

    private void handleAlertHistoryForThresholdChange(PlotEnvRealtime realtime, AlertThreshold threshold,
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
                newAlert.setRemark("阈值调整导致异常");

                alertHistoryMapper.insertAlertHistory(newAlert);
            } else {
                unrecoveredAlert.setTriggerValue(envValue);
                unrecoveredAlert.setMinValue(min);
                unrecoveredAlert.setMaxValue(max);
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
                unrecoveredAlert.setRemark("阈值调整使数据恢复正常");

                alertHistoryMapper.updateAlertHistory(unrecoveredAlert);
            }
        }
    }

    /**
     * 删除预警阈值配置信息
     * 
     * @param id 预警阈值配置主键
     * @return 结果
     */
    @Override
    public int deleteAlertThresholdById(Long id)
    {
        return alertThresholdMapper.deleteAlertThresholdById(id);
    }
}
