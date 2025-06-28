#!/bin/bash

# ============================================
# VPS Toolbox 工具箱 - By Lucas (behwilly)
# ============================================

# 顏色定義
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[1;34m'
NC='\033[0m' # 無色

# GitHub 原始腳本 URL（供自動更新）
GITHUB_RAW_URL="https://raw.githubusercontent.com/behwilly/vps-toolbox/main/toolbox.sh"
LOCAL_SCRIPT="$0"

# ------------------ 自動更新區段 ------------------
if [[ "$LOCAL_SCRIPT" == "./toolbox.sh" || "$LOCAL_SCRIPT" == "toolbox.sh" ]]; then
  echo -e "${BLUE}🔄 正在檢查腳本更新...${NC}"
  curl -s -o toolbox_latest.sh "$GITHUB_RAW_URL"
  if ! cmp -s toolbox.sh toolbox_latest.sh; then
    mv toolbox_latest.sh toolbox.sh
    chmod +x toolbox.sh
    echo -e "${GREEN}✅ 已自動更新為最新版腳本，請重新執行。${NC}"
    exit 0
  else
    rm -f toolbox_latest.sh
    echo -e "${GREEN}🔍 已是最新版，繼續執行...${NC}"
  fi
fi

# ------------------ 自我提權 ------------------
if [ "$EUID" -ne 0 ]; then
  echo -e "${GREEN}正在嘗試使用 sudo 重新執行腳本...${NC}"
  sudo bash "$0" "$@"
  exit $?
fi

# 分隔線函數
separator() {
  echo -e "${BLUE}----------------------------------------${NC}"
}

# ------------------ 系統功能 ------------------

# 功能 1：更改 root 密碼
change_root_password() {
  separator
  echo -e "${GREEN}⚙️ 更改 root 密碼${NC}"
  read -s -p "請輸入新密碼: " password
  echo ""
  read -s -p "再次輸入確認密碼: " confirm
  echo ""
  if [[ "$password" != "$confirm" || -z "$password" ]]; then
    echo -e "${RED}❌ 密碼不一致或為空，操作已取消。${NC}"
    return
  fi
  echo "root:$password" | chpasswd
  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ root 密碼已成功更改。${NC}"
  else
    echo -e "${RED}❌ 密碼更改失敗。請確認您有 root 權限。${NC}"
  fi
  read -p "按 Enter 返回主選單..." dummy
}

# 功能 2：APT 更新系統
apt_update_upgrade() {
  separator
  echo -e "${GREEN}📦 正在更新 APT 套件清單與系統升級...${NC}"
  apt update && apt upgrade -y
  if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ 系統已更新完成。${NC}"
  else
    echo -e "${RED}❌ 更新過程中發生錯誤。${NC}"
  fi
  read -p "按 Enter 返回主選單..." dummy
}

# ------------------ 寶塔功能 ------------------

# 功能 3：安裝寶塔純淨版
install_bt_pure() {
  separator
  echo -e "${GREEN}正在安裝寶塔面板 9.5.0 純淨版...${NC}"
  echo -e "${BLUE}來源: http://bt950.hostcli.com${NC}"
  separator
  if [ -f /usr/bin/curl ]; then
    curl -sSO http://bt950.hostcli.com/install/install_panel.sh
  else
    wget -O install_panel.sh http://bt950.hostcli.com/install/install_panel.sh
  fi
  bash install_panel.sh www.HostCLi.com
  separator
  echo -e "${GREEN}✅ 安裝流程已完成，請確認是否成功。${NC}"
  read -p "按 Enter 返回主選單..." dummy
}

# 功能 4：查看登入資訊
show_bt_login() {
  separator
  echo -e "${GREEN}正在讀取寶塔面板登入資訊...${NC}"
  bt default
  separator
  echo ""
}

# 功能 5：查看面板狀態
check_bt_status() {
  separator
  echo -e "${GREEN}寶塔面板運行狀態：${NC}"
  bt status
  separator
  echo ""
}

# 功能 6：停止寶塔面板
stop_bt_panel() {
  separator
  echo -e "${RED}⚠️ 正在停止寶塔面板...${NC}"
  bt stop
  separator
  echo ""
}

# 功能 7：啟動寶塔面板
start_bt_panel() {
  separator
  echo -e "${GREEN}正在啟動寶塔面板...${NC}"
  bt start
  separator
  echo ""
}

# 功能 8：重啓所有服務
reload_bt_services() {
  separator
  echo -e "${GREEN}正在重啓所有服務（Web/FTP/DB）...${NC}"
  bt reload
  separator
  echo -e "${GREEN}✅ 所有服務已重新載入。${NC}"
  echo ""
}

# 功能 9：重啓寶塔面板
restart_bt() {
  separator
  echo -e "${GREEN}正在重啓寶塔面板...${NC}"
  bt restart
  separator
  echo -e "${GREEN}✅ 寶塔已重啓完成。${NC}"
  echo ""
}

# ------------------ 主選單 ------------------

show_menu() {
  while true; do
    separator
    echo -e "${GREEN}VPS 工具箱 - 請選擇要執行的功能：${NC}"
    separator
    echo -e "${BLUE}🖥️ 系統功能${NC}"
    echo "  1) 更改 root 密碼"
    echo "  2) APT 更新系統（apt update & upgrade）"
    echo ""
    echo -e "${BLUE}🧩 寶塔功能${NC}"
    echo "  3) 安裝寶塔純淨版 9.5.0"
    echo "  4) 查看登入資訊"
    echo "  5) 查看面板運行狀態"
    echo "  6) 停止寶塔面板"
    echo "  7) 啟動寶塔面板"
    echo "  8) 重啓所有服務"
    echo "  9) 重啓寶塔面板"
    echo ""
    echo "  0) 離開腳本"
    echo ""
    separator
    printf "請輸入數字選項: "
    read choice
    separator

    case "$choice" in
      1) change_root_password ;;
      2) apt_update_upgrade ;;
      3) install_bt_pure ;;
      4) show_bt_login ;;
      5) check_bt_status ;;
      6) stop_bt_panel ;;
      7) start_bt_panel ;;
      8) reload_bt_services ;;
      9) restart_bt ;;
      0) echo -e "${GREEN}已離開腳本，再見 👋${NC}"; exit 0 ;;
      *) echo -e "${RED}❌ 無效的選項，請輸入正確數字。${NC}" ;;
    esac
    echo ""
  done
}

# 執行主選單
show_menu
