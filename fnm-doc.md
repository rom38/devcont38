# fnm (Fast Node Manager) — документация

## 1. Установка

```sh
# Базовая установка (bash/zsh/fish)
curl -fsSL https://fnm.vercel.app/install | bash

# С кастомной директорией и без изменения shell-конфигов
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "./.fnm" --skip-shell

# Обновление (Linux — не macOS/brew)
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
```

Требования: `curl` и `unzip`.

---

## 2. Интеграция с shell

### Bash (~/.bashrc)
```bash
eval "$(fnm env --use-on-cd --shell bash)"
```

### Zsh (~/.zshrc)
```bash
eval "$(fnm env --use-on-cd --shell zsh)"
```

### Fish (~/.config/fish/conf.d/fnm.fish)
```fish
fnm env --use-on-cd --shell fish | source
```

### PowerShell ($PROFILE)
```powershell
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
```

---

## 3. Установка Node.js версий (`fnm install`)

```sh
# Конкретная версия
fnm install 20.11.0

# Последний патч мажорной версии
fnm install 18

# Последний LTS
fnm install --lts

# LTS по кодовому имени
fnm install lts/hydrogen

# Самый последний релиз (включая current)
fnm install --latest

# Установить и сразу переключиться
fnm install 22 --use

# С Corepack (corepack enable после установки)
fnm install 20 --corepack-enabled

# Под конкретную архитектуру
fnm install 18 --arch x64

# Кастомное зеркало дистрибутивов
fnm install v23.0.0-nightly20240725 --node-dist-mirror https://nodejs.org/download/nightly/
```

---

## 4. Переключение версий (`fnm use`)

```sh
# Явная версия
fnm use 20.11.0

# Частичный semver
fnm use 18

# LTS-алиас
fnm use lts/iron

# Версия из .node-version / .nvmrc
fnm use

# Автоустановка если версии нет
fnm use 22 --install-if-missing

# Без вывода если версия уже активна
fnm use 20 --silent-if-unchanged

# Рекурсивный поиск .node-version в родительских директориях
fnm use --version-file-strategy=recursive

# Записать текущую версию в .node-version
node --version > .node-version
fnm use
```

---

## 5. Выполнение команд в контексте версии (`fnm exec`)

```sh
# Запуск node с конкретной версией без смены текущей
fnm exec --using=v12.0.0 node --version

# Сборка с Node 18
fnm exec --using=18 node build.js

# npm install с закреплённой версией проекта
fnm exec --using=lts/hydrogen npm install

# Версия npm в Node 20
fnm exec --using=20 npm --version

# npx с конкретной версией
fnm exec --using=22 npx create-next-app@latest my-app
```

---

## 6. Алиасы версий

```sh
# Создать алиас
fnm alias 18.20.4 lts-maintenance

# Использовать по алиасу
fnm use lts-maintenance

# Установить версию по умолчанию (для новых сессий)
fnm default 20.11.0

# Показать версию по умолчанию
fnm default
# Output: v20.11.0

# Удалить алиас
fnm unalias lts-maintenance

# Список версий с алиасами
fnm list
# * v20.11.0 default
#   v18.20.4 lts-maintenance
```

---

## 7. Список, текущая версия, удаление

```sh
# Список установленных версий
fnm list

# Текущая версия
fnm current
# => v20.11.0

# В скриптах
CURRENT_NODE=$(fnm current)

# Удалить версию
fnm uninstall 16.20.0

# Удалить по алиасу (удаляет версию и все алиасы на неё)
fnm uninstall lts/gallium

# Удалить по частичному совпадению
fnm uninstall 14
```

---

## 8. Переменные окружения

```bash
# Директория fnm (по умолчанию $HOME/.local/share/fnm)
export FNM_DIR=/opt/fnm

# Кастомное зеркало дистрибутивов Node.js
export FNM_NODE_DIST_MIRROR=https://my-mirror.internal/nodejs/dist

# Стратегия поиска .node-version (recursive — вверх по директориям)
export FNM_VERSION_FILE_STRATEGY=recursive

# Читать engines.node из package.json
export FNM_RESOLVE_ENGINES=true

# Уровень логирования (quiet, error, info)
export FNM_LOGLEVEL=quiet
```

---

## 9. fnm env — флаги

```bash
# Все рекомендованные фичи
eval "$(fnm env \
  --use-on-cd \
  --shell bash \
  --version-file-strategy=recursive \
  --resolve-engines \
  --log-level=info)"

# Явная оболочка
eval "$(fnm env --shell bash)"

# Автопереключение при смене директории
eval "$(fnm env --use-on-cd)"

# JSON вместо shell-команд
fnm env --json
```

---

## 10. Docker / Dev Container — пример

```dockerfile
# Установка без shell-интеграции
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir /usr/local/share/fnm --skip-shell

# Симлинк в PATH
RUN ln -s /usr/local/share/fnm/fnm /usr/local/bin/fnm

# Установка Node.js LTS
RUN export PATH="/usr/local/share/fnm:$PATH" \
    && eval "$(fnm env --shell bash)" \
    && fnm install --lts \
    && fnm default lts-latest

# Прямые симлинки node/npm/npx (для доступности без fnm env)
RUN NODE_BIN=$(dirname "$(find /usr/local/share/fnm -name node -type f -not -path '*/fnm' | head -1)") \
    && ln -sf "$NODE_BIN/node" /usr/local/bin/node \
    && ln -sf "$NODE_BIN/npm" /usr/local/bin/npm \
    && ln -sf "$NODE_BIN/npx" /usr/local/bin/npx
```

---

## 11. Ссылки

- GitHub: https://github.com/schniz/fnm
- Сайт: https://fnm.vercel.app
