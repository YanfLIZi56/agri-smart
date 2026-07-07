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
import com.agriSmart.alert.domain.AlertThreshold;
import com.agriSmart.alert.service.IAlertThresholdService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 预警阈值配置Controller
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@RestController
@RequestMapping("/alert/threshold")
public class AlertThresholdController extends BaseController
{
    @Autowired
    private IAlertThresholdService alertThresholdService;

    /**
     * 查询预警阈值配置列表
     */
    @PreAuthorize("@ss.hasPermi('alert:threshold:list')")
    @GetMapping("/list")
    public TableDataInfo list(AlertThreshold alertThreshold)
    {
        startPage();
        List<AlertThreshold> list = alertThresholdService.selectAlertThresholdList(alertThreshold);
        return getDataTable(list);
    }

    /**
     * 导出预警阈值配置列表
     */
    @PreAuthorize("@ss.hasPermi('alert:threshold:export')")
    @Log(title = "预警阈值配置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AlertThreshold alertThreshold)
    {
        List<AlertThreshold> list = alertThresholdService.selectAlertThresholdList(alertThreshold);
        ExcelUtil<AlertThreshold> util = new ExcelUtil<AlertThreshold>(AlertThreshold.class);
        util.exportExcel(response, list, "预警阈值配置数据");
    }

    /**
     * 获取预警阈值配置详细信息
     */
    @PreAuthorize("@ss.hasPermi('alert:threshold:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(alertThresholdService.selectAlertThresholdById(id));
    }

    /**
     * 新增预警阈值配置
     */
    @PreAuthorize("@ss.hasPermi('alert:threshold:add')")
    @Log(title = "预警阈值配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AlertThreshold alertThreshold)
    {
        return toAjax(alertThresholdService.insertAlertThreshold(alertThreshold));
    }

    /**
     * 修改预警阈值配置
     */
    @PreAuthorize("@ss.hasPermi('alert:threshold:edit')")
    @Log(title = "预警阈值配置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody AlertThreshold alertThreshold)
    {
        return toAjax(alertThresholdService.updateAlertThreshold(alertThreshold));
    }

    /**
     * 删除预警阈值配置
     */
    @PreAuthorize("@ss.hasPermi('alert:threshold:remove')")
    @Log(title = "预警阈值配置", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(alertThresholdService.deleteAlertThresholdByIds(ids));
    }
}
