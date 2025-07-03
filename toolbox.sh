#!/bin/bash

# ============================================
# VPS Toolbox 工具箱 - By Lucas (behwilly)
# ============================================

# ------------------ 顏色定義 ------------------
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

# ------------------ Banner + 版本 ------------------
clear
echo -e "${BLUE}"
cat << "EOF"
 _   _  ___   __   _____ __   __  _   __  ____   __  
| \ / || _,\/' _/ |_   _/__\ /__\| | |  \/__\ \_/ / 
`\ V /'| v_/`._`.   | || \/ | \/ | |_| -< \/ > , <  
  \_/  |_|  |___/   |_| \__/ \__/|___|__/\__/_/ \_\ 
EOF
echo -e "${GREEN}                    VPS Toolbox v1.1.0${NC}"

# ------------------ 自我提權 ------------------
if [ "$EUID" -ne 0 ]; then
  echo -e "${GREEN}\u6b63\u5728\u5617\u8a66\u4f7f\u7528 sudo \u91cd\u65b0\u57f7\u884c\u8173\u672c...${NC}"
  exec sudo -E env SKIP_UPDATE_CHECK=1 bash "$0" "$@"
fi

# ------------------ 自動更新檢查 ------------------
LOCAL_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
GITHUB_RAW_URL="https://raw.githubusercontent.com/behwilly/vps-toolbox/main/toolbox.sh"

if [[ -z "$SKIP_UPDATE_CHECK" && -f "$LOCAL_SCRIPT" ]]; then
  echo -e "${BLUE}🔄 正在檢查是否有新版腳本...${NC}"
  curl -s -o /tmp/toolbox_latest.sh "$GITHUB_RAW_URL"

  if ! cmp -s "$LOCAL_SCRIPT" /tmp/toolbox_latest.sh; then
    echo -e "${RED}📢 偵測到新版腳本可用！${NC}"
    read -p "是否要立即更新？(y/n): " update_confirm
    if [[ "$update_confirm" =~ ^[Yy]$ ]]; then
      mv /tmp/toolbox_latest.sh "$LOCAL_SCRIPT"
      chmod +x "$LOCAL_SCRIPT"
      echo -e "${GREEN}✅ 已更新為最新版腳本，請重新執行： ./toolbox.sh${NC}"
      exit 0
    else
      echo -e "${YELLOW}⚠️ 已略過更新，繼續執行目前版本。${NC}"
    fi
  else
    rm -f /tmp/toolbox_latest.sh
    echo -e "${GREEN}✅ 已是最新版，繼續執行...${NC}"
  fi
fi

# 分隔線
separator() {
  echo -e "${BLUE}----------------------------------------${NC}"
}

print_header() {
  echo -e "\n${BLUE}===== $1 =====${NC}\n"
}

# ---------- 系統功能 ----------
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

apt_update_upgrade() {
  separator
  echo -e "${BLUE}🔧 更新 APT 套件組合索引${NC}"
  apt update

  if [ $(apt list --upgradable 2>/dev/null | wc -l) -gt 1 ]; then
    echo -e "${BLUE}🔄 升級 APT 套件${NC}"
    apt upgrade -y --allow-downgrades
    echo -e "${BLUE}🔧 清理未使用套件${NC}"
    apt autoremove -y
    echo -e "${GREEN}✅ 系統已升級並清理完成。${NC}"
  else
    echo -e "${YELLOW}📆 沒有可升級套件。${NC}"
  fi
  read -p "按 Enter 返回主選單..." dummy
}

slim_down_system() {
  separator
  echo -e "${BLUE}🧹 正在為系統進行瘦身與清理...${NC}"

  echo -e "${BLUE}- 清除 APT 暫存套件...${NC}"
  apt clean

  echo -e "${BLUE}- 自動移除不需要的套件...${NC}"
  apt autoremove -y

  echo -e "${BLUE}- 清理 journald 舊日誌...${NC}"
  journalctl --vacuum-time=3d

  echo -e "${BLUE}- 清除暫存資料夾 (/tmp)...${NC}"
  rm -rf /tmp/*

  echo -e "${BLUE}- 清除快取資料夾 (/var/tmp)...${NC}"
  rm -rf /var/tmp/*

  echo -e "${GREEN}✅ 系統瘦身完成！空間已釋放。${NC}"
  read -p "按 Enter 返回主選單..." dummy
}

check_disk_usage() {
  separator
  echo -e "${GREEN}📍 磁碟容量概覽。${NC}\n"
  df -hT -x tmpfs -x devtmpfs | awk 'NR==1 || $0 !~ /tmpfs|devtmpfs/ {print $1, $2, $3, $4, $5, $7}' | column -t
  separator
  read -p "按 Enter 返回主選單..." dummy
}

setup_ssh_key_login() {
  separator
  echo -e "${GREEN}🔐 配置 SSH 公鑰登入 (免密登入)${NC}"
  read -p "請輸入您的公鑰內容: " ssh_key

  if [[ -z "$ssh_key" || ! "$ssh_key" =~ ^ssh- ]]; then
    echo -e "${RED}❌ 無效的 SSH 公鑰格式，操作取消。${NC}"
    return
  fi

  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  echo "$ssh_key" >> ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys

  echo -e "${GREEN}✅ SSH 公鑰已成功加入，您現在可以免密登入此 VPS。${NC}"
  separator
  read -p "按 Enter 返回主選單..." dummy
}

# ---------- 寶塔功能 ----------
install_bt_pure() {
  separator
  echo -e "${GREEN}正在安裝寶塔 9.5.0 純淨版...${NC}"
  echo -e "${BLUE}來源: http://bt950.hostcli.com${NC}"
  separator
  if [ -f /usr/bin/curl ]; then
    curl -sSO http://bt950.hostcli.com/install/install_panel.sh
  else
    wget -O install_panel.sh http://bt950.hostcli.com/install/install_panel.sh
  fi
  bash install_panel.sh www.HostCLi.com
  separator
  echo -e "${GREEN}✅ 安裝已完成。${NC}"
  read -p "按 Enter 返回主選單..." dummy
}

show_bt_login() {
  separator
  echo -e "${GREEN}顯示寶塔登入資訊...${NC}"
  bt default
  separator
}

check_bt_status() {
  separator
  echo -e "${GREEN}寶塔面板運行狀態:${NC}"
  bt status
  separator
}

stop_bt_panel() {
  separator
  echo -e "${RED}⛔️ 正在停止寶塔...${NC}"
  bt stop
  separator
}

start_bt_panel() {
  separator
  echo -e "${GREEN}啟動寶塔面板...${NC}"
  bt start
  separator
}

reload_bt_services() {
  separator
  echo -e "${GREEN}重啟所有服務 (Web/FTP/DB)...${NC}"
  bt reload
  separator
  echo -e "${GREEN}✅ 所有服務已重載完成。${NC}"
}

restart_bt() {
  separator
  echo -e "${GREEN}重啟寶塔...${NC}"
  bt restart
  separator
  echo -e "${GREEN}✅ 寶塔已重啟完成。${NC}"
}

# ---------- 主選單 ----------
show_menu() {
  while true; do
    separator
    echo -e "${GREEN}VPS 工具箱 - 請選擇功能:${NC}"
    separator
    echo -e "${BLUE}💻 系統功能${NC}"
    echo "  1) 更改 root 密碼"
    echo "  2) APT 更新系統"
    echo "  3) 一鍵瘦身系統"
    echo "  4) 查看磁碟容量"
    echo "  5) 配置 SSH 公鑰登入 (免密登入)"
    echo ""
    echo -e "${BLUE}🧹 寶塔功能${NC}"
    echo "  6) 安裝寶塔純淨版"
    echo "  7) 查看登入資訊"
    echo "  8) 查看運行狀態"
    echo "  9) 停止寶塔"
    echo " 10) 啟動寶塔"
    echo " 11) 重啟所有服務"
    echo " 12) 重啟寶塔"
    echo ""
    echo "  0) 離開腳本"
    echo ""
    separator
    printf "請輸入選項: "
    read choice
    separator

    case "$choice" in
      1) change_root_password ;;
      2) apt_update_upgrade ;;
     
