# Dev Containers — Документация

## 1. Обзор спецификации

Development Container Specification решает проблему «на моей машине работает» — конфигурация окружения встраивается прямо в репозиторий. Ключевые компоненты:

| Компонент | Назначение |
|---|---|
| `devcontainer.json` | Конфигурация контейнера разработки |
| `devcontainer.metadata` | Метка образа для предсобранных конфигураций |
| **Features** | Переиспользуемые модули установки инструментов |
| **Templates** | Готовые стартовые шаблоны проектов |
| `devcontainer-lock.json` | Lock-файл для воспроизводимой фиксации версий Features |
| **Secrets** | Механизм для чувствительных данных (API-ключи) |

Распространяются через OCI-реестры. Потребляется инструментами через open-source CLI (`@devcontainers/cli`).

Файл размещается по пути: `.devcontainer/devcontainer.json` в корне репозитория.

---

## 2. Полный пример `devcontainer.json`

```jsonc
{
  "name": "My Node.js App",

  // --- Сборка из Dockerfile ---
  "build": {
    "dockerfile": "Dockerfile",
    "context": "..",
    "args": { "VARIANT": "18-bullseye" },
    "target": "development"
  },

  // --- ИЛИ: готовый образ ---
  // "image": "mcr.microsoft.com/devcontainers/typescript-node:18",

  // --- ИЛИ: Docker Compose ---
  // "dockerComposeFile": ["../docker-compose.yml", "docker-compose.dev.yml"],
  // "service": "app",
  // "runServices": ["app", "db"],

  // Features — модули инструментов поверх базового образа
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/python:1": {
      "version": "3.11",
      "pip": true
    }
  },

  // Переопределение порядка установки Features
  "overrideFeatureInstallOrder": [
    "ghcr.io/devcontainers/features/python",
    "ghcr.io/devcontainers/features/github-cli"
  ],

  // Проброс портов
  "forwardPorts": [3000, "db:5432"],
  "portsAttributes": {
    "3000": { "label": "App", "onAutoForward": "openPreview" }
  },
  "otherPortsAttributes": { "onAutoForward": "silent" },

  // Переменные окружения
  "containerEnv": { "NODE_ENV": "development" },
  "remoteEnv":    { "PATH": "${containerEnv:PATH}:/home/node/.local/bin" },

  // Пользователи
  "remoteUser": "node",
  "containerUser": "node",
  "updateRemoteUserUID": true,
  "userEnvProbe": "loginInteractiveShell",

  // Монтирование
  "mounts": [
    { "source": "node-modules-${devcontainerId}", "target": "/workspace/node_modules", "type": "volume" }
  ],

  // Lifecycle-хуки
  "initializeCommand":     "echo 'Running on host'",
  "onCreateCommand":       "npm ci",
  "updateContentCommand":  "npm run build",
  "postCreateCommand": {
    "deps":   "npm install",
    "dbseed": ["node", "scripts/seed-db.js"]
  },
  "postStartCommand":  "npm run dev -- --no-open",
  "postAttachCommand": "git fetch --all",
  "waitFor": "postCreateCommand",

  // Минимальные требования к хосту
  "hostRequirements": {
    "cpus": 4,
    "memory": "8gb",
    "storage": "32gb",
    "gpu": "optional"
  },

  // Поведение контейнера
  "overrideCommand": true,
  "shutdownAction": "stopContainer",
  "init": false,
  "privileged": false,
  "capAdd": ["SYS_PTRACE"],
  "securityOpt": ["seccomp=unconfined"],
  "runArgs": ["--device-cgroup-rule=c 188:* rmw"],

  // Workspace
  "workspaceFolder": "/workspace",
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached",

  // Кастомизации для конкретных инструментов
  "customizations": {
    "vscode": {
      "extensions": ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"],
      "settings": { "editor.formatOnSave": true }
    }
  },

  // Декларативные секреты
  "secrets": {
    "OPENAI_API_KEY": {
      "description": "OpenAI API key for AI features.",
      "documentationUrl": "https://platform.openai.com/docs/api-reference/authentication"
    }
  }
}
```

---

## 3. Способы задания базового образа

### Сборка из Dockerfile
```json
{
  "build": {
    "dockerfile": "Dockerfile"
  }
}
```

Путь к Dockerfile указывается относительно `devcontainer.json`.

### Готовый образ
```json
{
  "image": "mcr.microsoft.com/devcontainers/typescript-node:18"
}
```

