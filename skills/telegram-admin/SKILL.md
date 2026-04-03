---
name: telegram-admin
description: "Управление Telegram группами через Bot API: топики, пины, модерация, инвайты."
triggers:
  - telegram admin
  - управление группой
  - топики telegram
  - модерация
  - пин сообщения
  - инвайт ссылка
---



# telegram-admin

Управление Telegram группами через Bot API: топики, пины, модерация, инвайты.

## Скрипт

```
bash scripts/tg-admin.sh <account> <method> [key=value ...]
```

- `account` — имя аккаунта из openclaw.json → channels.telegram.accounts
- `method` — метод Telegram Bot API
- `key=value` — параметры метода

## Топики (форум)

```bash
# Создать топик
bash scripts/tg-admin.sh coordinator createForumTopic chat_id=-100XXXXXXXXXX name="Техничка"

# Переименовать
bash scripts/tg-admin.sh coordinator editForumTopic chat_id=-100XXXXXXXXXX message_thread_id=123 name="Новое имя"

# Закрыть / открыть / удалить
bash scripts/tg-admin.sh coordinator closeForumTopic chat_id=-100XXXXXXXXXX message_thread_id=123
bash scripts/tg-admin.sh coordinator reopenForumTopic chat_id=-100XXXXXXXXXX message_thread_id=123
bash scripts/tg-admin.sh coordinator deleteForumTopic chat_id=-100XXXXXXXXXX message_thread_id=123

# Скрыть General
bash scripts/tg-admin.sh coordinator hideGeneralForumTopic chat_id=-100XXXXXXXXXX
```

## Настройки группы

```bash
# Название и описание
bash scripts/tg-admin.sh coordinator setChatTitle chat_id=-100XXXXXXXXXX title="Новое название"
bash scripts/tg-admin.sh coordinator setChatDescription chat_id=-100XXXXXXXXXX description="Описание"

# Инфо
bash scripts/tg-admin.sh coordinator getChat chat_id=-100XXXXXXXXXX
bash scripts/tg-admin.sh coordinator getChatMemberCount chat_id=-100XXXXXXXXXX
```

## Пины

```bash
bash scripts/tg-admin.sh coordinator pinChatMessage chat_id=-100XXXXXXXXXX message_id=456
bash scripts/tg-admin.sh coordinator unpinChatMessage chat_id=-100XXXXXXXXXX message_id=456
bash scripts/tg-admin.sh coordinator unpinAllChatMessages chat_id=-100XXXXXXXXXX
```

## Инвайт-ссылки

```bash
bash scripts/tg-admin.sh coordinator exportChatInviteLink chat_id=-100XXXXXXXXXX
bash scripts/tg-admin.sh coordinator createChatInviteLink chat_id=-100XXXXXXXXXX name="VIP" member_limit=50
```

## Модерация

```bash
bash scripts/tg-admin.sh coordinator banChatMember chat_id=-100XXXXXXXXXX user_id=123456
bash scripts/tg-admin.sh coordinator unbanChatMember chat_id=-100XXXXXXXXXX user_id=123456
bash scripts/tg-admin.sh coordinator promoteChatMember chat_id=-100XXXXXXXXXX user_id=123456 can_manage_topics=true
```

## Требования

- Бот должен быть **админом** группы
- Права: Manage Topics, Delete Messages, Pin Messages, Change Group Info, Invite Users
- Создать группу и включить Topics может только человек — после этого бот управляет всем остальным
