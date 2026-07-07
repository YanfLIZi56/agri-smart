package com.agriSmart.plot.domain.vo;

import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.domain.dto.EnvDto;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class PlotAndEnvVo extends FarmPlot {

    private List<EnvDto> envDtos;

    @Override
    public String toString() {
        return "PlotAndEnvVo{" +
                "envDtos=" + envDtos +
                '}';
    }

    public List<EnvDto> getEnvDtos() {
        return envDtos;
    }

    public void setEnvDtos(List<EnvDto> envDtos) {
        this.envDtos = envDtos;
    }
}
