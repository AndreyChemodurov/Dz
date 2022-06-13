[![DockerTask_DebianInfo](https://github.com/jo22i/DockerTask/actions/workflows/actions.yml/badge.svg)](https://github.com/jo22i/DockerTask/actions/workflows/actions.yml)

# Индивидуальное зачётное задание по предмету "Технологии и методы программирования"

## Выполнил - студент группы ИУ8-22 Мельников Егор

### Задача

1. Создать в _ контейнер, работающий на образе _.
2. Создать общую папку с этим контейнером, в контейнере выполнить команду для отображения версии ОС.
3. Переместить полученную информацию в файл в общей папке.
4. Загрузить данный файл как артефакт.

### Ход выполнения работы

Примечание: В данной работе слегка нарушена логика получения информации из контейнера. Вместо передачи информации напрямую из контейнера в файл, например, используя *Docker Volumes*, сначала файл создавался в контейнере, потом в контейнере после его остановки копировался полученный файл в выделенную в *GitHub Actions* папку `artifact`, а оттуда уже загружалась как артефакт.

1. Создаём необходимый *Dockerfile*.

```sh
FROM debian:11.3

WORKDIR task/
COPY . .

RUN apt-get update
RUN apt-get install -yy lsb-release

ENTRYPOINT [ "sh", "-c", "lsb_release -a > info.txt" ]
```

2. Создаём файл *actions.yml* для сервиса *GitHub Actions*.

```sh
name: DockerTask_DebianInfo

on:
  push:
    branches: [master]
    
jobs:
  
  Run:
    
    runs-on: ubuntu-latest
    
    steps:
      
      - name: checkout
        uses: actions/checkout@v3
        
      - name: Make artifact dir
        shell: bash
        run: mkdir artifact
        
      - name: Build and run container
        shell: bash
        run: |
          docker build -t task .
          docker run --name TaskCont task
          
      - name: Getting info out of container and clear containers and images
        shell: bash
        run: |
          docker cp TaskCont:/task/info.txt ./artifact
          docker container prune
          docker image prune
          
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: info
          path: artifact
```
