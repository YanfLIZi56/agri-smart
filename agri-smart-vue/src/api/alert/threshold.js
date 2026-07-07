import request from '@/utils/request'

// 查询预警阈值配置列表
export function listThreshold(query) {
  return request({
    url: '/alert/threshold/list',
    method: 'get',
    params: query
  })
}

// 查询预警阈值配置详细
export function getThreshold(id) {
  return request({
    url: '/alert/threshold/' + id,
    method: 'get'
  })
}

// 新增预警阈值配置
export function addThreshold(data) {
  return request({
    url: '/alert/threshold',
    method: 'post',
    data: data
  })
}

// 修改预警阈值配置
export function updateThreshold(data) {
  return request({
    url: '/alert/threshold',
    method: 'put',
    data: data
  })
}

// 删除预警阈值配置
export function delThreshold(id) {
  return request({
    url: '/alert/threshold/' + id,
    method: 'delete'
  })
}
