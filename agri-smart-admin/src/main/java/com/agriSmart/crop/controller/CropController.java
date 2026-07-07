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
import com.agriSmart.crop.domain.Crop;
import com.agriSmart.crop.service.ICropService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 农作物信息Controller
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@RestController
@RequestMapping("/crop/crop")
public class CropController extends BaseController
{
    @Autowired
    private ICropService cropService;

    /**
     * 查询农作物信息列表
     */
    @PreAuthorize("@ss.hasPermi('crop:crop:list')")
    @GetMapping("/list")
    public TableDataInfo list(Crop crop)
    {
        startPage();
        List<Crop> list = cropService.selectCropList(crop);
        return getDataTable(list);
    }

    /**
     * 导出农作物信息列表
     */
    @PreAuthorize("@ss.hasPermi('crop:crop:export')")
    @Log(title = "农作物信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Crop crop)
    {
        List<Crop> list = cropService.selectCropList(crop);
        ExcelUtil<Crop> util = new ExcelUtil<Crop>(Crop.class);
        util.exportExcel(response, list, "农作物信息数据");
    }

    /**
     * 获取农作物信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('crop:crop:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(cropService.selectCropById(id));
    }

    /**
     * 新增农作物信息
     */
    @PreAuthorize("@ss.hasPermi('crop:crop:add')")
    @Log(title = "农作物信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Crop crop)
    {
        return toAjax(cropService.insertCrop(crop));
    }

    /**
     * 修改农作物信息
     */
    @PreAuthorize("@ss.hasPermi('crop:crop:edit')")
    @Log(title = "农作物信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Crop crop)
    {
        return toAjax(cropService.updateCrop(crop));
    }

    /**
     * 删除农作物信息
     */
    @PreAuthorize("@ss.hasPermi('crop:crop:remove')")
    @Log(title = "农作物信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(cropService.deleteCropByIds(ids));
    }
}
