<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="监控名称" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入监控名称" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in monitor_status" :key="dict.value" :label="dict.label" :value="dict.value" />
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
          v-hasPermi="['monitor:manage:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['monitor:manage:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['monitor:manage:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['monitor:manage:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="manageList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" />
      <el-table-column label="监控名称" align="center" prop="name" />
      <el-table-column label="rtsp流地址" align="center" prop="rtspUrl" />
      <el-table-column label="型号" align="center" prop="monitorType" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="monitor_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['monitor:manage:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['monitor:manage:remove']">删除</el-button>
          <el-button v-if="scope.row.status == 0" link type="primary" icon="Plus" @click="handleAddJob(scope.row)"
            v-hasPermi="['monitor:job:add']">新增任务</el-button>
          <el-button v-if="scope.row.status != 0" link type="primary" icon="Search"
            @click="handleViewMonitor(scope.row)" v-hasPermi="['monitor:job:query']">查看监控</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改监控管理对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="manageRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="监控名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入监控名称" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="rtsp流地址" prop="rtspUrl">
              <el-input v-model="form.rtspUrl" placeholder="请输入rtsp流地址" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="型号" prop="monitorType">
              <el-input v-model="form.monitorType" placeholder="请输入型号" />
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

    <monitorJob title="新建任务" v-model="jobOpen" :monitorId="currentMonitorId" @close="handleJobClose" />

    <rtcPlayer v-model:open="videoOpen" :rtc-url="videoUrl" @close="videoOpen = false" />
  </div>
</template>

<script setup name="Manage">
import { listManage, getManage, delManage, addManage, updateManage, getManageVideoUrl } from "@/api/monitor-ser/manage"
import monitorJob from "@/views/components/monitorJob.vue"
import rtcPlayer from '@/views/components/rtc.vue'

const { proxy } = getCurrentInstance()
const { monitor_status } = proxy.useDict('monitor_status')

const videoUrl = ref('')
const manageList = ref([])
const open = ref(false)
const jobOpen = ref(false)
const currentMonitorId = ref(null)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const videoOpen = ref(false)

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    status: null,
  },
  rules: {
    name: [
      { required: true, message: "监控名称不能为空", trigger: "blur" }
    ],
    rtspUrl: [
      { required: true, message: "rtsp流地址不能为空", trigger: "blur" }
    ],
    monitorType: [
      { required: true, message: "型号不能为空", trigger: "blur" }
    ],
    status: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询监控管理列表 */
function getList() {
  loading.value = true
  listManage(queryParams.value).then(response => {
    manageList.value = response.rows
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
    rtspUrl: null,
    monitorType: null,
    status: null,
    createTime: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("manageRef")
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
  title.value = "添加监控管理"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getManage(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改监控管理"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["manageRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateManage(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addManage(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除监控管理编号为"' + _ids + '"的数据项？').then(function () {
    return delManage(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('monitor/manage/export', {
    ...queryParams.value
  }, `manage_${new Date().getTime()}.xlsx`)
}

function handleAddJob(row) {
  currentMonitorId.value = row.id
  console.log(currentMonitorId.value)
  jobOpen.value = true
}

function handleJobClose() {
  jobOpen.value = false
  currentMonitorId.value = null
}

function handleViewMonitor(row) {
  getManageVideoUrl(row.id).then(response => {
    const a = response.data.rtcUrl
    if (a == null || a === '') {
      proxy.$modal.msgError("获取视频地址失败, 请刷新或重启任务试试")
      return
    }
    videoUrl.value = a
  })
  videoOpen.value = true
}

getList()
</script>
