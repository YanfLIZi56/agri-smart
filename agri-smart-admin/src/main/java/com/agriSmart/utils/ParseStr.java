package com.agriSmart.utils;

import com.agriSmart.alert.domain.AlertThreshold;
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.domain.PlotEnvRealtime;
import com.agriSmart.plot.domain.dto.EnvDto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.agriSmart.constant.PlotConstant.*;

/**
 * @author 羊离子
 */
public class ParseStr {

    public static BigDecimal[] parseThreshold(String thresholdStr) {
        if (thresholdStr == null || !thresholdStr.contains("-")) {
            return null;
        }
        String[] parts = thresholdStr.split("-");
        if (parts.length == 2) {
            return new BigDecimal[]{
                    new BigDecimal(parts[0].trim()),
                    new BigDecimal(parts[1].trim())
            };
        }
        return null;
    }

    public static List<EnvDto> parseEnv(List<AlertThreshold> thresholds, List<PlotEnvRealtime> realtime) {
        List<EnvDto> envDtos = new ArrayList<>();
        Map<Object, Object> map = new HashMap<>();
        for (AlertThreshold threshold : thresholds) {
            EnvDto envDto = new EnvDto();
            envDto.setAlertType(threshold.getAlertType());
            envDto.setAlertTypeId(threshold.getAlertTypeId());
            envDto.setUnit(threshold.getUnit());
            envDto.setMinValue(threshold.getMinValue());
            envDto.setMaxValue(threshold.getMaxValue());
            map.put(threshold.getAlertTypeId(), envDto);
        }
        for (PlotEnvRealtime env : realtime) {
            EnvDto envDto = (EnvDto) map.get(env.getAlertTypeId());
            if (envDto != null) {
                envDto.setEnvValue(env.getEnvValue());
                envDto.setCollectTime(env.getCollectTime());
            }else {
                envDto = new EnvDto();
                envDto.setAlertType(env.getAlertType());
                envDto.setAlertTypeId(env.getAlertTypeId());
                envDto.setUnit(env.getUnit());
                envDto.setEnvValue(env.getEnvValue());
                envDto.setCollectTime(env.getCollectTime());
            }
            envDtos.add(envDto);
        }
        return envDtos;
    }

//    public static Integer checkEnvThreshold(PlotEnvRealtime envData, FarmPlot plot)
//    {
//        if (plot.getStatus().equals(PLOT_STATUS_STOP)) {
//            return PLOT_STATUS_STOP;
//        }
//
//        int newPlotStatus = PLOT_STATUS_NORMAL;
        // === 温度
//        if (plot.getTempThreshold() != null && envData.getTemperature() != null) {
//            BigDecimal[] thresholds = parseThreshold(plot.getTempThreshold());
//            if (thresholds != null && thresholds.length == 2) {
//                if (envData.getTemperature().compareTo(thresholds[0]) < 0 || envData.getTemperature().compareTo(thresholds[1]) > 0) {
//                    newPlotStatus = PLOT_STATUS_EXCEPTION;
//                }
//            }
//        }
//
//        // === 湿度
//        if (plot.getHumidityThreshold() != null && envData.getHumidity() != null) {
//            BigDecimal[] thresholds = parseThreshold(plot.getHumidityThreshold());
//            if (thresholds != null && thresholds.length == 2) {
//                if (envData.getHumidity().compareTo(thresholds[0]) < 0 || envData.getHumidity().compareTo(thresholds[1]) > 0) {
//                    newPlotStatus = PLOT_STATUS_EXCEPTION;
//                }
//            }
//        }
//
//        // === CO2
//        if (plot.getCo2Threshold() != null && envData.getCo2() != null) {
//            BigDecimal[] thresholds = parseThreshold(plot.getCo2Threshold());
//            if (thresholds != null && thresholds.length == 2) {
//                BigDecimal co2Value = new BigDecimal(envData.getCo2());
//                if (co2Value.compareTo(thresholds[0]) < 0 || co2Value.compareTo(thresholds[1]) > 0) {
//                    newPlotStatus = PLOT_STATUS_EXCEPTION;
//                }
//            }
//        }
//
//        // === PH
//        if (plot.getPhThreshold() != null && envData.getPh() != null) {
//            BigDecimal[] thresholds = parseThreshold(plot.getPhThreshold());
//            if (thresholds != null && thresholds.length == 2) {
//                BigDecimal phValue = envData.getPh();
//                if (phValue.compareTo(thresholds[0]) < 0 || phValue.compareTo(thresholds[1]) > 0) {
//                    newPlotStatus = PLOT_STATUS_EXCEPTION;
//                }
//            }
//        }
//        return newPlotStatus;
//    }
}
