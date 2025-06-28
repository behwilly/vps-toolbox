#!/bin/bash

# 顏色樣式
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 幫助訊息
show_help() {
  echo -e "${GREEN}使用方式:${NC} $0 restart_bt"
  echo ""
  echo "可用功能："
  echo "  restart_bt  重啓寶塔面板"
  echo "  help        顯示這個說明"
}

# 功能：重啓寶塔面板
restart_bt() {
  echo -e "${GREEN}正在重啓寶塔面板...${NC}"
  if command -v bt &> /dev/null; then
    bt restart
  else
    echo -e "${RED}錯誤：找不到 bt 指令，請確認寶塔是否已安裝並在 PATH 中。${NC}"
  fi
}

# 主流程
case "$1" in
  restart_bt)
    restart_bt
    ;;
  help|*|"")
    show_help
    ;;
esac
