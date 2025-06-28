#!/bin/bash

# 顏色設定
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # 無色

# 功能：重啓寶塔
restart_bt() {
  echo -e "${GREEN}正在重啓寶塔面板...${NC}"
  if command -v bt &> /dev/null; then
    bt restart
  else
    echo -e "${RED}錯誤：找不到 bt 指令，請確認寶塔是否已安裝。${NC}"
  fi
}

# 功能清單選單
show_menu() {
  echo -e "${GREEN}VPS 工具箱 - 請選擇要執行的功能：${NC}" > /dev/tty
  echo "1) 重啓寶塔面板" > /dev/tty
  echo "0) 離開" > /dev/tty
  echo "" > /dev/tty
  read -p "請輸入數字選項: " choice < /dev/tty

  case "$choice" in
    1)
      restart_bt
      ;;
    0)
      echo "已離開腳本。" > /dev/tty
      exit 0
      ;;
    *)
      echo -e "${RED}無效的選項，請重新執行腳本。${NC}" > /dev/tty
      exit 1
      ;;
  esac
}

# 主程序
show_menu
