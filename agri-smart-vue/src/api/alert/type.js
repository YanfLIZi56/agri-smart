import request from '@/utils/request'

// 查询预警阈值类型列表
export function listType(query) {
  return request({
    url: '/alert/type/list',
    method: 'get',
    params: query
  })
}

// 查询预警阈值类型详细
export function getType(id) {
  return request({
    url: '/alert/type/' + id,
    method: 'get'
  })
}

// 新增预警阈值类型
export function addType(data) {
  return request({
    url: '/alert/type',
    method: 'post',
    data: data
  })
}

// 修改预警阈值类型
export function updateType(data) {
  return request({
    url: '/alert/type',
    method: 'put',
    data: data
  })
}

// 删除预警阈值类型
export function delType(id) {
  return request({
    url: '/alert/type/' + id,
    method: 'delete'
  })
}
