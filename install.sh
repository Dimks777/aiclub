#!/bin/bash
set -e

BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
RESET='\033[0m'
CHECK="${GREEN}✓${RESET}"
ARROW="${CYAN}→${RESET}"
CROSS="${RED}✗${RESET}"

echo ""
echo -e "  ${BOLD}${CYAN}🏭 Фабрика Контента${RESET}"
echo -e "  ${BOLD}One-Command Installer${RESET}"
echo -e "  ${BOLD}AI-система для создания контента${RESET}"
echo -e "  ═══════════════════════════════════════"
echo ""

# === Check prerequisites ===
echo -ne "  ${ARROW} Проверяю систему... "
MISSING=""
command -v curl &>/dev/null || MISSING="$MISSING curl"
command -v tar &>/dev/null || MISSING="$MISSING tar"

if command -v git &>/dev/null; then
  HAS_GIT=true
else
  HAS_GIT=false
  MISSING="$MISSING git"
fi

if command -v node &>/dev/null; then
  HAS_NODE=true
else
  HAS_NODE=false
  MISSING="$MISSING nodejs (v18+)"
fi

if command -v openclaw &>/dev/null; then
  OC_VER=$(openclaw --version 2>/dev/null | head -1)
  HAS_OPENCLAW=true
else
  HAS_OPENCLAW=false
fi

if [ -n "$MISSING" ]; then
  echo -e "${YELLOW}⚠ не хватает:${RESET}${MISSING}"
  if [ -z "$HAS_OPENCLAW" ]; then
    echo -e "\n  ${BOLD}Сначала установи OpenClaw:${RESET}"
    echo -e "  ${CYAN}curl -fsSL https://openclaw.ai/install.sh | bash${RESET}"
  fi
  for dep in $MISSING; do
    case "$dep" in
      git) echo -e "\n  sudo apt install -y git ;;
      curl) echo -e "\n  sudo apt install -y curl ;;
      tar) echo -e "\n  sudo apt install -y tar ;;
      nodejs*) echo -e "\n  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && sudo apt install -y nodejs ;;
    esac
  done
  exit 1
fi

if [ "$HAS_OPENCLAW" = true ]; then
  echo -e "${CHECK} ${OC_VER}"
else
  echo -e "${CROSS} OpenClaw не установлен"
  exit 1
fi

# === Download from GitHub ===
echo ""
echo -ne "  ${ARROW} Скачиваю Фабрику... "

TMPDIR=$(mktemp -d)

if $HAS_GIT; then
  git clone --depth 1 https://github.com/Dimks777/aiclub.git "$TMPDIR/factory" 2>/dev/null
else
  curl -sfL https://github.com/Dimks777/aiclub/archive/main.tar.gz -o "$TMPDIR/factory.tar.gz"
  tar xzf "$TMPDIR/factory.tar.gz" -C "$TMPDIR" 2>/dev/null
  mv "$TMPDIR/aiclub-main" "$TMPDIR/factory" 2>/dev/null || true
fi

if [ -d "$TMPDIR/factory/factory" ]; then
  echo -e "${CHECK} скачано"
else
  echo -e "${CROSS} ошибка скачивания${RESET}"
  rm -rf "$TMPDIR"
  exit 1
fi

# === Install agents ===
echo ""
echo -e "  ${BOLD}Установка агентов...${RESET}"

AGENTS_DIR="$HOME/openclaw-factory/agents"
mkdir -p "$AGENTS_DIR"

for agent_dir in "$TMPDIR/factory/factory/agents"/*/; do
  [ ! -d "$agent_dir" ] && continue
  agent=$(basename "$agent_dir")
  TARGET="$AGENTS_DIR/$agent"
  
  echo -ne "    ${ARROW} $agent... "
  mkdir -p "$TARGET/memory" "$TARGET/learning"
  cp -r "$agent_dir"/* "$TARGET/" 2>/dev/null
  
  # Create missing template files
  [ ! -f "$TARGET/MEMORY.md" ] && echo "# Memory — $agent" > "$TARGET/MEMORY.md"
  [ ! -f "$TARGET/USER.md" ] && printf "# USER.md\n\n- **Name:** (заполни)\n- **Timezone:** (заполни)\n- **Language:** Russian\n" > "$TARGET/USER.md"
  [ ! -f "$TARGET/IDENTITY.md" ] && echo "# IDENTITY.md — $agent" > "$TARGET/IDENTITY.md"
  [ ! -f "$TARGET/HEARTBEAT.md" ] && printf "# HEARTBEAT.md\n\n- Quiet hours: 23:00-07:00\n- If nothing to do → HEARTBEAT_OK\n" > "$TARGET/HEARTBEAT.md"
  [ ! -f "$TARGET/BOOTSTRAP.md" ] && printf "# BOOTSTRAP.md\n\n1. read SOUL.md + USER.md\n2. read memory/active-context.md\n3. read learning/corrections.md\n4. memory_search on topic\n" > "$TARGET/BOOTSTRAP.md"
  [ ! -f "$TARGET/memory/active-context.md" ] && echo "# Active Context" > "$TARGET/memory/active-context.md"
  [ ! -f "$TARGET/learning/patterns.md" ] && echo "# Patterns" > "$TARGET/learning/patterns.md"
  [ ! -f "$TARGET/learning/anti-patterns.md" ] && echo "# Anti-patterns" > "$TARGET/learning/anti-patterns.md"
  [ ! -f "$TARGET/learning/corrections.md" ] && echo "# Corrections" > "$TARGET/learning/corrections.md"
  
  # Create projects dir
  mkdir -p "$HOME/openclaw-factory/projects"
  
  echo -e "${CHECK}"
done

AGENT_COUNT=$(ls -d "$AGENTS_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')

# === Install skills ===
echo ""
echo -ne "  ${ARROW} Установка скиллов... "

SKILLS_TARGET="$HOME/.openclaw/skills"
mkdir -p "$SKILLS_TARGET"

BEFORE=$(ls -d "$SKILLS_TARGET"/*/ 2>/dev/null | wc -l | tr -d ' ')

if [ -d "$TMPDIR/factory/skills" ]; then
  for skill_dir in "$TMPDIR/factory/skills"/*/; do
    [ ! -d "$skill_dir" ] && continue
    skill=$(basename "$skill_dir")
    mkdir -p "$SKILLS_TARGET/$skill"
    cp -r "$skill_dir"/* "$SKILLS_TARGET/$skill/" 2>/dev/null || true
  done
fi

AFTER=$(ls -d "$SKILLS_TARGET"/*/ 2>/dev/null | wc -l | tr -d ' ')
ADDED=$((AFTER - BEFORE))
echo -e "${CHECK} +${ADDED} скиллов (всего ${AFTER})"

# === Cleanup ===
rm -rf "$TMPDIR"

echo ""
echo -e "  ${BOLD}${GREEN}✅ Установка завершена!${RESET}"
echo ""
echo -e "  ${BOLD}Результат:${RESET}"
echo -e "    • ${AGENT_COUNT} агентов → ${CYAN}\~/openclaw-factory/agents/${RESET}"
echo -e "    • ${AFTER} скиллов → ${CYAN}~/.openclaw/skills/${RESET}"
echo ""
echo -e "  ${BOLD}Следующие шаги:${RESET}"
echo -e "    1. Заполни ${CYAN}USER.md${RESET} для своих агентов"
echo -e "    2. Запусти ${CYAN}openclaw gateway restart${RESET}"
echo -e "    3. Начни общение с Координатором"
echo ""
echo -e "  ${BOLD}🏭 Фабрика Контента готова к работе!${RESET}"
echo ""
