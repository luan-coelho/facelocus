package br.unitins.facelocus.commons;

import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@ApplicationScoped
public class TaskQueueManager {

    private final ExecutorService executorService = Executors.newSingleThreadExecutor();

    public void submitTask(Runnable task) {
        executorService.submit(task);
    }

    @PreDestroy
    public void cleanUp() {
        executorService.shutdown();
    }
}