package com.agriSmart.monitor.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.agriSmart.common.annotation.Log;
import com.agriSmart.common.core.controller.BaseController;
import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.common.enums.BusinessType;
import com.agriSmart.monitor.domain.MonitorJob;
import com.agriSmart.monitor.service.IMonitorJobService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 监控任务Controller
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
@RestController
@RequestMapping("/monitor/job")
public class MonitorJobController extends BaseController
{
    @Autowired
    private IMonitorJobService monitorJobService;

    /**
     * 查询监控任务列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:list')")
    @GetMapping("/list")
    public TableDataInfo list(MonitorJob monitorJob)
    {
        startPage();
        List<MonitorJob> list = monitorJobService.selectMonitorJobList(monitorJob);
        return getDataTable(list);
    }

    /**
     * 导出监控任务列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:export')")
    @Log(title = "监控任务", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MonitorJob monitorJob)
    {
        List<MonitorJob> list = monitorJobService.selectMonitorJobList(monitorJob);
        ExcelUtil<MonitorJob> util = new ExcelUtil<MonitorJob>(MonitorJob.class);
        util.exportExcel(response, list, "监控任务数据");
    }

    /**
     * 获取监控任务详细信息
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(monitorJobService.selectMonitorJobById(id));
    }

    /**
     * 新增监控任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:add')")
    @Log(title = "监控任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MonitorJob monitorJob)
    {
        return monitorJobService.insertMonitorJob(monitorJob);
    }

    /**
     * 修改监控任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:edit')")
    @Log(title = "监控任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MonitorJob monitorJob)
    {
        return toAjax(monitorJobService.updateMonitorJob(monitorJob));
    }

    /**
     * 结束监控任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:edit')")
    @Log(title = "结束监控任务", businessType = BusinessType.UPDATE)
    @PutMapping("/end/{monitorId}")
    public AjaxResult endJob(@PathVariable Long monitorId)
    {
        return toAjax(monitorJobService.endMonitorJob(monitorId));
    }

    /**
     * 删除监控任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:remove')")
    @Log(title = "监控任务", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(monitorJobService.deleteMonitorJobByIds(ids));
    }
}
