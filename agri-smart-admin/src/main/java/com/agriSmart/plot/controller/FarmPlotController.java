package com.agriSmart.plot.controller;

import java.util.List;

import com.agriSmart.common.core.domain.entity.SysUser;
import com.agriSmart.system.service.ISysUserService;
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
import com.agriSmart.plot.domain.FarmPlot;
import com.agriSmart.plot.service.IFarmPlotService;
import com.agriSmart.common.utils.poi.ExcelUtil;
import com.agriSmart.common.core.page.TableDataInfo;

import static com.agriSmart.constant.RoleConstant.PLOT_MANAGER_ID;

/**
 * 片区信息Controller
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@RestController
@RequestMapping("/plot/plot")
public class FarmPlotController extends BaseController
{
    @Autowired
    private IFarmPlotService farmPlotService;
    @Autowired
    private ISysUserService userService;

    /**
     * 查询片区信息列表
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:list')")
    @GetMapping("/list")
    public TableDataInfo list(FarmPlot farmPlot)
    {
        startPage();
        List<FarmPlot> list = farmPlotService.selectFarmPlotList(farmPlot);
        return getDataTable(list);
    }

    /**
     * 导出片区信息列表
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:export')")
    @Log(title = "片区信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, FarmPlot farmPlot)
    {
        List<FarmPlot> list = farmPlotService.selectFarmPlotList(farmPlot);
        ExcelUtil<FarmPlot> util = new ExcelUtil<FarmPlot>(FarmPlot.class);
        util.exportExcel(response, list, "片区信息数据");
    }

    /**
     * 获取片区信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(farmPlotService.selectFarmPlotById(id));
    }

    /**
     * 获取片区信息详细信息包含环境信息
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:query')")
    @GetMapping(value = "/env/{id}")
    public AjaxResult getInfoAndEnv(@PathVariable("id") Long id)
    {
        return success(farmPlotService.selectFarmPlotAndEnvById(id));
    }


    /**
     * 新增片区信息
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:add')")
    @Log(title = "片区信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody FarmPlot farmPlot)
    {
        return toAjax(farmPlotService.insertFarmPlot(farmPlot));
    }

    /**
     * 修改片区信息
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:edit')")
    @Log(title = "片区信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody FarmPlot farmPlot)
    {
        return farmPlotService.updateFarmPlot(farmPlot);
    }

    /**
     * 删除片区信息
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:remove')")
    @Log(title = "片区信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(farmPlotService.deleteFarmPlotByIds(ids));
    }

    /**
     * 片区管理者远程搜索
     */
    @PreAuthorize("@ss.hasPermi('plot:plot:list')")
    @GetMapping("/remote/user")
    public TableDataInfo userByRole(SysUser user)
    {
        startPage();
        user.setRoleId(PLOT_MANAGER_ID);
        List<SysUser> list = userService.selectAllocatedList(user);
        return getDataTable(list);
    }
}
