# DevPod — документация

## 1. Установка и первый запуск

DevPod — client-only инструмент для создания воспроизводимых dev-окружений на основе `devcontainer.json` на любом backend'е (Docker, Kubernetes, SSH, облачные провайдеры).

```bash
devpod provider add docker
devpod up github.com/microsoft/vscode-remote-try-node --ide vscode
```

---

## 2. Провайдеры — `provider`

### Добавление

```bash
devpod provider add docker
devpod provider add kubernetes
devpod provider add ssh
devpod provider add aws
devpod provider add azure
devpod provider add gcloud
devpod provider add digitalocean
```

### С опциями при добавлении

```bash
devpod provider add aws --name aws-gpu -o AWS_INSTANCE_TYPE=p3.8xlarge
devpod provider add <provider-name> -o KEY=value
```

### Установка провайдера по умолчанию

```bash
devpod provider use <provider-name>
devpod provider use <provider-name> -o KEY=value
```

### Настройка опций

```bash
devpod provider set-options <provider-name> --option <KEY>=<VALUE>
```

### Просмотр опций

```bash
devpod provider options <provider-name>
```

### Обновление и удаление

```bash
devpod provider update kubernetes kubernetes
devpod provider delete <provider-name>
```

---

## 3. Машины — `machine`

Машина — вычислительный ресурс (инстанс Docker, под Kubernetes, SSH-сервер), на котором запускаются workspace'ы.

```bash
devpod machine list

devpod machine create <name> --provider <provider-name>

devpod machine status <name>

devpod machine stop <name>

devpod machine delete <name>
```

---

## 4. Workspace'ы — `up`

### Из Git-репозитория

```bash
devpod up github.com/microsoft/vscode-remote-try-node --ide vscode
devpod up github.com/microsoft/vscode-remote-try-node --ide openvscode
devpod up github.com/microsoft/vscode-remote-try-node --ide none
```

### Из локальной папки

```bash
devpod up ./path/to/my-folder
```

### SSH-доступ к workspace

```bash
ssh MY_WORKSPACE_NAME.devpod
```

---

## 5. IDE

```bash
# Установка опций IDE
devpod ide set-options openvscode -o VERSION=v1.76.2
```

---

## 6. SSH-провайдер — конфигурация

SSH-провайдер позволяет использовать любой удалённый сервер как среду разработки.

### Базовая структура exec-секции

```yaml
exec:
  init: |-
    OUTPUT=$(ssh -oStrictHostKeyChecking=no \
                 -p ${PORT} \
                 ${EXTRA_FLAGS} \
                 "${HOST}" \
                 'sh -c "echo DevPodTest"')

    if [ "$OUTPUT" != "DevPodTest" ]; then
      >&2 echo "Unexpected ssh output."
      exit 1
    fi

  command: |-
    ssh -oStrictHostKeyChecking=no \
        -p ${PORT} \
        "${EXTRA_FLAGS}" \
        "${HOST}" \
        "${COMMAND}"
```

### Опции SSH-провайдера

| Переменная | Назначение |
|---|---|
| `HOST` | Адрес SSH-сервера |
| `PORT` | Порт SSH |
| `USER` | Имя пользователя |
| `EXTRA_FLAGS` | Дополнительные флаги SSH |

---

## 7. Контекст — `context`

Глобальные настройки DevPod.

```bash
# Отключить инжекцию Docker-credentials во все workspace'ы
devpod context set-options default -o SSH_INJECT_DOCKER_CREDENTIALS=false
```

---

## 8. Типовой workflow

```bash
# 1. Добавить провайдер
devpod provider add docker

# 2. Поднять workspace
devpod up ./my-project --ide vscode

# 3. Работать в IDE
# ...

# 4. Остановить/удалить
devpod machine stop <machine-name>
devpod machine delete <machine-name>
```

---

## 9. Ссылки

- GitHub: https://github.com/loft-sh/devpod
- Сайт: https://devpod.sh
