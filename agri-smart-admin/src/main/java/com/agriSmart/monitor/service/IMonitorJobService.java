package com.agriSmart.monitor.service;

import java.util.List;

import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.monitor.domain.MonitorJob;

/**
 * 监控任务Service接口
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
public interface IMonitorJobService 
{
    /**
     * 查询监控任务
     * 
     * @param id 监控任务主键
     * @return 监控任务
     */
    public MonitorJob selectMonitorJobById(Long id);

    /**
     * 查询监控任务列表
     * 
     * @param monitorJob 监控任务
     * @return 监控任务集合
     */
    public List<MonitorJob> selectMonitorJobList(MonitorJob monitorJob);

    /**
     * 新增监控任务
     * 
     * @param monitorJob 监控任务
     * @return 结果
     */
    public AjaxResult insertMonitorJob(MonitorJob monitorJob);

    /**
     * 修改监控任务
     * 
     * @param monitorJob 监控任务
     * @return 结果
     */
    public int updateMonitorJob(MonitorJob monitorJob);

    /**
     * 批量删除监控任务
     * 
     * @param ids 需要删除的监控任务主键集合
     * @return 结果
     */
    public int deleteMonitorJobByIds(Long[] ids);

    /**
     * 删除监控任务信息
     * 
     * @param id 监控任务主键
     * @return 结果
     */
    public int deleteMonitorJobById(Long id);

    int stopJob(Long devId);

    int endMonitorJob(Long monitorId);
}
