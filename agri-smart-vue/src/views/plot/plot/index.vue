<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="片区名称" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入片区名称" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="管理者" prop="managerId">
        <el-select v-model="queryParams.managerId" clearable @keyup.enter="handleQuery" filterable remote
          reserve-keyword placeholder="请输入管理者进行搜索" :remote-method="remoteMethod" :loading="managerLoading"
          style="width: 260px">
          <el-option v-for="item in managerOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="片区类型" prop="plotTypeId">
        <el-select v-model="queryParams.plotTypeId" placeholder="请选择片区类型" clearable>
          <el-option v-for="item in typeOptions" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in plot_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['plot:plot:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['plot:plot:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['plot:plot:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['plot:plot:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="plotList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="片区ID" align="center" prop="id" />
      <el-table-column label="片区名称" align="center" prop="name" />
      <el-table-column label="地理位置" align="center" prop="location" />
      <el-table-column label="面积(公顷ha/hm^2)" align="center" prop="area" />
      <el-table-column label="管理者" align="center" prop="managerName" />
      <el-table-column label="片区类型" align="center" prop="plotType" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="plot_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['plot:plot:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['plot:plot:remove']">删除</el-button>
          <el-button link type="primary" icon="View" @click="handleDetail(scope.row)"
            v-hasPermi="['plot:plot:query']">详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改片区信息对话框 -->
    <el-dialog :title="title" v-model="open" width="700px" append-to-body>
      <el-form ref="plotRef" :model="form" :rules="rules" label-width="150px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="片区名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入片区名称" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="地理位置" prop="location">
              <el-input v-model="form.location" placeholder="请输入地理位置" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="面积" prop="area">
              <el-input v-model="form.area" placeholder="请输入面积(公顷ha/hm^2)">
                <template #append>公顷(ha/hm^2)</template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="管理者" prop="managerId">
              <el-select v-model="form.managerId" clearable filterable remote reserve-keyword placeholder="请输入管理者进行搜索"
                :remote-method="remoteMethod" :loading="managerLoading" style="width: 260px">
                <el-option v-for="item in managerOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="片区类型" prop="plotTypeId">
              <el-select v-model="form.plotTypeId" placeholder="请选择片区类型">
                <el-option v-for="item in typeOptions" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in plot_status" :key="dict.value" :label="parseInt(dict.value)">{{ dict.label
                }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>

          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="center">片区与农作物关联信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="Plus" @click="handleAddPlotCrop">添加</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="Delete" @click="handleDeletePlotCrop">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="plotCropList" @selection-change="handlePlotCropSelectionChange" ref="plotCrop">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" width="60">
            <template #default="{ $index }">
              {{ $index + 1 }}
            </template>
          </el-table-column>
          <el-table-column label="农作物" prop="cropName" width="200">
            <template #default="scope">
              <el-input v-model="scope.row.cropName" placeholder="请输入农作物" disabled>
                <template #append>
                  <el-button @click="handleOpen(scope.$index)">选择</el-button>
                </template>
              </el-input>
            </template>
          </el-table-column>
          <el-table-column label="农作物类型" prop="cropType" />
          <el-table-column label="农作物标签" prop="cropAlias" />

          <el-table-column label="数量" prop="nums" width="100">
            <template #default="scope">
              <el-input v-model="scope.row.nums" placeholder="请输入数量" />
            </template>
          </el-table-column>
        </el-table>

        <el-divider content-position="center">片区经纬度坐标</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="Plus" @click="handleAddCoordinate">添加坐标点</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="Delete" @click="handleDeleteCoordinate">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="coordinates" @selection-change="handleCoordinateSelectionChange" ref="coordinate">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" width="80" align="center">
            <template #default="{ $index }">
              {{ $index + 1 }}
            </template>
          </el-table-column>
          <el-table-column label="经度(lng)" prop="lng">
            <template #default="scope">
              <el-input-number v-model="scope.row.lng" :precision="6" :min="-180" :max="180" placeholder="经度"
                controls-position="right" style="width: 100%" />
            </template>
          </el-table-column>
          <el-table-column label="纬度(lat)" prop="lat">
            <template #default="scope">
              <el-input-number v-model="scope.row.lat" :precision="6" :min="-90" :max="90" placeholder="纬度"
                controls-position="right" style="width: 100%" />
            </template>
          </el-table-column>
        </el-table>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <CropSelect :open="cropSelectOpen" :cropStatus="normalCrop" @close="cropSelectOpen = false"
      @select="handleCropSelect" />

    <PlotDetail :open="plotDetailOpen" :data="plotEnv" @close="plotDetailOpen = false" />

  </div>
</template>

<script setup name="Plot">
import { listPlot, getPlot, delPlot, addPlot, updatePlot, getPlotDetail, remoteUserList } from "@/api/plot/plot"
import { allPlotType } from "@/api/plot/type"
import CropSelect from "@/views/components/crop.vue"
import PlotDetail from "@/views/components/plotDetail.vue"
import { polygon, area } from '@turf/turf';

const { proxy } = getCurrentInstance()
const { plot_status } = proxy.useDict('plot_status')

const plotList = ref([])
const typeOptions = ref([])
const managerOptions = ref([])
const plotCropList = ref([])
const open = ref(false)
const cropSelectOpen = ref(false)
const plotDetailOpen = ref(false)
const loading = ref(true)
const managerLoading = ref(false)
const showSearch = ref(true)
const ids = ref([])
const checkedPlotCrop = ref([])
const checkedCoordinate = ref([])
const coordinates = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const currentCropIndex = ref(-1)
const normalCrop = ref(0)
const plotEnv = ref({})


const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    managerId: null,
    plotTypeId: null,
    status: null,
  },
  rules: {
    name: [
      { required: true, message: "片区名称不能为空", trigger: "blur" }
    ],
    location: [
      { required: true, message: "地理位置不能为空", trigger: "blur" }
    ],
    area: [
      { required: true, message: "面积不能为空", trigger: "blur" }
    ],
    plotTypeId: [
      { required: true, message: "片区类型(plot_type.id)不能为空", trigger: "blur" }
    ],
    status: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
    nums: [
      { required: true, message: "数量不能为空", trigger: "blur" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询片区信息列表 */
function getList() {
  loading.value = true
  listPlot(queryParams.value).then(response => {
    plotList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

// 取消按钮
function cancel() {
  open.value = false
  reset()
}

// 表单重置
function reset() {
  form.value = {
    id: null,
    name: null,
    location: null,
    area: null,
    managerId: null,
    plotTypeId: null,
    status: null,
    remark: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null,
  }
  plotCropList.value = []
  coordinates.value = []
  proxy.resetForm("plotRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

// 多选框选中数据
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加片区信息"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getPlot(_id).then(response => {
    form.value = response.data
    if (form.value.managerId) {
      managerOptions.value = [{
        value: form.value.managerId,
        label: form.value.managerName
      }]
    }
    plotCropList.value = response.data.plotCropList
    coordinates.value = response.data.coordinates || []
    open.value = true
    title.value = "修改片区信息"
  })
}

/** 提交按钮 */
function submitForm() {
  // 先验证主表单
  proxy.$refs["plotRef"].validate(valid => {
    if (valid) {
      // 验证plotCropList中的数量字段
      const hasEmptyNums = plotCropList.value.some(item => !item.nums)
      if (hasEmptyNums) {
        proxy.$modal.msgError("请填写所有农作物的数量")
        return
      }

      // 处理坐标数据
      const result = processCoordinates(coordinates.value)
      form.value.coordinates = result.coordinates
      if (result.area > 0) {
        form.value.area = result.area
      }

      form.value.plotCropList = plotCropList.value
      if (form.value.id != null) {
        updatePlot(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addPlot(form.value).then(() => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 删除按钮操作 */
function handleDelete(row) {
  const _ids = row.id || ids.value
  proxy.$modal.confirm('是否确认删除片区信息编号为"' + _ids + '"的数据项？').then(function () {
    return delPlot(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 片区与农作物关联添加按钮操作 */
function handleAddPlotCrop() {
  let obj = {}
  obj.cropId = ""
  obj.nums = ""
  plotCropList.value.push(obj)
}

/** 经纬度坐标添加按钮操作 */
function handleAddCoordinate() {
  coordinates.value.push({ id: null, lng: null, lat: null, plotId: null })
}

/** 经纬度坐标删除按钮操作 */
function handleDeleteCoordinate() {
  if (checkedCoordinate.value.length == 0) {
    proxy.$modal.msgError("请先选择要删除的坐标点")
  } else {
    coordinates.value = coordinates.value.filter((item, index) => {
      return !checkedCoordinate.value.includes(index)
    })
  }
}

/** 经纬度坐标复选框选中数据 */
function handleCoordinateSelectionChange(selection) {
  checkedCoordinate.value = selection.map((item, index) => index)
}

/** 片区与农作物关联删除按钮操作 */
function handleDeletePlotCrop() {
  if (checkedPlotCrop.value.length == 0) {
    proxy.$modal.msgError("请先选择要删除的片区与农作物关联数据")
  } else {
    const plotCrops = plotCropList.value
    const checkedPlotCrops = checkedPlotCrop.value
    plotCropList.value = plotCrops.filter(function (item) {
      return checkedPlotCrops.indexOf(item.index) == -1
    })
  }
}

/** 复选框选中数据 */
function handlePlotCropSelectionChange(selection) {
  checkedPlotCrop.value = selection.map(item => item.index)
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('plot/plot/export', {
    ...queryParams.value
  }, `plot_${new Date().getTime()}.xlsx`)
}

getList()
allPlotType().then(response => {
  typeOptions.value = response.rows
})

const remoteMethod = (query) => {
  // 有搜索关键词才请求
  if (query) {
    managerLoading.value = true
    remoteUserList({ pageNum: 1, pageSize: 20, userName: query }).then(response => {
      managerOptions.value = response.rows.map(user => ({
        value: user.userId,
        label: user.userName
      }))
    }).finally(() => {
      managerLoading.value = false
    })
  } else {
    // 无关键词时清空选项
    managerOptions.value = []
  }
}

const handleOpen = (index) => {
  if (index == null) {
    proxy.$modal.msgError("请选择先添加片区与农作物关联数据")
    return
  }
  currentCropIndex.value = index
  cropSelectOpen.value = true

}

const handleCropSelect = (crop) => {
  if (crop) {
    plotCropList.value[currentCropIndex.value].cropId = crop.id
    plotCropList.value[currentCropIndex.value].cropName = crop.name
    plotCropList.value[currentCropIndex.value].nums = ""
    plotCropList.value[currentCropIndex.value].cropType = crop.varietyName
    plotCropList.value[currentCropIndex.value].cropAlias = crop.alias
    cropSelectOpen.value = false
  }
}

const handleDetail = (row) => {
  getPlotDetail(row.id).then(response => {
    plotEnv.value = response.data
    plotCropList.value = response.data.plotCropList

    if (plotEnv.value.plotTypeId) {
      plotEnv.value.plotType = typeOptions.value.find(item => item.id === plotEnv.value.plotTypeId)?.name || '暂无类型'
    }
    plotDetailOpen.value = true
  })
}

function ensureCounterClockwise(ring) {
  // 1. 计算中心点
  const center = ring.reduce((acc, point) => {
    return [acc[0] + point[0], acc[1] + point[1]]
  }, [0, 0])
  center[0] /= ring.length
  center[1] /= ring.length

  // 2. 按相对于中心点的角度排序
  const sortedRing = [...ring].sort((a, b) => {
    const angleA = Math.atan2(a[1] - center[1], a[0] - center[0])
    const angleB = Math.atan2(b[1] - center[1], b[0] - center[0])
    return angleA - angleB
  })

  return sortedRing
}

/**
 * 处理坐标数据，转换为 GeoJSON 标准格式并计算面积
 * @param {Array} coordinates - 坐标数组，格式：[{lng, lat, id, plotId}, ...]
 * @returns {Object} { coordinates: 处理后的坐标数组, area: 计算的面积(公顷) }
 */
function processCoordinates(coordinates) {
  // 如果坐标点少于3个，直接返回
  if (!coordinates || coordinates.length < 3) {
    return { coordinates: coordinates || [], area: 0 }
  }

  // 将坐标转换为 GeoJSON 格式
  let geoJsonCoords = coordinates.map(coord => [coord.lng, coord.lat])

  // 第一步：确保坐标有序环绕（逆时针方向）
  geoJsonCoords = ensureCounterClockwise(geoJsonCoords)

  // 第二步：确保多边形闭合（最后一个点等于第一个点）
  if (geoJsonCoords[0][0] !== geoJsonCoords[geoJsonCoords.length - 1][0] ||
    geoJsonCoords[0][1] !== geoJsonCoords[geoJsonCoords.length - 1][1]) {
    geoJsonCoords.push([geoJsonCoords[0][0], geoJsonCoords[0][1]])
  }

  // 计算面积
  const calculatedArea = area(polygon([geoJsonCoords]))
  console.log(calculatedArea)
  let areaHectares = 0
  if (calculatedArea > 0) {
    areaHectares = calculatedArea / 10000 // 转换为公顷
    areaHectares = Math.ceil(areaHectares * 100) / 100 // 保留两位小数并向上取整
  }

  // 将处理后的坐标转换回原始结构
  const processedCoords = geoJsonCoords.slice(0, -1).map((coord, index) => ({
    id: coordinates[index]?.id || null,
    lng: coord[0],
    lat: coord[1],
    plotId: coordinates[index]?.plotId || null
  }))

  return { coordinates: processedCoords, area: areaHectares }
}
</script>