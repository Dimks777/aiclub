#!/bin/bash
# Фабрика Контента — One-Click Installer
# Пользователь: curl -sSL https://YOUR_SERVER/factory-install.sh | bash

set -e

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"
CHECK="${GREEN}✓${RESET}"
ARROW="${CYAN}→${RESET}"

echo ""
echo -e "  ${BOLD}${CYAN}🏭 Фабрика Контента${RESET}"
echo -e "  ${BOLD}Автоматическая установка${RESET}"
echo -e "  ═══════════════════════════════"
echo ""

# Step 1: Check OpenClaw
echo -ne "  ${ARROW} Проверяю OpenClaw... "
if command -v openclaw &>/dev/null; then
  OC_VER=$(openclaw --version 2>/dev/null | head -1)
  echo -e "${CHECK} ${OC_VER}"
else
  echo -e "${RED}✗ не установлен${RESET}"
  echo ""
  echo -e "  ${BOLD}Сначала установи OpenClaw:${RESET}"
  echo -e "  ${CYAN}curl -fsSL https://openclaw.ai/install.sh | bash${RESET}"
  echo ""
  exit 1
fi

# Step 2: Get token
echo ""
echo -e "  ${BOLD}Шаг 1: Токен доступа${RESET}"
echo -e "  ${CYAN}Получи токен в Telegram: @galsonproAIbot${RESET}"
echo -e "  (открой бота, начни диалог, скопируй токен)"
echo ""
read -p "  Введи токен: " TOKEN

if [ -z "$TOKEN" ]; then
  echo -e "  ${RED}✗ Токен не указан${RESET}"
  exit 1
fi

# Step 3: Verify token
echo -ne "  ${ARROW} Проверяю токен... "
VERIFY=$(curl -sf --connect-timeout 10 --max-time 15 \
  "https://bot.galson.pro/api/install/verify?token=${TOKEN}&platform=$(uname -s | tr '[:upper:]' '[:lower:]')")

if echo "$VERIFY" | grep -q '"ok":true'; then
  TIER=$(echo "$VERIFY" | grep -o '"tier":"[^"]*"' | cut -d'"' -f4)
  USER_NAME=$(echo "$VERIFY" | grep -o '"user":"[^"]*"' | cut -d'"' -f4)
  echo -e "${CHECK} ${GREEN}${USER_NAME} (${TIER})${RESET}"
else
  echo -e "${RED}✗ Токен недействителен${RESET}"
  exit 1
fi

# Step 4: Download constructor skills
echo -ne "  ${ARROW} Скачиваю скиллы... "
SKILLS_TMP=$(mktemp)
HTTP_CODES=$(curl -sfL --connect-timeout 15 --max-time 180 \
  "https://bot.galson.pro/api/skills/constructor?token=${TOKEN}" \
  -o "$SKILLS_TMP" -w "%{http_code}" 2>/dev/null)

