package com.agriSmart.utils;

import com.agriSmart.model.domain.ModelConfig;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

public class FileUtils {

    public static List<ModelConfig> scanModels(String modelPath) {
        List<ModelConfig> models = new ArrayList<>();
        Path rootPath = Paths.get(modelPath);

        if (!Files.exists(rootPath) || !Files.isDirectory(rootPath)) {
            return models;
        }

        try (Stream<Path> paths = Files.walk(rootPath)) {
            paths.filter(Files::isRegularFile)
                    .filter(path -> {
                        String fileName = path.getFileName().toString().toLowerCase();
                        return fileName.endsWith(".pt") || fileName.endsWith(".onnx");
                    })
                    .forEach(path -> {
                        ModelConfig model = new ModelConfig();
                        Path relativePath = rootPath.relativize(path);
                        model.setFilePath(relativePath.toString().replace("\\", "/"));
                        model.setModelName(path.getFileName().toString());
                        model.setModelSize(String.format("%.2f", path.toFile().length() / 1024.0 / 1024.0) + "MB");
                        model.setIsActive(0);
                        models.add(model);
                    });
        } catch (Exception e) {
            throw new RuntimeException("扫描模型文件失败", e);
        }

        return models;
    }
}
