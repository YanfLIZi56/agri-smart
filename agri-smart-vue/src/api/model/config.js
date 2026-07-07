import request from '@/utils/request'

// 查询模型配置列表
export function listConfig(query) {
  return request({
    url: '/model/config/list',
    method: 'get',
    params: query
  })
}

// 查询模型配置详细
export function getConfig(id) {
  return request({
    url: '/model/config/' + id,
    method: 'get'
  })
}

// 新增模型配置
export function addConfig(data) {
  return request({
    url: '/model/config',
    method: 'post',
    data: data
  })
}

// 修改模型配置
export function updateConfig(data) {
  return request({
    url: '/model/config',
    method: 'put',
    data: data
  })
}

// 删除模型配置
export function delConfig(id) {
  return request({
    url: '/model/config/' + id,
    method: 'delete'
  })
}

// 扫描模型
export function scanModel() {
  return request({
    url: '/model/config/scan',
    method: 'get'
  })
}

// 批量新增模型配置
export function addBatchConfig(data) {
  return request({
    url: '/model/config/batch',
    method: 'post',
    data: data
  })
}

// 查询模型配置服务器路径
export function getServerPath() {
  return request({
    url: '/model/config/server-path',
    method: 'get'
  })
}

export function remoteModelConfigList(query) {
  return request({
    url: '/model/config/remote/model-config',
    method: 'get',
    params: query
  })
}