if [ "$HTTP_CODES" = "200" ] && [ -s "$SKILLS_TMP" ]; then
  tar xzf "$SKILLS_TMP" -C "$HOME/.openclaw/skills" 2>/dev/null
  rm -f "$SKILLS_TMP"
  SKILLS_COUNT=$(ls -d "$HOME/.openclaw/skills"/*/ 2>/dev/null | wc -l | tr -d ' ')
  echo -e "${CHECK} ${SKILLS_COUNT} скиллов"
else
  rm -f "$SKILLS_TMP"
  echo -e "${RED}✗ ошибка скачивания${RESET}"
  exit 1
fi

# Step 5: Download 5agents/VIP skills
if [ "$TIER" = "5agents" ] || [ "$TIER" = "vip" ]; then
  echo -ne "  ${ARROW} Скиллы 5 Агентов... "
  SKILLS5_TMP=$(mktemp)
  HTTP5=$(curl -sfL --connect-timeout 15 --max-time 120 \
    "https://bot.galson.pro/api/skills/5agents?token=${TOKEN}" \
    -o "$SKILLS5_TMP" -w "%{http_code}" 2>/dev/null)
  
  if [ "$HTTP5" = "200" ] && [ -s "$SKILLS5_TMP" ]; then
    tar xzf "$SKILLS5_TMP" -C "$HOME/.openclaw/skills" 2>/dev/null
    rm -f "$SKILLS5_TMP"
    SKILLS_COUNT=$(ls -d "$HOME/.openclaw/skills"/*/ 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${CHECK} всего ${SKILLS_COUNT} скиллов"
  else
    rm -f "$SKILLS5_TMP"
    echo -e "${YELLOW}⚠ пропущено${RESET}"
  fi
fi

# Step 6: Create agents
AGENTS_STR=$(echo "$VERIFY" | grep -o '"agents":\[[^]]*\]' | tr -d '[]"' | sed 's/"//g;s/,/ /g;s/agents,//')

if [ -n "$AGENTS_STR" ]; then
  echo -e "${ARROW} Создаю агентов..."
  mkdir -p "$HOME/openclaw-factory/agents"
  
  for agent in $AGENTS_STR; do
    AGENT_DIR="$HOME/openclaw-factory/agents/$agent"
    mkdir -p "$AGENT_DIR/memory" "$AGENT_DIR/learning"
    
    echo -ne "    ${ARROW} $agent... "
    
    # SOUL.md
    curl -sf --connect-timeout 10 --max-time 30 \
      "https://bot.galson.pro/api/install/soul/${agent}?token=${TOKEN}" \
      -o "$AGENT_DIR/SOUL.md" 2>/dev/null || true
    
    # AGENTS.md
    curl -sf --connect-timeout 10 --max-time 30 \
      "https://bot.galson.pro/api/install/agent-file/${agent}/agents?token=${TOKEN}" \
      -o "$AGENT_DIR/AGENTS.md" 2>/dev/null || true
    
    # Template files
    [ ! -f "$AGENT_DIR/MEMORY.md" ] && echo "# Memory — $agent" > "$AGENT_DIR/MEMORY.md"
    [ ! -f "$AGENT_DIR/USER.md" ] && printf "# USER.md\n\n- **Name:** (Заполни)\n- **Timezone:** Europe/Moscow\n- **Language:** Russian\n" > "$AGENT_DIR/USER.md"
    [ ! -f "$AGENT_DIR/IDENTITY.md" ] && echo "# IDENTITY.md — $agent" > "$AGENT_DIR/IDENTITY.md"
    [ ! -f "$AGENT_DIR/HEARTBEAT.md" ] && printf "# HEARTBEAT.md\n\n- Quiet hours: 23:00-07:00\n- If nothing to do → HEARTBEAT_OK\n" > "$AGENT_DIR/HEARTBEAT.md"
    [ ! -f "$AGENT_DIR/BOOTSTRAP.md" ] && printf "# BOOTSTRAP.md\n\n1. read SOUL.md + USER.md\n2. read memory/active-context.md\n3. read learning/corrections.md\n4. memory_search on topic\n" > "$AGENT_DIR/BOOTSTRAP.md"
    [ ! -f "$AGENT_DIR/memory/active-context.md" ] && echo "# Active Context" > "$AGENT_DIR/memory/active-context.md"
    [ ! -f "$AGENT_DIR/learning/patterns.md" ] && echo "# Patterns" > "$AGENT_DIR/learning/patterns.md"
    [ ! -f "$AGENT_DIR/learning/anti-patterns.md" ] && echo "# Anti-patterns" > "$AGENT_DIR/learning/anti-patterns.md"
    [ ! -f "$AGENT_DIR/learning/corrections.md" ] && echo "# Corrections" > "$AGENT_DIR/learning/corrections.md"
    
    echo -e "${CHECK}"
  done
fi

echo ""
echo -e "  ${BOLD}${GREEN}${CHECK} Установка завершена!${RESET}"
echo ""
echo -e "  ${BOLD}Следующий шаг:${RESET}"
echo -e "  1. Заполни ${CYAN}USER.md${RESET} для каждого агента"
echo -e "  2. Запусти ${CYAN}openclaw gateway restart${RESET}"
echo -e "  3. Начни общение с Координатором"
echo ""
echo -e "  ${BOLD}🏭 Фабрика Контента готова к работе!${RESET}"
echo ""
