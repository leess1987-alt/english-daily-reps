#!/usr/bin/env bash
# Builds index.html from the page source (app.src.html) by wrapping it in a full
# document with PWA / iPhone home-screen tags. Usage: bash build.sh
set -e
cd "$(dirname "$0")"
{
  cat <<'HEAD'
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<link rel="icon" href="icon.png">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="icon-180.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-title" content="English Reps">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="theme-color" content="#2F4BD6">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}[hidden]{display:none!important}</style>
HEAD
  sed 's#^<div class="wrap">#</head>\n<body>\n<div class="wrap">#' app.src.html
  cat <<'FOOT'
<script>if('serviceWorker' in navigator && location.protocol==='https:'){navigator.serviceWorker.register('sw.js').catch(()=>{})}</script>
</body>
</html>
FOOT
} > index.html
echo "built index.html"
