---
name: threads
description: "Платформенная обертка для Meta Threads поверх text-posts. Стратегия, ветки, engagement, аналитика."
$ARGUMENTS: Тема поста или задача (пост/хуки/план/стратегия), ниша
---


# Threads -- Платформенная обертка

Контент для Meta Threads. Базовые структуры постов, хуки, CTA -- в скилле **text-posts**.
Здесь -- Threads-специфика: ветки, алгоритм, engagement, аналитика.

**Принцип работы:** Threads = Охваты -> Telegram = Продажи

## Быстрый старт

```bash
# Генерация поста по теме
"Напиши threads пост на тему: [ТЕМА]"

# Только хуки по теме
"Сделай 5 хуков для threads на тему: [ТЕМА]"

# План контента на неделю
"Составь план threads на неделю для ниши [НИША]"

# Анализ конкурентов
"Проанализируй аккаунт @username в threads — что работает, какие темы"

# Стратегия роста
"Составь стратегию роста threads аккаунта для [НИША]"
```

## File Router

| Файл | Содержание | Когда читать |
|------|-----------|--------------|
| `threads-strategy.md` | Стратегия, позиционирование, воронка монетизации, лид-магниты | Запуск аккаунта, выбор ниши, стратегия роста |
| `threads-research.md` | Исследование ниши, анализ конкурентов, поиск трендов | Анализ конкурентов, поиск идей |
| `threads-content-plan.md` | Контент-микс, календарь, частота, батчинг | Планирование контента на неделю/месяц |
| `threads-hooks.md` | Формулы хуков, триггеры, примеры по нишам, A/B тестирование | Написание хуков, улучшение первой строки |
| `threads-copywriting.md` | Структуры постов, 8 типов контента, CTA, STEPPS, офферы, костяк поста | Написание постов, копирайтинг |
| `threads-engagement.md` | Комментирование, работа с DM, community building | Вовлечение, рост через комментарии |
| `threads-analytics.md` | Метрики, бенчмарки, A/B тесты, tracking system | Анализ результатов, оптимизация |

## Зависимости

| Скилл | Роль |
|-------|------|
| **text-posts** | Базовое ядро: структуры постов, хуки, CTA, антипаттерны |
| **copywriting** | Фундамент: скользкая горка, 18 правил |
| **storytelling** | Для постов-историй |

## Workflow

1. **Исследование** -> `threads-research.md`
2. **Стратегия** -> `threads-strategy.md`
3. **Контент-план** -> `threads-content-plan.md`
4. **Написание** -> скилл **text-posts** + `threads-copywriting.md` + `threads-hooks.md`
5. **Вовлечение** -> `threads-engagement.md`
6. **Аналитика** -> `threads-analytics.md`

## Ключевые параметры

| Параметр | Значение |
|----------|----------|
| Частота | 3-5 постов в день (минимум 1-2) |
| Лимит символов | 500 символов на тред |
| Первые 30-60 минут | Критичны для алгоритма |
| Ссылки | ТОЛЬКО в закрепленном комментарии |

## Notion база для Threads

1. Скопируй шаблон: https://шаблон на Notion/threads-fabrika?v=30c6ad1acb59814791b0000c5518a605
2. Создай Notion интеграцию: https://www.notion.so/profile/integrations/internal
   -> New integration -> назови "Content Factory" -> скопируй токен (ntn_...)
   -> В скопированной базе: ... -> Connections -> подключи свою интеграцию
3. Скинь токен и ссылку на базу -- я запомню

Шаблон содержит: поля (Post, Status, Format, Topic, CTA Type, Image URL),
статусы (Draft -> Pending -> Approved -> Published -> Rejected),
форматы (Story, Tips, Question, Facts, Hack).

Каждый пост пишется внутри Code Block. Одна ветка = один code block.
CTA со ссылкой -- отдельный code block в конце.

## Автопостинг (Threads Scheduler)

Автоматическая публикация из Notion в Threads через MoreLogin.
Инструкция: см. tools/threads-scheduler/README.md
MoreLogin (антидетект-браузер): https://www.morelogin.com/?from=AAFks4W2tN8w

---

*Threads Skill v2.0 -- Platform Wrapper over text-posts*