### Docker Compose
```json
{
  "dockerComposeFile": ["../docker-compose.yml", "docker-compose.dev.yml"],
  "service": "app",
  "runServices": ["app", "db"]
}
```

---

## 4. Жизненный цикл (Lifecycle Hooks)

| Хук | Где выполняется | Когда |
|---|---|---|
| `initializeCommand` | На хосте | Перед созданием контейнера |
| `onCreateCommand` | В контейнере | При первом создании |
| `updateContentCommand` | В контейнере | При обновлении содержимого workspace |
| `postCreateCommand` | В контейнере | После создания контейнера |
| `postStartCommand` | В контейнере | При каждом запуске |
| `postAttachCommand` | В контейнере | При каждом подключении |

`postCreateCommand` может быть объектом для параллельного выполнения:
```json
"postCreateCommand": {
  "install": "npm install",
  "seed": ["node", "scripts/seed-db.js"]
}
```

---

## 5. CLI — команды

### `devcontainer up` — создание и запуск контейнера

```bash
# Базовое использование
devcontainer up --workspace-folder ./my-project

# Без кэша, с удалением существующего контейнера
devcontainer up \
  --workspace-folder ./my-project \
  --build-no-cache \
  --remove-existing-container

# С dotfiles
devcontainer up \
  --workspace-folder ./my-project \
  --dotfiles-repository https://github.com/user/dotfiles.git \
  --dotfiles-install-command ./install.sh

# С дополнительными монтированиями и переменными окружения
devcontainer up \
  --workspace-folder ./my-project \
  --mount "type=bind,source=/host/data,target=/container/data" \
  --remote-env "API_KEY=secret"

# С дополнительными Features
devcontainer up \
  --workspace-folder ./my-project \
  --additional-features '{"ghcr.io/devcontainers/features/node:1": {"version": "18"}}'
```

Ответ:
```json
{
  "outcome": "success",
  "containerId": "f0a055ff056c...",
  "remoteUser": "vscode",
  "remoteWorkspaceFolder": "/workspaces/my-project"
}
```

### `devcontainer build` — сборка образа

```bash
devcontainer build --workspace-folder <path>
```

### `devcontainer exec` — выполнение команды в запущенном контейнере

```bash
# Одиночная команда
devcontainer exec --workspace-folder ./my-project cargo run

# С аргументами
devcontainer exec --workspace-folder ./my-project npm test -- --coverage

# С дополнительным окружением
devcontainer exec \
  --workspace-folder ./my-project \
  --remote-env "NODE_ENV=production" \
  node build.js

# По ID контейнера
devcontainer exec --container-id abc123def456 ls -la /workspaces
```

Ответ:
```json
{
  "stdout": "Build successful.\n",
  "stderr": "",
  "exitCode": 0
}
```

### `devcontainer run-user-commands`

```bash
devcontainer run-user-commands --workspace-folder <path>
```

---

## 6. Features — доступные модули

Features — самодостаточные модули установки, добавляемые в секцию `features` файла `devcontainer.json`.

### common-utils
Базовые утилиты (zsh, curl, ca-certificates, пользователь, git и т.д.)
```json
"features": {
    "ghcr.io/devcontainers/features/common-utils:2": {}
}
```

Опции: `installZsh`, `installOhMyZsh`, `upgradePackages`, `username`, `userUid`, `userGid`, `nonFreePackages`.

### Python
```json
"features": {
    "ghcr.io/devcontainers/features/python:1": {}
}
```

Опции: `version`, `installTools`, `pip` и другие.

### Node.js
```json
"features": {
    "ghcr.io/devcontainers/features/node:2": {}
}
```

Опции: `version`.

### Git
```json
"features": {
    "ghcr.io/devcontainers/features/git:1": {}
}
```

Опции: `version`, `ppa`.

### GitHub CLI
```json
"features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
}
```

---

## 7. Templates — шаблоны

Templates используют плейсхолдеры `${templateOption:...}` для динамической подстановки опций:

```jsonc
{
  "name": "Java",
  "image": "mcr.microsoft.com/devcontainers/java:0-${templateOption:imageVariant}",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "${templateOption:nodeVersion}"
    },
    "ghcr.io/devcontainers/features/java:1": {
      "installMaven": "${templateOption:installMaven}"
    }
  }
}
```

---

## 8. Ссылки

- **Спецификация**: https://github.com/devcontainers/spec
- **CLI**: https://github.com/devcontainers/cli
- **Features**: https://github.com/devcontainers/features
- **Templates**: https://containers.dev/templates
