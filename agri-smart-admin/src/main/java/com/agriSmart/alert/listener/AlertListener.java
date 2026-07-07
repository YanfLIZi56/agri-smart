package com.agriSmart.alert.listener;

import com.agriSmart.alert.domain.dto.AlertListenDto;
import com.agriSmart.monitor.service.IMonitorJobService;
import org.slf4j.Logger;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class AlertListener {

    private static final Logger log = org.slf4j.LoggerFactory.getLogger(AlertListener.class);

    @Autowired
    private IMonitorJobService monitorJobService;

    @RabbitListener(bindings = @QueueBinding(
            exchange = @Exchange(value = "yolo.direct.exchange"),
            value = @Queue(value = "yolo.queue"),
            key = "yolo.statistics"))
    public void yoloQueue(AlertListenDto message){
        log.info("监听到统计信息:  {}", message.toString());
    }

    @RabbitListener(bindings = @QueueBinding(
            exchange = @Exchange(value = "yolo.direct.exchange"),
            value = @Queue(value = "yolo.error.queue"),
            key = "yolo.error"))
    public void yoloErrorQueue(AlertListenDto message){
        log.info("错误信息:  {}", message.toString());
    }

    @RabbitListener(bindings = @QueueBinding(
            exchange = @Exchange(value = "yolo.direct.exchange"),
            value = @Queue(value = "yolo.end.queue"),
            key = "yolo.end"))
    public void yoloEndQueue(AlertListenDto message){
        log.info("结束信息:  {}", message.toString());
        monitorJobService.stopJob(message.getDevId());
    }
}
