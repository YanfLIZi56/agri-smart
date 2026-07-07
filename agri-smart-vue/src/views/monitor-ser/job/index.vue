<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="监控ID" prop="monitorId">
        <el-input v-model="queryParams.monitorId" placeholder="请输入监控ID" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="模型ID" prop="modelConfigId">
        <el-input v-model="queryParams.modelConfigId" placeholder="请输入模型ID" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in monitor_job_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="开始时间" style="width: 308px">
        <el-date-picker v-model="daterangeCreateTime" value-format="YYYY-MM-DD" type="daterange" range-separator="-"
          start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item label="结束时间" style="width: 308px">
        <el-date-picker v-model="daterangeEndTime" value-format="YYYY-MM-DD" type="daterange" range-separator="-"
          start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['monitor:job:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['monitor:job:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['monitor:job:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="jobList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" />
      <!-- <el-table-column label="监控ID" align="center" prop="monitorId" /> -->
      <el-table-column label="监控名称" align="center" prop="monitorName" />
      <el-table-column label="监控类型" align="center" prop="monitorType" />
      <!-- <el-table-column label="模型ID" align="center" prop="modelConfigId" /> -->
      <el-table-column label="使用模型" align="center" width="200">
        <template #default="scope">
          <span>{{ scope.row.modelName }}:{{ scope.row.modelVersion }} {{
            getModelStatus(scope.row.modelConfigIsActive, scope.row.modelConfigIsDel) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="持续时间(秒)" align="center" prop="duration" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="monitor_job_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="开始时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" align="center" prop="endTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.endTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button v-if="scope.row.status == 1" link type="danger" icon="SwitchButton" @click="handleEnd(scope.row)"
            v-hasPermi="['monitor:job:edit']">结束任务</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['monitor:job:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改监控任务对话框 -->
    <el-dialog :title="title" v-model="open" width="520px" append-to-body>
      <el-form ref="jobRef" :model="form" :rules="rules" label-width="120px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="监控" prop="monitorName">
              <el-input v-model="form.monitorName" placeholder="请输入监控名称" disabled>
                <template #append>
                  <el-button @click="monitorOpen = true">选择监控</el-button>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="模型" prop="modelConfigId">
              <el-select v-model="form.modelConfigId" clearable filterable remote reserve-keyword
                placeholder="请输入模型进行搜索" :remote-method="remoteMethodModel" style="width: 260px">
                <el-option v-for="item in modelList" :key="item.id" :label="item.modelName + ':' + item.version"
                  :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="持续时间(秒)" prop="duration">
              <el-input v-model="form.duration" placeholder="请输入持续时间(秒)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
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

    <monitorSelect :open="monitorOpen" @select="handleSelectMonitor" @close="monitorOpen = false" />
  </div>
</template>

<script setup name="Job">
import { listJob, getJob, delJob, addJob, updateJob, endJob } from "@/api/monitor-ser/job"
import { remoteModelConfigList } from '@/api/model/config'
import monitorSelect from "@/views/components/monitorSelect.vue"

const { proxy } = getCurrentInstance()
const { monitor_job_status } = proxy.useDict('monitor_job_status')

const jobList = ref([])
const open = ref(false)
const monitorOpen = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const daterangeCreateTime = ref([])
const daterangeEndTime = ref([])

// 模型列表
const modelList = ref([])

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    monitorId: null,
    modelConfigId: null,
    status: null,
    createTime: null,
    endTime: null,
  },
  rules: {
    monitorId: [
      { required: true, message: "监控ID不能为空", trigger: "blur" }
    ],
    modelConfigId: [
      { required: true, message: "模型ID不能为空", trigger: "blur" }
    ],
    duration: [
      { required: true, message: "持续时间(秒)不能为空", trigger: "blur" }
    ],
    status: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询监控任务列表 */
function getList() {
  loading.value = true
  queryParams.value.params = {}
  if (null != daterangeCreateTime.value && '' != daterangeCreateTime.value) {
    queryParams.value.params["beginCreateTime"] = daterangeCreateTime.value[0]
    queryParams.value.params["endCreateTime"] = daterangeCreateTime.value[1]
  }
  if (null != daterangeEndTime.value && '' != daterangeEndTime.value) {
    queryParams.value.params["beginEndTime"] = daterangeEndTime.value[0]
    queryParams.value.params["endEndTime"] = daterangeEndTime.value[1]
  }
  listJob(queryParams.value).then(response => {
    jobList.value = response.rows
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
    monitorId: null,
    modelConfigId: null,
    duration: null,
    status: null,
    createTime: null,
    updateTime: null,
    endTime: null,
    remark: null
  }
  proxy.resetForm("jobRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 模型状态 */
function getModelStatus(active, del) {
  if (!active) return " [停用]"
  if (del) return " [删除]"
  return ""
}

/** 重置按钮操作 */
function resetQuery() {
  daterangeCreateTime.value = []
  daterangeEndTime.value = []
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
  title.value = "添加监控任务"
}

/** 结束任务按钮操作 */
function handleEnd(row) {
  const monitorId = row.monitorId
  const jobId = row.id
  proxy.$modal.confirm('是否确认结束监控任务编号为"' + jobId + '"的数据项？').then(function () {
    return endJob(monitorId)
  }).then(() => {
    proxy.$modal.msgSuccess("结束成功")
    getList()
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["jobRef"].validate(valid => {
    if (valid) {
      if (form.value.id == null) {
        addJob(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除监控任务编号为"' + _ids + '"的数据项？').then(function () {
    return delJob(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('monitor/job/export', {
    ...queryParams.value
  }, `job_${new Date().getTime()}.xlsx`)
}

// 远程搜索模型
function remoteMethodModel(query) {
  remoteModelConfigList({
    pageNum: 1,
    pageSize: 20,
    modelName: query,
    isActive: 1,
    isDelete: 0,
  }).then((res) => {
    modelList.value = res.rows
  })
}

function handleSelectMonitor(monitor) {
  form.value.monitorId = monitor.id
  form.value.monitorName = monitor.name
  console.log(monitor)
}

getList()
</script>
