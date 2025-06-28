<p align="center">
  <img src="https://raw.githubusercontent.com/behwilly/vps-toolbox/main/assets/logo.png" width="180" alt="VPS Toolbox Logo" />
</p>

<h1 align="center">🌐 VPS Toolbox 工具箱</h1>
<p align="center">一個簡潔實用的 VPS 腳本工具，快速管理寶塔面板，適用於 Linux VPS。</p>

<p align="center">
  <img src="https://img.shields.io/badge/script-shell-blue?logo=gnu-bash" />
  <img src="https://img.shields.io/badge/version-1.1.0-green" />
  <img src="https://img.shields.io/badge/license-MIT-lightgrey" />
</p>

---

## 🖼️ 預覽畫面

> 一目了然的功能選單：

![screenshot](https://raw.githubusercontent.com/behwilly/vps-toolbox/main/assets/screenshot-menu.png)

---

## 🧰 功能列表

| 選項 | 功能名稱             | 描述                                        |
|------|----------------------|---------------------------------------------|
| 1    | 安裝寶塔純淨版       | 安裝寶塔 9.5.0 純淨版（無綁定、無廣告）    |
| 2    | 查看登入資訊         | 顯示面板預設帳號、密碼與登入網址           |
| 3    | 查看面板運行狀態     | 顯示寶塔是否正常運作                        |
| 4    | 停止寶塔面板         | 停止 BT 面板（會中斷登入）                  |
| 5    | 啟動寶塔面板         | 手動啟動面板                                |
| 6    | 重啓所有服務         | 重新啟動所有服務（Web / FTP / DB）         |
| 7    | 重啓寶塔面板         | 快速重啓面板主程式                          |
| 0    | 離開腳本             | 結束並離開腳本                              |

---

<br>

## 📦 安裝方式（請選擇其中一種）
<br>

### 🟢 方法一：原始檔方式執行（最簡單）

```bash
curl -o toolbox.sh https://raw.githubusercontent.com/behwilly/vps-toolbox/main/toolbox.sh
chmod +x toolbox.sh
./toolbox.sh
```
📌 此方式會使用預設設定，若沒有 .env 檔則不支援個人化設定。

<br>

### 🟡 方法二：下載 GitHub Release 整套工具包（推薦）

```bash
curl -LO https://github.com/behwilly/vps-toolbox/releases/download/v1.1.0/vps-toolbox.zip
unzip vps-toolbox.zip
cd vps-toolbox
chmod +x toolbox.sh
./toolbox.sh
```
✅ .env 和 README.md 已包含在壓縮包中，方便自訂與參考。

---

⚙️ .env 設定參數說明
你可以透過 .env 來調整腳本行為：
| 變數名              | 功能說明                                                   |
| ---------------- | ------------------------------------------------------ |
| `SCRIPT_VERSION` | 腳本版本編號（顯示用）                                            |
| `DEFAULT_LANG`   | 預設語言（目前支援：zh）                                          |
| `INSTALL_URL`    | 寶塔安裝腳本來源網址                                             |
| `INSTALL_DOMAIN` | 安裝時的識別參數（如 [www.HostCLi.com）](http://www.HostCLi.com）) |
| `ENABLE_LOG`     | 是否啟用 log 紀錄（true / false）                              |
| `LOG_FILE_PATH`  | log 儲存路徑（預設為 `/var/log/vps-toolbox.log`）               |
| `RETURN_TO_MENU` | 執行完功能後是否自動返回主選單                                        |
| `CLEAR_SCREEN`   | 啟動腳本時是否自動清除畫面                                          |

<br>

## 📚 使用說明
*   適用系統：Ubuntu / Debian VPS

*   自動使用 root 權限執行（內建 sudo 提權）

*   支援多次循環執行，每次功能結束會回主選單

*   記錄所有操作日誌（可開關）

<br>

## 👨‍💻 作者資訊
Lucas
<br>
GitHub: behwilly
