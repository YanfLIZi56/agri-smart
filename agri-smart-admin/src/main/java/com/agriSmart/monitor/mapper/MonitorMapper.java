package com.agriSmart.monitor.mapper;

import java.util.List;
import com.agriSmart.monitor.domain.Monitor;

/**
 * 监控管理Mapper接口
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
public interface MonitorMapper 
{
    /**
     * 查询监控管理
     * 
     * @param id 监控管理主键
     * @return 监控管理
     */
    public Monitor selectMonitorById(Long id);

    /**
     * 查询监控管理列表
     * 
     * @param monitor 监控管理
     * @return 监控管理集合
     */
    public List<Monitor> selectMonitorList(Monitor monitor);

    /**
     * 新增监控管理
     * 
     * @param monitor 监控管理
     * @return 结果
     */
    public int insertMonitor(Monitor monitor);

    /**
     * 修改监控管理
     * 
     * @param monitor 监控管理
     * @return 结果
     */
    public int updateMonitor(Monitor monitor);

    /**
     * 删除监控管理
     * 
     * @param id 监控管理主键
     * @return 结果
     */
    public int deleteMonitorById(Long id);

    /**
     * 批量删除监控管理
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMonitorByIds(Long[] ids);

    int updateMonitorStatus(Long id, Long status);
}
