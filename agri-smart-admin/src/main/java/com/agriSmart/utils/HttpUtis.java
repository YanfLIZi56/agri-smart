package com.agriSmart.utils;

import com.agriSmart.common.utils.http.HttpUtils;
import com.alibaba.fastjson2.JSON;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

    /**
     * HTTP工具类
     *
     * @author 羊离子
     */
    public class HttpUtis
    {
        /**
         * 发送POST请求（JSON格式）
         *
         * @param url 请求地址
         * @param param 请求参数，Map形式
         * @return 响应结果
         */
        public static String sendPost(String url, Map<String, Object> param){
            try {
                RestTemplate restTemplate = new RestTemplate();

                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_JSON);

                String jsonBody = JSON.toJSONString(param);
                HttpEntity<String> requestEntity = new HttpEntity<>(jsonBody, headers);
                return restTemplate.postForObject(url, requestEntity, String.class);
            } catch (Exception e) {
                throw new RuntimeException("HTTP请求失败: " + e.getMessage(), e);
            }
        }


        /**
         * 发送POST请求（支持文件上传）
         *
         * @param url 请求地址
         * @param file 上传的文件
         * @param params 其他表单参数
         * @return 响应结果
         */
        public static String sendPostWithFile(String url, MultipartFile file, Map<String, Object> params) {
            try {
                RestTemplate restTemplate = new RestTemplate();

                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.MULTIPART_FORM_DATA);

                MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();

                if (file != null && !file.isEmpty()) {
                    body.add("file", new ByteArrayResource(file.getBytes()) {
                        @Override
                        public String getFilename() {
                            return file.getOriginalFilename();
                        }
                    });
                }

                if (params != null) {
                    params.forEach((key, value) -> {
                        if (value != null) {
                            body.add(key, value);
                        }
                    });
                }

                HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

                ResponseEntity<String> response = restTemplate.postForEntity(url, requestEntity, String.class);

                return response.getBody();
            }
            catch (Exception e) {
                throw new RuntimeException("HTTP请求失败: " + e.getMessage(), e);
            }
        }

        public static int sendDelete(String apiUrl) {
            try {
                RestTemplate restTemplate = new RestTemplate();
                ResponseEntity<Void> response = restTemplate.exchange(
                    apiUrl, 
                    org.springframework.http.HttpMethod.DELETE, 
                    null, 
                    Void.class
                );
                return response.getStatusCode().value();
            } catch (HttpClientErrorException e) {
                return e.getStatusCode().value();
            } catch (Exception e) {
                throw new RuntimeException("HTTP请求失败: " + e.getMessage(), e);
            }
        }
    }
