import request from '@/utils/request'

// 查询监控任务列表
export function listJob(query) {
  return request({
    url: '/monitor/job/list',
    method: 'get',
    params: query
  })
}

// 查询监控任务详细
export function getJob(id) {
  return request({
    url: '/monitor/job/' + id,
    method: 'get'
  })
}

// 新增监控任务
export function addJob(data) {
  return request({
    url: '/monitor/job',
    method: 'post',
    data: data
  })
}

// 修改监控任务
export function updateJob(data) {
  return request({
    url: '/monitor/job',
    method: 'put',
    data: data
  })
}

// 删除监控任务
export function delJob(id) {
  return request({
    url: '/monitor/job/' + id,
    method: 'delete'
  })
}

// 结束监控任务
export function endJob(monitorId) {
  return request({
    url: '/monitor/job/end/' + monitorId,
    method: 'put'
  })
}
