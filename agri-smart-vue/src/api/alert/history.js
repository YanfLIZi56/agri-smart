import request from '@/utils/request'

// 查询预警历史记录列表
export function listHistory(query) {
  return request({
    url: '/alert/history/list',
    method: 'get',
    params: query
  })
}

// 查询预警历史记录详细
export function getHistory(id) {
  return request({
    url: '/alert/history/' + id,
    method: 'get'
  })
}

// 新增预警历史记录
export function addHistory(data) {
  return request({
    url: '/alert/history',
    method: 'post',
    data: data
  })
}

// 修改预警历史记录
export function updateHistory(data) {
  return request({
    url: '/alert/history',
    method: 'put',
    data: data
  })
}

// 删除预警历史记录
export function delHistory(id) {
  return request({
    url: '/alert/history/' + id,
    method: 'delete'
  })
}
