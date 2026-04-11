# 🤖 Фабрика Контента — Полная версия (5 агентов)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) [![Часть hamster.club](https://img.shields.io/badge/🐹%20InvestClub-hamster.club-F59E0B)](https://humster.club/aiclub/) [![Telegram Bot](https://img.shields.io/badge/Telegram-@aiclub10__bot-26A5E4)](https://t.me/aiclub10_bot)

Полная Фабрика Контента InvestClub: **5 AI-агентов работают как команда** — координатор, копирайтер, маркетолог, дизайнер, технарь. Каждый — отдельный Telegram-бот со своей памятью и скиллами. Все связаны через общее пространство.

> ⚠️ **Установщик защищён лицензией клуба.** Прямой `git clone` без получения ключа через бота не сработает — `install.sh` отказывается запускаться без валидной лицензии. Это сделано чтобы фабрика работала только у участников клуба.

## ⚡ Установка одной командой

Лицензия выдаётся ботом [@aiclub10_bot](https://t.me/aiclub10_bot) после проверки членства в группе Десятки. Получи ключ и выполни:

```bash
curl -sSL "http://humsterclub.duckdns.org/gate-full/install?key=FULL-XXXX-XXXX-XXXX" | bash
```

Установщик сам:
- Проверит систему и зависимости
- Скачает фабрику с GitHub
- Развернёт 5 агентов с памятью
- Настроит heartbeat-проверку лицензии раз в неделю
- Поднимет Telegram-боты и подключит их к OpenClaw

## 👥 Что внутри

| Агент | Роль |
|---|---|
| 🎯 **Координатор** | Точка входа, маршрутизирует задачи |
| 📝 **Копирайтер** | Пишет посты по методу Халилова в твоём голосе |
| 📊 **Маркетолог** | Распаковка ЦА, оффер, стратегия |
| 🎨 **Дизайнер** | Обложки, карусели, визуал |
| 🔧 **Технарь** | Диагностика и фиксы платформы |

## 🧠 Принцип работы

**Один правит — все видят.** Маркетолог собрал ЦА → копирайтер сразу пишет точнее → дизайнер делает обложки в нужном тоне. Без передачи контекста руками, без копи-пасты.

## 📚 Документация

- 📖 **Полный гайд установки:** https://humster.club/aiclub/5agents/install-5agents.html
- 📊 **Дашборд content-factory:** [Dimks777/content-factory](https://github.com/Dimks777/content-factory)
- 🐹 **Lite-версия (1 агент):** [Dimks777/aiclublight](https://github.com/Dimks777/aiclublight)
- 🧠 **Скиллы для Claude:** [Dimks777/awesome-claude-skills](https://github.com/Dimks777/awesome-claude-skills)
- 📚 **База знаний клуба:** https://humster.club/aiclub/

## 🛡️ Лицензия и доступ

Доступ к коду — только для участников клуба InvestClub. Лицензия активна, пока ты в нашей Telegram-группе. Heartbeat-проверка раз в неделю — если выйдешь из клуба, фабрика автоматически блокируется.

Код выпущен под MIT License (см. LICENSE), но платформа OpenClaw + лицензионный gate — закрытая часть проекта.

---

🐹 Часть проекта **[hamster.club](https://humster.club)** — клуб AI-энтузиастов и инвесторов InvestClub. По вопросам: [@algot888](https://t.me/algot888)
