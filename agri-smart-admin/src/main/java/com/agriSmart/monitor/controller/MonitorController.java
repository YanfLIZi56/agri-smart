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
import com.agriSmart.monitor.domain.Monitor;
import com.agriSmart.monitor.service.IMonitorService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 监控管理Controller
 * 
 * @author 羊离子
 * @date 2026-06-13
 */
@RestController
@RequestMapping("/monitor/manage")
public class MonitorController extends BaseController
{
    @Autowired
    private IMonitorService monitorService;

    /**
     * 查询监控管理列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:list')")
    @GetMapping("/list")
    public TableDataInfo list(Monitor monitor)
    {
        startPage();
        List<Monitor> list = monitorService.selectMonitorList(monitor);
        return getDataTable(list);
    }

    /**
     * 导出监控管理列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:export')")
    @Log(title = "监控管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Monitor monitor)
    {
        List<Monitor> list = monitorService.selectMonitorList(monitor);
        ExcelUtil<Monitor> util = new ExcelUtil<Monitor>(Monitor.class);
        util.exportExcel(response, list, "监控管理数据");
    }

    /**
     * 获取监控管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(monitorService.selectMonitorById(id));
    }

    /**
     * 获取监控流路径 (/aaa/bbb)
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:query')")
    @GetMapping(value = "/rtc/{id}")
    public AjaxResult getRtcUrl(@PathVariable("id") Long id)
    {
        return success(monitorService.getRtcUrl(id));
    }


    /**
     * 新增监控管理
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:add')")
    @Log(title = "监控管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Monitor monitor)
    {
        return toAjax(monitorService.insertMonitor(monitor));
    }

    /**
     * 修改监控管理
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:edit')")
    @Log(title = "监控管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Monitor monitor)
    {
        return toAjax(monitorService.updateMonitor(monitor));
    }

    /**
     * 删除监控管理
     */
    @PreAuthorize("@ss.hasPermi('monitor:manage:remove')")
    @Log(title = "监控管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(monitorService.deleteMonitorByIds(ids));
    }
}
