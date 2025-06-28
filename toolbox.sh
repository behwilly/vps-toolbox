#!/bin/bash

# ========= 顏色定義 =========
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[1;34m'
NC='\033[0m' # 無色

# ========= 預設值定義 =========
SCRIPT_VERSION="1.1.0"
DEFAULT_LANG="zh"
INSTALL_URL="http://bt950.hostcli.com/install/install_panel.sh"
INSTALL_DOMAIN="www.HostCLi.com"
ENABLE_LOG="true"
LOG_FILE_PATH="/var/log/vps-toolbox.log"
RETURN_TO_MENU="true"
CLEAR_SCREEN="true"
BT_PANEL_PORT="8888"
BT_PANEL_PATH="/www/server/panel"

# ========= 讀取 .env =========
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo -e "${RED}⚠️ 未偵測到 .env 檔案，將使用預設值。${NC}"
fi

# ========= 自我提權 =========
if [ "$EUID" -ne 0 ]; then
  echo -e "${GREEN}正在嘗試使用 sudo 重新執行腳本...${NC}"
  sudo bash "$0" "$@"
  exit $?
fi

# ========= 螢幕清除 =========
[ "$CLEAR_SCREEN" = "true" ] && clear

# ========= 分隔線函數 =========
separator() {
  echo -e "${BLUE}----------------------------------------${NC}"
}

# ========= log 函數 =========
log_action() {
  if [ "$ENABLE_LOG" = "true" ]; then
    echo "$(date '+%F %T') [$1] $2" >> "$LOG_FILE_PATH"
  fi
}

# ========= 顯示標題 + 版本 =========
separator
echo -e "${GREEN}VPS 工具箱 - 版本 $SCRIPT_VERSION${NC}"
separator
echo ""

# ========= 功能函數 =========
install_bt_pure() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：安裝寶塔純淨版 9.5.0${NC}"
  log_action "install_bt_pure" "安裝寶塔面板"
  echo -e "${GREEN}正在安裝中... 來源：$INSTALL_URL${NC}"
  separator
  if [ -f /usr/bin/curl ]; then
    curl -sSO "$INSTALL_URL"
  else
    wget -O install_panel.sh "$INSTALL_URL"
  fi
  bash install_panel.sh "$INSTALL_DOMAIN"
  separator
  echo -e "${GREEN}✅ 安裝完成。${NC}"
  [ "$RETURN_TO_MENU" = "true" ] && read -p "按 Enter 返回主選單..." dummy
}

show_bt_login() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：查看登入資訊${NC}"
  log_action "show_bt_login" "查看登入資訊"
  bt default
  separator
}

check_bt_status() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：查看面板運行狀態${NC}"
  log_action "check_bt_status" "查看狀態"
  bt status
  separator
}

stop_bt_panel() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：停止寶塔面板${NC}"
  log_action "stop_bt_panel" "停止面板"
  bt stop
  separator
}

start_bt_panel() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：啟動寶塔面板${NC}"
  log_action "start_bt_panel" "啟動面板"
  bt start
  separator
}

reload_bt_services() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：重啓所有服務${NC}"
  log_action "reload_bt_services" "重啓服務"
  bt reload
  separator
}

restart_bt() {
  separator
  echo -e "${BLUE}[功能] 你選擇了：重啓寶塔面板${NC}"
  log_action "restart_bt" "重啓面板"
  bt restart
  separator
}

# ========= 主選單 =========
show_menu() {
  while true; do
    separator
    echo -e "${GREEN}VPS 工具箱 - 請選擇要執行的功能：${NC}"
    separator
    echo ""
    echo "1) 安裝寶塔純淨版 9.5.0"
    echo "2) 查看登入資訊"
    echo "3) 查看面板運行狀態"
    echo "4) 停止寶塔面板"
    echo "5) 啟動寶塔面板"
    echo "6) 重啓所有服務"
    echo "7) 重啓寶塔面板"
    echo ""
    echo "0) 離開腳本"
    echo ""
    separator
    printf "請輸入數字選項: "
    read choice
    separator

    case "$choice" in
      1) install_bt_pure ;;
      2) show_bt_login ;;
      3) check_bt_status ;;
      4) stop_bt_panel ;;
      5) start_bt_panel ;;
      6) reload_bt_services ;;
      7) restart_bt ;;
      0)
        echo -e "${GREEN}已離開腳本，再見 👋${NC}"
        echo ""
        exit 0
        ;;
      *)
        echo -e "${RED}無效的選項，請輸入 0~7。${NC}"
        ;;
    esac
    echo ""
  done
}

# ========= 開始主選單 =========
show_menu
