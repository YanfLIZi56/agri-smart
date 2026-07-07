<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="片区" prop="plotName">
        <el-input v-model="queryParams.plotName" placeholder="请输入片区" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="阈值类型" prop="alertTypeId">
        <el-select v-model="queryParams.alertTypeId" placeholder="请选择阈值类型">
          <el-option v-for="item in typeList" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['plot:realtime:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['plot:realtime:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['plot:realtime:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['plot:realtime:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="realtimeList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" />
      <el-table-column label="片区" align="center" prop="plotName" />
      <el-table-column label="实际值" align="center">
        <template #default="scope">
          <span>{{ scope.row.envValue }} {{ scope.row.unit }}</span>
        </template>
      </el-table-column>
      <el-table-column label="阈值类型" align="center" prop="alertType" />
      <el-table-column label="采集时间" align="center" prop="collectTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.collectTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['plot:realtime:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['plot:realtime:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改片区环境实时数据对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="realtimeRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="片区" prop="plotName">
              <el-input v-model="form.plotName" placeholder="请输入片区" disabled>
                <template #append>
                  <el-button @click="plotOpen = true; flag = 2">选择</el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="阈值类型" prop="alertTypeId">
              <el-select v-model="form.alertTypeId" placeholder="请选择阈值类型">
                <el-option v-for="item in typeList" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="实际值" prop="envValue">
              <el-input v-model="form.envValue" placeholder="请输入实际值" />
            </el-form-item>
          </el-col>

        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <PlotSelect :open="plotOpen" @select="handleSelectPlot" :plotStatus="normalPlotStatus" />
  </div>
</template>

<script setup name="Realtime">
import { listRealtime, getRealtime, delRealtime, addRealtime, updateRealtime } from "@/api/plot/realtime"
import { listType } from "@/api/alert/type"
import { updatePlot } from "@/api/plot/plot"
import PlotSelect from "@/views/components/plot.vue"

const { proxy } = getCurrentInstance()

const realtimeList = ref([])
const typeList = ref([])
const open = ref(false)
const plotOpen = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const normalPlotStatus = ref(1) // 正常的片区状态

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    plotName: null,
    plotId: null,
    alertTypeId: null
  },
  rules: {
    plotName: [
      { required: true, message: "片区不能为空", trigger: "change" }
    ],
    envValue: [
      { required: true, message: "实际值不能为空", trigger: "blur" }
    ],
    alertTypeId: [
      { required: true, message: "阈值类型不能为空", trigger: "change" }
    ]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询片区环境实时数据列表 */
function getList() {
  loading.value = true
  listRealtime(queryParams.value).then(response => {
    realtimeList.value = response.rows
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
    plotId: null,
    collectTime: null,
    createTime: null,
    updateTime: null,
    envValue: null,
    alertTypeId: null
  }
  proxy.resetForm("realtimeRef")
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
  title.value = "添加片区环境实时数据"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getRealtime(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改片区环境实时数据"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["realtimeRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateRealtime(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addRealtime(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除片区环境实时数据编号为"' + _ids + '"的数据项？').then(function () {
    return delRealtime(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('plot/realtime/export', {
    ...queryParams.value
  }, `realtime_${new Date().getTime()}.xlsx`)
}

/** 查询预警阈值类型列表 */
function getTypeList() {
  listType({
    enabled: 1,
    pageNum: 1,
    pageSize: 20
  }).then(response => {
    typeList.value = response.rows
  })
}

const handleSelectPlot = (row) => {
  form.value.plotId = row.id
  form.value.plotName = row.name

  plotOpen.value = false
}


getList()
getTypeList()
</script>
