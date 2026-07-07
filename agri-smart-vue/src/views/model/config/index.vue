<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="模型名称" prop="modelName">
        <el-input v-model="queryParams.modelName" placeholder="请输入模型名称" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="模型类型" prop="modelType">
        <el-select v-model="queryParams.modelType" placeholder="请选择模型类型" clearable>
          <el-option v-for="dict in model_type" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="isActive">
        <el-select v-model="queryParams.isActive" placeholder="请选择状态" clearable>
          <el-option v-for="dict in model_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="ZoomIn" @click="handleScan"
          v-hasPermi="['model:config:query']">扫描模型</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['model:config:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['model:config:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['model:config:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="configList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="ID" align="center" prop="id" />
      <el-table-column label="模型显示名称" align="center" prop="modelName" />
      <el-table-column label="模型类型" align="center" prop="modelType">
        <template #default="scope">
          <dict-tag :options="model_type" :value="scope.row.modelType" />
        </template>
      </el-table-column>
      <el-table-column label="版本号" align="center" prop="version" />
      <el-table-column label="模型文件" align="center" prop="filePath" />
      <el-table-column label="模型大小" align="center" prop="modelSize" />
      <el-table-column label="状态" align="center" prop="isActive">
        <template #default="scope">
          <dict-tag :options="model_status" :value="scope.row.isActive" />
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['model:config:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['model:config:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改模型配置对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="configRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="模型名称" prop="modelName">
              <el-input v-model="form.modelName" placeholder="请输入模型名称" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="模型类型" prop="modelType">
              <el-select v-model="form.modelType" placeholder="请选择模型类型">
                <el-option v-for="dict in model_type" :key="dict.value" :label="dict.label"
                  :value="parseInt(dict.value)"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="版本号" prop="version">
              <el-input v-model="form.version" placeholder="请输入版本号" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="模型文件" prop="filePath">
              <el-input v-model="form.filePath" placeholder="请输入模型文件" readonly disabled />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="模型大小" prop="modelSize">
              <el-input v-model="form.modelSize" placeholder="请输入模型大小" readonly disabled />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态" prop="isActive">
              <el-radio-group v-model="form.isActive">
                <el-radio v-for="dict in model_status" :key="dict.value" :label="parseInt(dict.value)">{{ dict.label
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
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog title="扫描新模型结果" v-model="scanOpen" width="800px" append-to-body>
      <el-table :data="scanList" ref="scanTable">
        <el-table-column label="序号" width="60">
          <template #default="{ $index }">
            {{ $index + 1 }}
          </template>
        </el-table-column>
        <el-table-column label="模型名称" prop="modelName" width="150">
          <template #default="scope">
            <el-input v-model="scope.row.modelName" placeholder="请输入模型名称" />
          </template>
        </el-table-column>
        <el-table-column label="版本号" prop="version" width="150">
          <template #default="scope">
            <el-input v-model="scope.row.version" placeholder="请输入版本号" />
          </template>
        </el-table-column>
        <el-table-column label="模型类型" prop="modelType" width="170">
          <template #default="scope">
            <el-select v-model="scope.row.modelType" placeholder="请选择模型类型">
              <el-option v-for="dict in model_type" :key="dict.value" :label="dict.label"
                :value="parseInt(dict.value)"></el-option>
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="模型文件" prop="filePath" />
        <el-table-column label="模型大小" prop="modelSize" />
      </el-table>
      <div class="scan-tip">
        <el-icon class="tip-icon">
          <InfoFilled />
        </el-icon>
        <span>将模型文件(.pt 或 .onnx)移动至服务器目录:
          <span style="color: #409eff;">{{ serverPath }}</span>
          , 即可扫描到模型文件</span>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitAdd">添 加</el-button>
          <el-button @click="scanOpen = false; scanList = [];">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Config">
import { listConfig, getConfig, delConfig, addBatchConfig, updateConfig, scanModel, getServerPath } from "@/api/model/config"

const { proxy } = getCurrentInstance()
const { model_type, model_status } = proxy.useDict('model_type', 'model_status')

const configList = ref([])
const scanList = ref([])
const open = ref(false)
const scanOpen = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const serverPath = ref("")

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    modelName: null,
    modelType: null,
    isActive: null,
  },
  rules: {
    modelName: [
      { required: true, message: "模型显示名称不能为空", trigger: "blur" }
    ],
    modelType: [
      { required: true, message: "模型类型不能为空", trigger: "change" }
    ],
    filePath: [
      { required: true, message: "模型文件路径不能为空", trigger: "blur" }
    ],
    modelSize: [
      { required: true, message: "模型大小不能为空", trigger: "blur" }
    ],
    isActive: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询模型配置列表 */
function getList() {
  loading.value = true
  listConfig(queryParams.value).then(response => {
    configList.value = response.rows
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
    modelName: null,
    modelType: null,
    version: null,
    filePath: null,
    modelSize: null,
    isActive: null,
    remark: null,
    createTime: null,
    updateTime: null
  }
  proxy.resetForm("configRef")
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
  title.value = "添加模型配置"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getConfig(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改模型配置"
  })
}

const handleScan = () => {
  scanModel().then(response => {
    console.log(response.data);
    scanList.value = response.data
    scanOpen.value = true
  })
}

const submitAdd = () => {
  // 校验scanList中的每个模型
  let isValid = true
  let errorMessage = ''

  for (let i = 0; i < scanList.value.length; i++) {
    const model = scanList.value[i]
    // 校验模型名称
    if (!model.modelName || model.modelName.trim() === '') {
      isValid = false
      errorMessage = `第${i + 1}行：模型名称不能为空`
      break
    }
    // 校验模型类型
    if (model.modelType === null) {
      isValid = false
      errorMessage = `第${i + 1}行：模型类型不能为空`
      break
    }
  }
  if (!isValid) {
    proxy.$modal.msgError(errorMessage)
    return
  }
  console.log(scanList.value);

  // 提交数据
  addBatchConfig(scanList.value).then(() => {
    proxy.$modal.msgSuccess("添加成功")
    scanOpen.value = false
    scanList.value = []
    getList()
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["configRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateConfig(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
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
  proxy.$modal.confirm('是否确认删除模型配置编号为"' + _ids + '"的数据项？').then(function () {
    return delConfig(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('model/config/export', {
    ...queryParams.value
  }, `config_${new Date().getTime()}.xlsx`)
}

getList()
getServerPath().then(response => {
  serverPath.value = response.msg
})
</script>

<style scoped>
.scan-tip {
  margin-top: 16px;
  padding: 12px;
  background-color: #f5f7fa;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  display: flex;
  align-items: center;
  color: #606266;
  font-size: 14px;
}

.tip-icon {
  margin-right: 8px;
  color: #909399;
}
</style>