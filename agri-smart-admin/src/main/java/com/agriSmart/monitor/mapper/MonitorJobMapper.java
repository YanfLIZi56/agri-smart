package com.agriSmart.monitor.mapper;

import java.util.List;
import com.agriSmart.monitor.domain.MonitorJob;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

/**
 * 监控任务Mapper接口
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
public interface MonitorJobMapper 
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
    public int insertMonitorJob(MonitorJob monitorJob);

    /**
     * 修改监控任务
     * 
     * @param monitorJob 监控任务
     * @return 结果
     */
    public int updateMonitorJob(MonitorJob monitorJob);

    /**
     * 删除监控任务
     * 
     * @param id 监控任务主键
     * @return 结果
     */
    public int deleteMonitorJobById(Long id);

    /**
     * 批量删除监控任务
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMonitorJobByIds(Long[] ids);

    @Select("select count(*) from monitor_job where monitor_id = #{monitorId} and status = 1")
    int hasWorkingJob(Long monitorId);

    @Update("update monitor_job set status = #{status}, end_time = #{endTime} where monitor_id = #{monitorId} and status = 1")
    int updateMonitorJobByMonitorId(MonitorJob monitorJob);
}
