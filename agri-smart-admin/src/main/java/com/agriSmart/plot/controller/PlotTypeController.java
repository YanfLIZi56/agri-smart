package com.agriSmart.plot.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
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
import com.agriSmart.plot.domain.PlotType;
import com.agriSmart.plot.service.IPlotTypeService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 片区类型Controller
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@RestController
@RequestMapping("/plot/type")
public class PlotTypeController extends BaseController
{
    @Autowired
    private IPlotTypeService plotTypeService;

    /**
     * 查询片区类型列表
     */
    @PreAuthorize("@ss.hasPermi('plot:type:list')")
    @GetMapping("/list")
    public TableDataInfo list(PlotType plotType)
    {
        startPage();
        List<PlotType> list = plotTypeService.selectPlotTypeList(plotType);
        return getDataTable(list);
    }

    /**
     * 导出片区类型列表
     */
    @PreAuthorize("@ss.hasPermi('plot:type:export')")
    @Log(title = "片区类型", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, PlotType plotType)
    {
        List<PlotType> list = plotTypeService.selectPlotTypeList(plotType);
        ExcelUtil<PlotType> util = new ExcelUtil<PlotType>(PlotType.class);
        util.exportExcel(response, list, "片区类型数据");
    }

    /**
     * 获取片区类型详细信息
     */
    @PreAuthorize("@ss.hasPermi('plot:type:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(plotTypeService.selectPlotTypeById(id));
    }

    /**
     * 新增片区类型
     */
    @PreAuthorize("@ss.hasPermi('plot:type:add')")
    @Log(title = "片区类型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody PlotType plotType)
    {
        return toAjax(plotTypeService.insertPlotType(plotType));
    }

    /**
     * 修改片区类型
     */
    @PreAuthorize("@ss.hasPermi('plot:type:edit')")
    @Log(title = "片区类型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody PlotType plotType)
    {
        return toAjax(plotTypeService.updatePlotType(plotType));
    }

    /**
     * 删除片区类型
     */
    @PreAuthorize("@ss.hasPermi('plot:type:remove')")
    @Log(title = "片区类型", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(plotTypeService.deletePlotTypeByIds(ids));
    }
}
