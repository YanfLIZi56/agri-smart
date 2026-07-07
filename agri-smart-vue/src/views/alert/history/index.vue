<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="88px">
      <el-form-item label="片区" prop="plotId">
        <el-input v-model="queryParams.plotId" placeholder="请输入片区" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="预警类型" prop="alertTypeId">
        <el-input v-model="queryParams.alertTypeId" placeholder="请输入预警类型" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="预警状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择预警状态" clearable>
          <el-option v-for="dict in alert_history_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="触发时间" style="width: 460px">
        <el-date-picker v-model="daterangeTriggerTime" value-format="YYYY-MM-DD HH:mm:ss" type="datetimerange"
          range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item label="恢复时间" style="width: 460px">
        <el-date-picker v-model="daterangeRecoveryTime" value-format="YYYY-MM-DD HH:mm:ss" type="datetimerange"
          range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['alert:history:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['alert:history:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['alert:history:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['alert:history:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="historyList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" />
      <el-table-column label="片区" align="center" prop="plotName" />
      <el-table-column label="预警类型" align="center" prop="alertType" />
      <el-table-column label="实际值" align="center" prop="triggerValue" />
      <el-table-column label="下限阈值" align="center" prop="minValue">
        <template #default="scope">
          <span>{{ scope.row.minValue ? scope.row.minValue : '--' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="上限阈值" align="center" prop="maxValue">
        <template #default="scope">
          <span>{{ scope.row.maxValue ? scope.row.maxValue : '--' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="预警状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="alert_history_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="触发时间" align="center" prop="triggerTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.triggerTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="恢复时间" align="center" prop="recoveryTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.recoveryTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="持续时长(minute)" align="center" prop="durationMinutes" width=180 />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['alert:history:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['alert:history:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改预警历史记录对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="historyRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="片区ID" prop="plotId">
              <el-input v-model="form.plotId" placeholder="请输入片区ID" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="预警类型ID" prop="alertTypeId">
              <el-input v-model="form.alertTypeId" placeholder="请输入预警类型ID" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="实际值" prop="triggerValue">
              <el-input v-model="form.triggerValue" placeholder="请输入实际值" />
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
            <el-form-item label="预警状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in alert_history_status" :key="dict.value" :label="parseInt(dict.value)">{{
                  dict.label
                }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="触发时间" prop="triggerTime">
              <el-date-picker clearable v-model="form.triggerTime" type="date" value-format="YYYY-MM-DD"
                placeholder="请选择触发时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="恢复时间" prop="recoveryTime">
              <el-date-picker clearable v-model="form.recoveryTime" type="date" value-format="YYYY-MM-DD"
                placeholder="请选择恢复时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="持续时长(minute)" prop="durationMinutes">
              <el-input v-model="form.durationMinutes" placeholder="请输入持续时长(minute)" />
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
  </div>
</template>

<script setup name="History">
import { listHistory, getHistory, delHistory, addHistory, updateHistory } from "@/api/alert/history"

const { proxy } = getCurrentInstance()
const { alert_history_status } = proxy.useDict('alert_history_status')

const historyList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const daterangeTriggerTime = ref([])
const daterangeRecoveryTime = ref([])

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    plotId: null,
    alertTypeId: null,
    status: null,
    triggerTime: null,
    recoveryTime: null,
  },
  rules: {
    plotId: [
      { required: true, message: "片区ID不能为空", trigger: "blur" }
    ],
    alertTypeId: [
      { required: true, message: "预警类型ID不能为空", trigger: "blur" }
    ],
    triggerValue: [
      { required: true, message: "实际值不能为空", trigger: "blur" }
    ],
    status: [
      { required: true, message: "预警状态不能为空", trigger: "change" }
    ],
    triggerTime: [
      { required: true, message: "触发时间不能为空", trigger: "blur" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询预警历史记录列表 */
function getList() {
  loading.value = true
  queryParams.value.params = {}
  if (null != daterangeTriggerTime.value && '' != daterangeTriggerTime.value) {
    queryParams.value.params["beginTriggerTime"] = daterangeTriggerTime.value[0]
    queryParams.value.params["endTriggerTime"] = daterangeTriggerTime.value[1]
  }
  if (null != daterangeRecoveryTime.value && '' != daterangeRecoveryTime.value) {
    queryParams.value.params["beginRecoveryTime"] = daterangeRecoveryTime.value[0]
    queryParams.value.params["endRecoveryTime"] = daterangeRecoveryTime.value[1]
  }
  listHistory(queryParams.value).then(response => {
    historyList.value = response.rows
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
    triggerValue: null,
    minValue: null,
    maxValue: null,
    status: null,
    triggerTime: null,
    recoveryTime: null,
    durationMinutes: null,
    updateTime: null,
    remark: null
  }
  proxy.resetForm("historyRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  daterangeTriggerTime.value = []
  daterangeRecoveryTime.value = []
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
  title.value = "添加预警历史记录"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getHistory(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改预警历史记录"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["historyRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateHistory(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addHistory(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除预警历史记录编号为"' + _ids + '"的数据项？').then(function () {
    return delHistory(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('alert/history/export', {
    ...queryParams.value
  }, `history_${new Date().getTime()}.xlsx`)
}

getList()
</script>
