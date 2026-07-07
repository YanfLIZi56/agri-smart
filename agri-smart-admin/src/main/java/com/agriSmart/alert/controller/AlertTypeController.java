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
import com.agriSmart.alert.domain.AlertType;
import com.agriSmart.alert.service.IAlertTypeService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 预警阈值类型Controller
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@RestController
@RequestMapping("/alert/type")
public class AlertTypeController extends BaseController
{
    @Autowired
    private IAlertTypeService alertTypeService;

    /**
     * 查询预警阈值类型列表
     */
    @PreAuthorize("@ss.hasPermi('alert:type:list')")
    @GetMapping("/list")
    public TableDataInfo list(AlertType alertType)
    {
        startPage();
        List<AlertType> list = alertTypeService.selectAlertTypeList(alertType);
        return getDataTable(list);
    }

    /**
     * 导出预警阈值类型列表
     */
    @PreAuthorize("@ss.hasPermi('alert:type:export')")
    @Log(title = "预警阈值类型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, AlertType alertType)
    {
        List<AlertType> list = alertTypeService.selectAlertTypeList(alertType);
        ExcelUtil<AlertType> util = new ExcelUtil<AlertType>(AlertType.class);
        util.exportExcel(response, list, "预警阈值类型数据");
    }

    /**
     * 获取预警阈值类型详细信息
     */
    @PreAuthorize("@ss.hasPermi('alert:type:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(alertTypeService.selectAlertTypeById(id));
    }

    /**
     * 新增预警阈值类型
     */
    @PreAuthorize("@ss.hasPermi('alert:type:add')")
    @Log(title = "预警阈值类型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody AlertType alertType)
    {
        return toAjax(alertTypeService.insertAlertType(alertType));
    }

    /**
     * 修改预警阈值类型
     */
    @PreAuthorize("@ss.hasPermi('alert:type:edit')")
    @Log(title = "预警阈值类型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody AlertType alertType)
    {
        return toAjax(alertTypeService.updateAlertType(alertType));
    }

    /**
     * 删除预警阈值类型
     */
    @PreAuthorize("@ss.hasPermi('alert:type:remove')")
    @Log(title = "预警阈值类型", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(alertTypeService.deleteAlertTypeByIds(ids));
    }
}
