<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="片区" prop="plotId">
        <el-input v-model="queryParams.plotId" placeholder="请输入片区" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="预警类型" prop="alertTypeId">
        <el-select v-model="queryParams.alertTypeId" placeholder="请选择预警类型" clearable>
          <el-option v-for="item in typeList" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="是否启用" prop="enabled">
        <el-select v-model="queryParams.enabled" placeholder="请输入是否启用" clearable>
          <el-option v-for="dict in alert_threshold_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd"
          v-hasPermi="['alert:threshold:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['alert:threshold:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['alert:threshold:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['alert:threshold:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="thresholdList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" />
      <el-table-column label="片区" align="center" prop="plotName" />
      <el-table-column label="预警类型" align="center" prop="alertType" />
      <el-table-column label="下限阈值" align="center" prop="minValue">
        <template #default="scope">
          {{ scope.row.minValue ? scope.row.minValue : '--' }} {{ scope.row.unit }}
        </template>
      </el-table-column>
      <el-table-column label="上限阈值" align="center" prop="maxValue">
        <template #default="scope">
          {{ scope.row.maxValue ? scope.row.maxValue : '--' }} {{ scope.row.unit }}
        </template>
      </el-table-column>
      <el-table-column label="是否启用" align="center" prop="enabled">
        <template #default="scope">
          <dict-tag :options="alert_threshold_status" :value="scope.row.enabled" />
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['alert:threshold:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['alert:threshold:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改预警阈值配置对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="thresholdRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="片区" prop="plotName">
              <el-input v-model="form.plotName" placeholder="请输入片区" disabled>
                <template #append>
                  <el-button @click="plotOpen = true">选择</el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="预警类型" prop="alertTypeId">
              <el-select v-model="form.alertTypeId" placeholder="请选择预警类型" clearable>
                <el-option v-for="item in typeList" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="下限阈值" prop="minValue">
              <el-input v-model="form.minValue" placeholder="请输入下限阈值" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="上限阈值" prop="maxValue">
              <el-input v-model="form.maxValue" placeholder="请输入上限阈值" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="是否启用" prop="enabled">
              <el-select v-model="form.enabled" placeholder="请输入是否启用">
                <el-option v-for="dict in alert_threshold_status" :key="dict.value" :label="dict.label"
                  :value="parseInt(dict.value)"></el-option>
              </el-select>
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

<script setup name="Threshold">
import { listThreshold, getThreshold, delThreshold, addThreshold, updateThreshold } from "@/api/alert/threshold"
import { listType } from "@/api/alert/type"
import PlotSelect from "@/views/components/plot.vue"


const { proxy } = getCurrentInstance()
const { alert_threshold_status } = proxy.useDict('alert_threshold_status')

const thresholdList = ref([])
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
    plotId: null,
    alertTypeId: null,
    enabled: null,
  },
  rules: {
    plotName: [
      { required: true, message: "片区不能为空", trigger: "change" }
    ],
    alertTypeId: [
      { required: true, message: "预警类型不能为空", trigger: "change" }
    ],
    enabled: [
      { required: true, message: "是否启用：0-停用，1-启用不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询预警阈值配置列表 */
function getList() {
  loading.value = true
  listThreshold(queryParams.value).then(response => {
    thresholdList.value = response.rows
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
    alertTypeId: null,
    minValue: null,
    maxValue: null,
    enabled: null,
    createTime: null,
    updateTime: null
  }
  proxy.resetForm("thresholdRef")
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
  title.value = "添加预警阈值配置"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getThreshold(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改预警阈值配置"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["thresholdRef"].validate(valid => {
    console.log(form.value.minValue, form.value.maxValue);
    if (valid) {
      if (form.value.minValue == null && form.value.maxValue == null) {
        proxy.$modal.msgError("下限阈值或上限阈值至少输入一个")
        return
      }
      if (form.value.minValue != null && form.value.maxValue != null && form.value.minValue >= form.value.maxValue) {
        proxy.$modal.msgError("下限阈值必须小于上限阈值")
        return
      }
      

      if (form.value.id != null) {
        updateThreshold(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addThreshold(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除预警阈值配置编号为"' + _ids + '"的数据项？').then(function () {
    return delThreshold(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('alert/threshold/export', {
    ...queryParams.value
  }, `threshold_${new Date().getTime()}.xlsx`)
}

const handleSelectPlot = (row) => {
  form.value.plotId = row.id
  form.value.plotName = row.name
  plotOpen.value = false
}

/** 查询预警阈值类型列表 */
const getTypeList = () => {
  listType().then(response => {
    typeList.value = response.rows
  })
}

getList()
getTypeList()
</script>