package com.agriSmart.plot.controller;

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
import com.agriSmart.plot.domain.PlotEnvRealtime;
import com.agriSmart.plot.service.IPlotEnvRealtimeService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 片区环境实时数据Controller
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@RestController
@RequestMapping("/plot/realtime")
public class PlotEnvRealtimeController extends BaseController
{
    @Autowired
    private IPlotEnvRealtimeService plotEnvRealtimeService;

    /**
     * 查询片区环境实时数据列表
     */
    @PreAuthorize("@ss.hasPermi('plot:realtime:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlotEnvRealtime plotEnvRealtime)
    {
        startPage();
        List<PlotEnvRealtime> list = plotEnvRealtimeService.selectPlotEnvRealtimeList(plotEnvRealtime);
        return getDataTable(list);
    }

    /**
     * 导出片区环境实时数据列表
     */
    @PreAuthorize("@ss.hasPermi('plot:realtime:export')")
    @Log(title = "片区环境实时数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PlotEnvRealtime plotEnvRealtime)
    {
        List<PlotEnvRealtime> list = plotEnvRealtimeService.selectPlotEnvRealtimeList(plotEnvRealtime);
        ExcelUtil<PlotEnvRealtime> util = new ExcelUtil<PlotEnvRealtime>(PlotEnvRealtime.class);
        util.exportExcel(response, list, "片区环境实时数据数据");
    }

    /**
     * 获取片区环境实时数据详细信息
     */
    @PreAuthorize("@ss.hasPermi('plot:realtime:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(plotEnvRealtimeService.selectPlotEnvRealtimeById(id));
    }

    /**
     * 新增片区环境实时数据
     */
    @PreAuthorize("@ss.hasPermi('plot:realtime:add')")
    @Log(title = "片区环境实时数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlotEnvRealtime plotEnvRealtime)
    {
        return plotEnvRealtimeService.insertPlotEnvRealtime(plotEnvRealtime);
    }

    /**
     * 修改片区环境实时数据
     */
    @PreAuthorize("@ss.hasPermi('plot:realtime:edit')")
    @Log(title = "片区环境实时数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlotEnvRealtime plotEnvRealtime)
    {
        return plotEnvRealtimeService.updatePlotEnvRealtime(plotEnvRealtime);
    }

    /**
     * 删除片区环境实时数据
     */
    @PreAuthorize("@ss.hasPermi('plot:realtime:remove')")
    @Log(title = "片区环境实时数据", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(plotEnvRealtimeService.deletePlotEnvRealtimeByIds(ids));
    }
}
