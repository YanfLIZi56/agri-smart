package com.agriSmart.monitor.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.common.core.redis.RedisCache;
import com.agriSmart.common.utils.DateUtils;
import com.agriSmart.constant.MonitorStatus;
import com.agriSmart.model.domain.ModelConfig;
import com.agriSmart.model.domain.dto.YoloRes;
import com.agriSmart.model.service.IModelConfigService;
import com.agriSmart.monitor.domain.Monitor;
import com.agriSmart.monitor.domain.dto.JobResDto;
import com.agriSmart.monitor.service.IMonitorService;
import com.agriSmart.utils.HttpUtis;
import com.alibaba.fastjson2.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import com.agriSmart.monitor.mapper.MonitorJobMapper;
import com.agriSmart.monitor.domain.MonitorJob;
import com.agriSmart.monitor.service.IMonitorJobService;
import org.springframework.transaction.annotation.Transactional;

import static com.agriSmart.common.core.domain.AjaxResult.error;
import static com.agriSmart.common.core.domain.AjaxResult.success;
import static com.agriSmart.constant.MonitorStatus.*;

/**
 * 监控任务Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
@Service
public class MonitorJobServiceImpl implements IMonitorJobService 
{
    @Autowired
    private MonitorJobMapper monitorJobMapper;
    @Autowired
    private IMonitorService monitorService;
    @Autowired
    private IModelConfigService modelConfigService;
    @Autowired
    private RedisCache redisCache;

    @Value("${ruoyi.yolo.url}")
    private String yoloApiUrl;
    @Value("${ruoyi.yolo.model-path}")
    private String modelPath;

    /**
     * 查询监控任务
     * 
     * @param id 监控任务主键
     * @return 监控任务
     */
    @Override
    public MonitorJob selectMonitorJobById(Long id)
    {
        return monitorJobMapper.selectMonitorJobById(id);
    }

    /**
     * 查询监控任务列表
     * 
     * @param monitorJob 监控任务
     * @return 监控任务
     */
    @Override
    public List<MonitorJob> selectMonitorJobList(MonitorJob monitorJob)
    {
        return monitorJobMapper.selectMonitorJobList(monitorJob);
    }

    /**
     * 新增监控任务
     * 
     * @param monitorJob 监控任务
     * @return 结果
     */
    @Transactional(rollbackFor = Exception.class)
    @Override
    public synchronized AjaxResult insertMonitorJob(MonitorJob monitorJob)
    {
        if (redisCache.hasKey(STREAM_KEY + monitorJob.getMonitorId())){
            return error("当前任务已存在, 请稍后重试或结束任务");
        }
        int i1 = monitorJobMapper.hasWorkingJob((monitorJob.getMonitorId()));
        if (i1 > 0){
            return error("当前任务已存在, 请稍后重试或结束任务");
        }
        monitorJob.setCreateTime(DateUtils.getNowDate());
            int rows = monitorJobMapper.insertMonitorJob(monitorJob);

            if (rows <= 0) {
                return error();
            }
            // 启动任务
            Monitor monitor = monitorService.selectMonitorById(monitorJob.getMonitorId());
            ModelConfig modelConfig = modelConfigService.selectModelConfigById(monitorJob.getModelConfigId());
            if (modelConfig != null && monitor != null && modelConfig.getIsActive() == 1) {
                String filePath = modelPath + modelConfig.getFilePath();

                Map<String, Object> params = new HashMap<>();
                params.put("rtsp_url", monitor.getRtspUrl());
                params.put("duration", monitorJob.getDuration());
                params.put("model_path", filePath);
                params.put("device_id", monitorJob.getMonitorId());

                String apiUrl = yoloApiUrl.endsWith("/") ? yoloApiUrl + "streams" : yoloApiUrl + "/streams";

                String result = HttpUtis.sendPost(apiUrl, params);

                JobResDto response = JSON.parseObject(result, JobResDto.class);
                if (response.getStatus() == 1){
                    return error("任务启动失败：" + response.getMessage());
                }

                // 启动成功
                int i = monitorService.updateMonitorStatus(monitor.getId(), WORKING);
                if (i <= 0) {
                    stopApiUrl(response);
                    return error("任务启动失败：" + "更新监控任务状态失败");
                }

                if (monitorJob.getDuration() > 0){
                    redisCache.setCacheObject(STREAM_KEY + monitorJob.getMonitorId(), response, monitorJob.getDuration(), TimeUnit.SECONDS);
                }else {
                    redisCache.setCacheObject(STREAM_KEY + monitorJob.getMonitorId(), response);
                }

                return success();
            }
        return error("任务启动失败：监控不存在或模型不可用");
    }

    private int stopApiUrl(JobResDto response) {
        String stopApiUrl = yoloApiUrl.endsWith("/") ? yoloApiUrl + "streams/" : yoloApiUrl + "/streams/";
        stopApiUrl += response.getStreamId();
        return HttpUtis.sendDelete(stopApiUrl);
    }

    /**
     * 修改监控任务
     * 
     * @param monitorJob 监控任务
     * @return 结果
     */
    @Override
    public int updateMonitorJob(MonitorJob monitorJob)
    {
        monitorJob.setUpdateTime(DateUtils.getNowDate());
        return monitorJobMapper.updateMonitorJob(monitorJob);
    }

    /**
     * 批量删除监控任务
     * 
     * @param ids 需要删除的监控任务主键
     * @return 结果
     */
    @Override
    public int deleteMonitorJobByIds(Long[] ids)
    {
        return monitorJobMapper.deleteMonitorJobByIds(ids);
    }

    /**
     * 删除监控任务信息
     * 
     * @param id 监控任务主键
     * @return 结果
     */
    @Override
    public int deleteMonitorJobById(Long id)
    {
        return monitorJobMapper.deleteMonitorJobById(id);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public int stopJob(Long devId) {
        MonitorJob monitorJob = new MonitorJob();
        monitorJob.setMonitorId(devId);
        monitorJob.setStatus(2L);
        monitorJob.setEndTime(DateUtils.getNowDate());
        int rows = monitorJobMapper.updateMonitorJobByMonitorId(monitorJob);
        monitorService.updateMonitorStatus(devId, READY);
        redisCache.deleteObject(STREAM_KEY + devId);
        return rows;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public int endMonitorJob(Long monitorId) {
        if (redisCache.hasKey(STREAM_KEY + monitorId)){
            JobResDto response = redisCache.getCacheObject(STREAM_KEY + monitorId);
            int statusCode = stopApiUrl(response);
            boolean b = redisCache.deleteObject(STREAM_KEY + monitorId);

            if (statusCode == 404) {
                MonitorJob monitorJob = new MonitorJob();
                monitorJob.setMonitorId(monitorId);
                monitorJob.setStatus(2L);
                monitorJobMapper.updateMonitorJobByMonitorId(monitorJob);
                monitorService.updateMonitorStatus(monitorId, READY);
            }
            return b ? 1 : 0;
        }
        return 0;
    }
}
