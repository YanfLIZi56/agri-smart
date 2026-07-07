package com.agriSmart.monitor.service.impl;

import java.util.List;
import java.util.Map;

import com.agriSmart.common.core.redis.RedisCache;
import com.agriSmart.common.utils.DateUtils;
import com.agriSmart.monitor.domain.dto.JobResDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.monitor.mapper.MonitorMapper;
import com.agriSmart.monitor.domain.Monitor;
import com.agriSmart.monitor.service.IMonitorService;

import static com.agriSmart.constant.MonitorStatus.STREAM_KEY;

/**
 * 监控管理Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
@Service
public class MonitorServiceImpl implements IMonitorService 
{
    @Autowired
    private MonitorMapper monitorMapper;
    @Autowired
    private RedisCache redisCache;

    /**
     * 查询监控管理
     * 
     * @param id 监控管理主键
     * @return 监控管理
     */
    @Override
    public Monitor selectMonitorById(Long id)
    {
        return monitorMapper.selectMonitorById(id);
    }

    /**
     * 查询监控管理列表
     * 
     * @param monitor 监控管理
     * @return 监控管理
     */
    @Override
    public List<Monitor> selectMonitorList(Monitor monitor)
    {
        return monitorMapper.selectMonitorList(monitor);
    }

    /**
     * 新增监控管理
     * 
     * @param monitor 监控管理
     * @return 结果
     */
    @Override
    public int insertMonitor(Monitor monitor)
    {
        monitor.setCreateTime(DateUtils.getNowDate());
        return monitorMapper.insertMonitor(monitor);
    }

    /**
     * 修改监控管理
     * 
     * @param monitor 监控管理
     * @return 结果
     */
    @Override
    public int updateMonitor(Monitor monitor)
    {
        monitor.setUpdateTime(DateUtils.getNowDate());
        return monitorMapper.updateMonitor(monitor);
    }

    /**
     * 批量删除监控管理
     * 
     * @param ids 需要删除的监控管理主键
     * @return 结果
     */
    @Override
    public int deleteMonitorByIds(Long[] ids)
    {
        return monitorMapper.deleteMonitorByIds(ids);
    }

    /**
     * 删除监控管理信息
     * 
     * @param id 监控管理主键
     * @return 结果
     */
    @Override
    public int deleteMonitorById(Long id)
    {
        return monitorMapper.deleteMonitorById(id);
    }

    @Override
    public int updateMonitorStatus(Long id, Long status) {
        return monitorMapper.updateMonitorStatus(id, status);
    }

    @Override
    public Map<String, String> getRtcUrl(Long id) {
        String rtcUrl = "";
        if (redisCache.hasKey(STREAM_KEY + id)) {
            JobResDto response = redisCache.getCacheObject(STREAM_KEY + id);
            rtcUrl = response.getWebrtcUrl();
        }
        return Map.of("rtcUrl", rtcUrl);
    }
}
