import request from '@/utils/request'

// 查询检测日志列表
export function listLog(query) {
  return request({
    url: '/model/log/list',
    method: 'get',
    params: query
  })
}

// 查询检测日志详细
export function getLog(id) {
  return request({
    url: '/model/log/' + id,
    method: 'get'
  })
}

// 新增检测日志
export function addLog(data) {
  return request({
    url: '/model/log',
    method: 'post',
    data: data
  })
}

// 修改检测日志
export function updateLog(data) {
  return request({
    url: '/model/log',
    method: 'put',
    data: data
  })
}

// 删除检测日志
export function delLog(id) {
  return request({
    url: '/model/log/' + id,
    method: 'delete'
  })
}


