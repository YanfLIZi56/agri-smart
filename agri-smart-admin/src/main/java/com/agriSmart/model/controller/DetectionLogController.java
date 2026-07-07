package com.agriSmart.model.controller;

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
import com.agriSmart.model.domain.DetectionLog;
import com.agriSmart.model.service.IDetectionLogService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 检测日志Controller
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
@RestController
@RequestMapping("/model/log")
public class DetectionLogController extends BaseController
{
    @Autowired
    private IDetectionLogService detectionLogService;

    /**
     * 查询检测日志列表
     */
    @PreAuthorize("@ss.hasPermi('model:log:list')")
    @GetMapping("/list")
    public TableDataInfo list(DetectionLog detectionLog)
    {
        startPage();
        List<DetectionLog> list = detectionLogService.selectDetectionLogList(detectionLog);
        return getDataTable(list);
    }

    /**
     * 导出检测日志列表
     */
    @PreAuthorize("@ss.hasPermi('model:log:export')")
    @Log(title = "检测日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, DetectionLog detectionLog)
    {
        List<DetectionLog> list = detectionLogService.selectDetectionLogList(detectionLog);
        ExcelUtil<DetectionLog> util = new ExcelUtil<DetectionLog>(DetectionLog.class);
        util.exportExcel(response, list, "检测日志数据");
    }

    /**
     * 获取检测日志详细信息
     */
    @PreAuthorize("@ss.hasPermi('model:log:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(detectionLogService.selectDetectionLogById(id));
    }

    /**
     * 新增检测日志
     */
    @PreAuthorize("@ss.hasPermi('model:log:add')")
    @Log(title = "检测日志", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody DetectionLog detectionLog)
    {
        return toAjax(detectionLogService.insertDetectionLog(detectionLog));
    }

    /**
     * 修改检测日志
     */
    @PreAuthorize("@ss.hasPermi('model:log:edit')")
    @Log(title = "检测日志", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody DetectionLog detectionLog)
    {
        return toAjax(detectionLogService.updateDetectionLog(detectionLog));
    }

    /**
     * 删除检测日志
     */
    @PreAuthorize("@ss.hasPermi('model:log:remove')")
    @Log(title = "检测日志", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(detectionLogService.deleteDetectionLogByIds(ids));
    }
}
