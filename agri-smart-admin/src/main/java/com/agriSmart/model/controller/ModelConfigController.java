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
import com.agriSmart.model.domain.ModelConfig;
import com.agriSmart.model.service.IModelConfigService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

/**
 * 模型配置Controller
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@RestController
@RequestMapping("/model/config")
public class ModelConfigController extends BaseController
{
    @Autowired
    private IModelConfigService modelConfigService;

    /**
     * 查询模型配置列表
     */
    @PreAuthorize("@ss.hasPermi('model:config:list')")
    @GetMapping("/list")
    public TableDataInfo list(ModelConfig modelConfig)
    {
        startPage();
        List<ModelConfig> list = modelConfigService.selectModelConfigList(modelConfig);
        return getDataTable(list);
    }

    /**
     * 导出模型配置列表
     */
    @PreAuthorize("@ss.hasPermi('model:config:export')")
    @Log(title = "模型配置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ModelConfig modelConfig)
    {
        List<ModelConfig> list = modelConfigService.selectModelConfigList(modelConfig);
        ExcelUtil<ModelConfig> util = new ExcelUtil<ModelConfig>(ModelConfig.class);
        util.exportExcel(response, list, "模型配置数据");
    }

    /**
     * 获取模型配置详细信息
     */
    @PreAuthorize("@ss.hasPermi('model:config:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(modelConfigService.selectModelConfigById(id));
    }

    /**
     * 新增模型配置
     */
    @PreAuthorize("@ss.hasPermi('model:config:add')")
    @Log(title = "模型配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ModelConfig modelConfig)
    {
        return toAjax(modelConfigService.insertModelConfig(modelConfig));
    }

    /**
     * 修改模型配置
     */
    @PreAuthorize("@ss.hasPermi('model:config:edit')")
    @Log(title = "模型配置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ModelConfig modelConfig)
    {
        return toAjax(modelConfigService.updateModelConfig(modelConfig));
    }

    /**
     * 删除模型配置
     */
    @PreAuthorize("@ss.hasPermi('model:config:remove')")
    @Log(title = "模型配置", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(modelConfigService.deleteModelConfigByIds(ids));
    }

    /**
     * 提示模型服务器路径
     */
    @PreAuthorize("@ss.hasPermi('model:config:query')")
    @GetMapping("/server-path")
    public AjaxResult getServerPath()
    {
        return success(modelConfigService.getServerPath());
    }

    /**
     * 指定目录寻找模型
     */
    @PreAuthorize("@ss.hasPermi('model:config:query')")
    @GetMapping("/scan")
    public AjaxResult findModels()
    {
        return success(modelConfigService.findModels());
    }

    /**
     * 批量添加模型
     */
    @PreAuthorize("@ss.hasPermi('model:config:add')")
    @Log(title = "模型配置", businessType = BusinessType.INSERT)
    @PostMapping("/batch")
    public AjaxResult addBatchConfig(@RequestBody List<ModelConfig> modelConfigs)
    {
        return toAjax(modelConfigService.addBatchConfig(modelConfigs));
    }

    /**
     * 远程搜索模型配置
     */
    @PreAuthorize("@ss.hasPermi('model:config:list')")
    @GetMapping("/remote/model-config")
    public TableDataInfo remoteModelConfigList(ModelConfig modelConfig)
    {
        startPage();
        List<ModelConfig> list = modelConfigService.remoteModelConfigList(modelConfig);
        return getDataTable(list);
    }

}
