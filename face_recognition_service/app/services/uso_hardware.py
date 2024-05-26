import time

import GPUtil
import psutil


def medir_recursos(func):
    def wrapper(*args, **kwargs):
        start_time = time.time()
        cpu_antes = psutil.cpu_percent(interval=None)
        mem_antes = psutil.virtual_memory().percent
        gpu_antes = GPUtil.getGPUs()[0].load if GPUtil.getGPUs() else None

        result = func(*args, **kwargs)

        cpu_depois = psutil.cpu_percent(interval=None)
        mem_depois = psutil.virtual_memory().percent
        gpu_depois = GPUtil.getGPUs()[0].load if GPUtil.getGPUs() else None
        end_time = time.time()

        print(f"Uso de CPU: {cpu_depois - cpu_antes}%")
        print(f"Uso de Memória: {mem_depois - mem_antes}%")
        if gpu_antes is not None:
            print(f"Uso de GPU: {gpu_depois - gpu_antes}%")
        print(f"Tempo de execução: {end_time - start_time} segundos")
        return result

    return wrapper