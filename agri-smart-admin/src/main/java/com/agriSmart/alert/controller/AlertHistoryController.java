package com.agriSmart.alert.controller;

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
import com.agriSmart.alert.domain.AlertHistory;
import com.agriSmart.alert.service.IAlertHistoryService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 预警历史记录Controller
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
@RestController
@RequestMapping("/alert/history")
public class AlertHistoryController extends BaseController
{
    @Autowired
    private IAlertHistoryService alertHistoryService;

    /**
     * 查询预警历史记录列表
     */
    @PreAuthorize("@ss.hasPermi('alert:history:list')")
    @GetMapping("/list")
    public TableDataInfo list(AlertHistory alertHistory)
    {
        startPage();
        List<AlertHistory> list = alertHistoryService.selectAlertHistoryList(alertHistory);
        return getDataTable(list);
    }

    /**
     * 导出预警历史记录列表
     */
    @PreAuthorize("@ss.hasPermi('alert:history:export')")
    @Log(title = "预警历史记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AlertHistory alertHistory)
    {
        List<AlertHistory> list = alertHistoryService.selectAlertHistoryList(alertHistory);
        ExcelUtil<AlertHistory> util = new ExcelUtil<AlertHistory>(AlertHistory.class);
        util.exportExcel(response, list, "预警历史记录数据");
    }

    /**
     * 获取预警历史记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('alert:history:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(alertHistoryService.selectAlertHistoryById(id));
    }

    /**
     * 新增预警历史记录
     */
    @PreAuthorize("@ss.hasPermi('alert:history:add')")
    @Log(title = "预警历史记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AlertHistory alertHistory)
    {
        return toAjax(alertHistoryService.insertAlertHistory(alertHistory));
    }

    /**
     * 修改预警历史记录
     */
    @PreAuthorize("@ss.hasPermi('alert:history:edit')")
    @Log(title = "预警历史记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody AlertHistory alertHistory)
    {
        return toAjax(alertHistoryService.updateAlertHistory(alertHistory));
    }

    /**
     * 删除预警历史记录
     */
    @PreAuthorize("@ss.hasPermi('alert:history:remove')")
    @Log(title = "预警历史记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(alertHistoryService.deleteAlertHistoryByIds(ids));
    }
}
