<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="农作物" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入农作物名称" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="标签名" prop="alias">
        <el-input v-model="queryParams.alias" placeholder="请输入标签名" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="品种" prop="varietyId">
        <el-select v-model="queryParams.varietyId" placeholder="请选择品种" clearable @keyup.enter="handleQuery">
          <el-option v-for="item in varietyList" :key="item.id" :label="item.name" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option v-for="dict in crop_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="更新时间" style="width: 358px">
        <el-date-picker v-model="daterangeUpdateTime" value-format="YYYY-MM-DD" type="daterange" range-separator="-"
          start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['crop:crop:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
          v-hasPermi="['crop:crop:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
          v-hasPermi="['crop:crop:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport"
          v-hasPermi="['crop:crop:export']">导出</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="cropList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="主键" align="center" prop="id" />
      <el-table-column label="农作物名称" align="center" prop="name" />
      <el-table-column label="图片" align="center" prop="images" width="100">
        <template #default="scope">
          <image-preview :src="scope.row.images" :width="50" :height="50" />
        </template>
      </el-table-column>
      <el-table-column label="标签名" align="center" prop="alias" />
      <el-table-column label="品种" align="center" prop="varietyName" />
      <el-table-column label="状态" align="center" prop="status">
        <template #default="scope">
          <dict-tag :options="crop_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="更新时间" align="center" prop="updateTime" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.updateTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
            v-hasPermi="['crop:crop:edit']">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
            v-hasPermi="['crop:crop:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改农作物信息对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="cropRef" :model="form" :rules="rules" label-width="100px">
        <el-row>
          <el-col :span="24">
            <el-form-item label="农作物名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入农作物名称" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="标签名" prop="alias">
              <el-input v-model="form.alias" placeholder="请输入标签名(是模型标签名,不然识别不出)" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="品种" prop="varietyId">
              <el-select v-model="form.varietyId" placeholder="请选择品种" clearable @keyup.enter="handleQuery">
                <el-option v-for="item in varietyList" :key="item.id" :label="item.name" :value="item.id" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择状态">
                <el-option v-for="dict in crop_status" :key="dict.value" :label="dict.label"
                  :value="parseInt(dict.value)"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="症状描述" prop="symptoms" v-if="form.status == 1 || form.status == 2">
              <el-input v-model="form.symptoms" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="病因描述" prop="causes" v-if="form.status == 1 || form.status == 2">
              <el-input v-model="form.causes" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="防治方法" prop="prevention" v-if="form.status == 1 || form.status == 2">
              <el-input v-model="form.prevention" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>

          <el-col :span="24">
            <el-form-item label="图片" prop="images">
              <image-upload v-model="form.images" />
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

<script setup name="Crop">
import { listCrop, getCrop, delCrop, addCrop, updateCrop } from "@/api/crop/crop"
import { allVariety } from "@/api/crop/variety"
import { ElSelect } from "element-plus"

const { proxy } = getCurrentInstance()
const { crop_status } = proxy.useDict('crop_status')

const cropList = ref([])
const varietyList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const daterangeUpdateTime = ref([])

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    name: null,
    alias: null,
    varietyId: null,
    status: null,
    updateTime: null
  },
  rules: {
    name: [
      { required: true, message: "农作物名称不能为空", trigger: "blur" }
    ],
    varietyId: [
      { required: true, message: "品种不能为空", trigger: "change" }
    ],
    status: [
      { required: true, message: "状态不能为空", trigger: "change" }
    ],
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询农作物信息列表 */
function getList() {
  loading.value = true
  queryParams.value.params = {}
  if (null != daterangeUpdateTime.value && '' != daterangeUpdateTime.value) {
    queryParams.value.params["beginUpdateTime"] = daterangeUpdateTime.value[0]
    queryParams.value.params["endUpdateTime"] = daterangeUpdateTime.value[1]
  }
  listCrop(queryParams.value).then(response => {
    cropList.value = response.rows
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
    alias: null,
    symptoms: null,
    causes: null,
    prevention: null,
    varietyId: null,
    status: null,
    images: null,
    remark: null,
    createBy: null,
    createTime: null,
    updateBy: null,
    updateTime: null
  }
  proxy.resetForm("cropRef")
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  daterangeUpdateTime.value = []
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
  title.value = "添加农作物信息"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const _id = row.id || ids.value
  getCrop(_id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改农作物信息"
  })
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["cropRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateCrop(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addCrop(form.value).then(() => {
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
  proxy.$modal.confirm('是否确认删除农作物信息编号为"' + _ids + '"的数据项？').then(function () {
    return delCrop(_ids)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => { })
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download('crop/crop/export', {
    ...queryParams.value
  }, `crop_${new Date().getTime()}.xlsx`)
}

getList()
// 查询所有农作物品种列表
allVariety().then(response => {
  varietyList.value = response.rows
})
</script>
