# Web-App Docker 開發環境

此存儲庫包含基於前後端分離架構下，使用 PHP 8.3 + Laravel 11 作為後端、Astro 4 + Vue 3 作為開發主要語言，資料庫使用 Mysql 8.4，並結合 phpmyadmin；網站服務使用 Nginx；快取使用 Redis 等，提供完整的開發環境。

特色：
1. 後端主要使用 Laravel/Nova 4 作為後台開發環境（需付費購買）
2. 後端已安裝 l5-swagger，可從 http://localhost:8000/api/documentation 進入。
3. 後端已安裝 Spatie/MediaLibrary 套件作為媒體處理/存放套件。
4. 前後端驗證使用 Laravel/Sanctum。


## 服務概述

### Nginx

- **容器名稱:** nginx
- **端口:** 8000:80
- **卷:** 將 backend 目錄對應到容器內的 `/var/www/html`。
- **依賴:** php、mysql、redis

### PHP

- **容器名稱:** php
- **卷:** 將 backend 目錄對應到容器內的 `/var/www/html`。
- **額外主機:** `host.docker.internal:host-gateway`
- **依賴:** mysql、redis

### MySQL

- **容器名稱:** mysql
- **映射端口:** 3306:3306
- **環境變量:** 
  - `MYSQL_ROOT_PASSWORD`: 設置 MySQL 的 root 密碼
  - `MYSQL_DATABASE`: 設置默認的數據庫名稱
- **卷:** `mysql_data` 對應到容器內的 `/var/lib/mysql`。

### Redis

- **容器名稱:** redis
- **映射端口:** 6379:6379
- **命令:** 啟用持久化及關聯設置

### Composer

- **容器名稱:** composer
- **卷:** 將 backend 目錄對應到容器內的 `/var/www/html`
- **工作目錄:** `/var/www/html`
- **入口點:** `composer --ignore-platform-reqs`
- **依賴:** php

### Artisan

- **容器名稱:** artisan
- **卷:** 將 backend 目錄對應到容器內的 `/var/www/html`
- **工作目錄:** `/var/www/html`
- **入口點:** `php artisan`

### Scheduler

- **容器名稱:** scheduler
- **卷:** 將 backend 目錄對應到容器內的 `/var/www/html`
- **工作目錄:** `/var/www/html`
- **入口點:** `php artisan schedule:work`

### PhpMyAdmin

- **容器名稱:** phpmyadmin
- **映射端口:** 8891:80
- **平台:** `linux/amd64`
- **環境變量:**
  - `PMA_HOST`: mysql
  - `PMA_USER`: root
  - `PMA_PASSWORD`: password
- **依賴:** mysql

### NPM

- **容器名稱:** npm
- **工作目錄:** `/app`
- **卷:** 將 frontend 項目目錄對應到容器內的 `/app`
- **入口點:** `npm`

### Astro

- **容器名稱:** astro
- **工作目錄:** `/app`
- - **映射端口:** 80:3000
- **卷:** 將 frontend 目錄對應到容器內的 `/app`
- **入口點:** `npm`

## 卷

- `mysql_data`: 用於持久化存儲 MySQL 數據。



# Laravel 11
一個基於 Laravel 框架的骨架應用程序，旨在幫助您快速啟動開發。項目包含多個強大的套件，可提升您的開發體驗和功能。

## 環境

- **PHP:** ^8.2
- **框架:** Laravel 11.0
- 其他必要套件詳見 `composer.json` 檔案的 `require` 部分

## 套件

### 主要套件介紹

- **Bolechen/nova-activitylog:** 記錄 Nova 中的活動日誌[連結][https://github.com/bolechen/nova-activitylog]
- **Darkaonline/l5-swagger:** 使用 Swagger 生成 API 文檔[連結][https://github.com/DarkaOnLine/L5-Swagger]
- **Laravel/nova:** 用於後台管理的 Nova [連結][https://nova.laravel.com]
- **Laravel/sanctum:** 驗證與授權[連結][https://laravel.com/docs/11.x/sanctum]
- **Spatie/laravel-activitylog:** 記錄 Laravel 應用中的活動日誌[連結][https://spatie.be/docs/laravel-activitylog/v4/introduction]
- **Spatie/laravel-medialibrary:** 管理應用的媒體檔案[連結][https://spatie.be/docs/laravel-medialibrary/v11/introduction]
- **Ebess/advanced-nova-media-library:** 在 Nova 中使用的媒體檔案[連結][https://github.com/ebess/advanced-nova-media-library]


# 下載＆初始化＆執行

## 下載
git clone --recurse-submodules -j8 https://github.com/royx0612/docker-web-app-development.git <自訂專案名稱>


## 初始化指令
1. 準備 Nova 帳號文件（沒有請購買）：docker compose run --rm composer config http-basic.nova.laravel.com nova-account@domain.com token-key（backend 目錄中產生 auth.json）
2. 安裝後端套件：docker compose run --rm composer --ignore-platform-reqs i 
3. 後端資料庫初始化：docker compose run --rm artisan migrate
4. 後端資料帳號建立：docker compose run --rm artisan nova:user
5. 安裝前端套件：docker compose run --rm npm i


## 使用指南（務必完成初始化）

1. **啟動容器：** 執行 `docker-compose up -d` 啟動所有服務。
2. **前端網址：** 在瀏覽器中訪問 `http://localhost` 。
3. **後端網址：** 在瀏覽器中訪問 `http://localhost:8000`。
4. **後端 Nova 網址：** 在瀏覽器中訪問 `http://localhost:8000/nova`。
5. **資料庫管理** 在瀏覽器中訪問 `http://localhost:8891` 管理 MySQL 數據庫。
6. **管理任務：** 使用 `artisan` 和 `scheduler` 容器管理計畫任務。

## 關閉指令
docker compose down

## 重新編譯 images
docker compose build --no-cache