package com.agriSmart.crop.controller;

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
import com.agriSmart.crop.domain.Variety;
import com.agriSmart.crop.service.IVarietyService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 农作物品种Controller
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@RestController
@RequestMapping("/crop/variety")
public class VarietyController extends BaseController
{
    @Autowired
    private IVarietyService varietyService;

    /**
     * 查询农作物品种列表
     */
    @PreAuthorize("@ss.hasPermi('crop:variety:list')")
    @GetMapping("/list")
    public TableDataInfo list(Variety variety)
    {
        startPage();
        List<Variety> list = varietyService.selectVarietyList(variety);
        return getDataTable(list);
    }

    /**
     * 导出农作物品种列表
     */
    @PreAuthorize("@ss.hasPermi('crop:variety:export')")
    @Log(title = "农作物品种", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Variety variety)
    {
        List<Variety> list = varietyService.selectVarietyList(variety);
        ExcelUtil<Variety> util = new ExcelUtil<Variety>(Variety.class);
        util.exportExcel(response, list, "农作物品种数据");
    }

    /**
     * 获取农作物品种详细信息
     */
    @PreAuthorize("@ss.hasPermi('crop:variety:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(varietyService.selectVarietyById(id));
    }

    /**
     * 新增农作物品种
     */
    @PreAuthorize("@ss.hasPermi('crop:variety:add')")
    @Log(title = "农作物品种", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Variety variety)
    {
        return toAjax(varietyService.insertVariety(variety));
    }

    /**
     * 修改农作物品种
     */
    @PreAuthorize("@ss.hasPermi('crop:variety:edit')")
    @Log(title = "农作物品种", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Variety variety)
    {
        return toAjax(varietyService.updateVariety(variety));
    }

    /**
     * 删除农作物品种
     */
    @PreAuthorize("@ss.hasPermi('crop:variety:remove')")
    @Log(title = "农作物品种", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(varietyService.deleteVarietyByIds(ids));
    }
}
