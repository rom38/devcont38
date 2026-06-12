# Dockerfile — документация

## 1. Обзор инструкций

| Инструкция | Описание |
|---|---|
| `FROM` | Базовый образ или начало нового сборочного этапа |
| `RUN` | Выполнение команд при сборке |
| `COPY` | Копирование файлов/директорий из контекста сборки |
| `ADD` | COPY + автоизвлечение tar и загрузка по URL |
| `CMD` | Команда по умолчанию при запуске контейнера |
| `ENTRYPOINT` | Исполняемый файл по умолчанию |
| `ENV` | Переменные окружения |
| `ARG` | Переменные времени сборки |
| `WORKDIR` | Рабочая директория |
| `USER` | Пользователь и группа |
| `EXPOSE` | Порты, которые слушает приложение |
| `VOLUME` | Точки монтирования томов |
| `HEALTHCHECK` | Проверка здоровья контейнера |
| `SHELL` | Оболочка по умолчанию |
| `LABEL` | Метаданные образа |
| `ONBUILD` | Инструкции для downstream-сборок |
| `STOPSIGNAL` | Сигнал для остановки контейнера |

---

## 2. FROM — базовый образ и multi-stage

```dockerfile
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
```

**Multi-stage build** — несколько `FROM` в одном Dockerfile:

```dockerfile
# syntax=docker/dockerfile:1
# Stage 1: сборка
FROM golang:1.24 AS build
WORKDIR /src
COPY . .
RUN go build -o /bin/hello ./main.go

# Stage 2: минимальный runtime
FROM scratch
COPY --from=build /bin/hello /bin/hello
CMD ["/bin/hello"]
```

**Копирование из именованного этапа:**
```dockerfile
COPY --from=build /app/build /usr/share/nginx/html
```

---

## 3. RUN — выполнение команд

Две формы:
```dockerfile
# Shell form (запускается в /bin/sh -c):
RUN apt-get update && apt-get install -y curl

# Exec form (без shell):
RUN ["/bin/bash", "-c", "echo hello"]
```

**Лучшая практика — apt-пакеты в одном слое с очисткой кеша:**

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    libssl-dev \
    s3cmd=1.1.* \
    && rm -rf /var/lib/apt/lists/*
```

**Управление переменными в одном RUN-слое** (переменная не остаётся в образе):

```dockerfile
RUN export ADMIN_USER="mark" \
    && echo $ADMIN_USER > ./mark \
    && unset ADMIN_USER
```

---

## 4. COPY vs ADD

| | COPY | ADD |
|---|---|---|
| Копирование локальных файлов | ✅ | ✅ |
| Извлечение tar.gz автоматически | ❌ | ✅ |
| Загрузка по URL | ❌ | ✅ |
| Рекомендация | **Предпочтительнее** | Только когда нужно извлечение/URL |

```dockerfile
COPY . /app
COPY --from=build /bin/hello /bin/hello
```

---

## 5. ENV и ARG

**ARG** — переменная времени сборки (только в Dockerfile, недоступна в контейнере):
```dockerfile
ARG VARIANT=trixie
FROM debian:${VARIANT}
```

**ENV** — переменная окружения (доступна и при сборке, и в контейнере):
```dockerfile
ENV NODE_ENV=production
```

**ENV переопределяет ARG с тем же именем** после инструкции ENV:
```dockerfile
ARG CONT_IMG_VER
ENV CONT_IMG_VER=v1.0.0   # теперь везде v1.0.0
RUN echo $CONT_IMG_VER     # v1.0.0
```

---

## 6. CMD и ENTRYPOINT

**CMD** — команда по умолчанию (можно переопределить при `docker run`):
```dockerfile
CMD ["node", "app.js"]
```

**ENTRYPOINT** — основной исполняемый файл (CMD становится аргументами):
```dockerfile
ENTRYPOINT ["s3cmd"]
CMD ["--help"]
# => s3cmd --help
```

**Exec form (рекомендуется)** — правильная обработка сигналов ОС:
```dockerfile
CMD ["my-cmd", "start"]    # ✅ правильная передача SIGTERM
CMD my-cmd start            # ❌ через shell — сигналы не доходят
```

---

## 7. WORKDIR

Устанавливает рабочую директорию для `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD`. Создаёт директорию, если её нет.

```dockerfile
WORKDIR /app
COPY . .
RUN npm install
```

---

## 8. USER

Задаёт пользователя для последующих инструкций и запуска контейнера:

```dockerfile
USER vscode
```

---

## 9. SHELL

Задаёт оболочку для shell-формы инструкций:

```dockerfile
SHELL ["/bin/bash", "-c"]
RUN echo $HOME   # теперь выполняется в bash
```

---

## 10. HEALTHCHECK

Проверка работоспособности контейнера:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

---

## 11. Оптимизация слоёв и кеширования

**Порядок инструкций для максимального кеширования:**

```dockerfile
# Сначала — редко меняющиеся зависимости
FROM node:24-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci          # кешируется, пока не меняется package.json

# Потом — часто меняющийся код
COPY src ./src
RUN npm run build
```

**Очистка в том же слое:**
```dockerfile
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
```

**Multi-stage build** — разделение сборочных зависимостей и runtime:

```dockerfile
FROM node:latest AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:slim
WORKDIR /app
COPY --from=build /app/dist ./dist
CMD ["node", "dist/app.js"]
```

---

## 12. Ссылки

- Dockerfile reference: https://docs.docker.com/reference/dockerfile/
- Best practices: https://docs.docker.com/build/building/best-practices/
- Multi-stage builds: https://docs.docker.com/build/building/multi-stage/
