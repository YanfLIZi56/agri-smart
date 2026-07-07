import request from '@/utils/request'

export function detect(data) {
    return request({
        url: '/yolo/detect',
        method: 'post',
        data: data
    })
}