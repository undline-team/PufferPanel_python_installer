#!/usr/bin/env bash

PYTHON_VERSION="3.12.2"
INSTALL_DIR="./python"
ARCHIVE_NAME="Python-${PYTHON_VERSION}.tgz"
PYTHON_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"

checkRoot=on

while getopts "r" opt; do
  case $opt in
    r)
      checkRoot=off
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ "$checkRoot" == "on" ]; then
  if [ "$(id -u)" == "0" ]; then
    echo "Не запускай этот скрипт от root'а, это хуйня. Хочешь так — добавь флаг -r."
    exit 1
  fi
fi

type wget > /dev/null 2>&1 && alias download_file="wget -q -O -" || {
  type curl > /dev/null 2>&1 && alias download_file="curl -sL" || {
    echo "Ни wget, ни curl не установлены. Скачивай руками, разраб ленивая задница."
    exit 1
  }
}

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

if [ -f "bin/python3" ]; then
  echo "[✓] Python уже установлен здесь. Пропускаю установку."
  exit 0
fi

echo "[1/3] Скачиваем Python $PYTHON_VERSION..."
download_file "$PYTHON_URL" > "$ARCHIVE_NAME"

if [ ! -s "$ARCHIVE_NAME" ]; then
  echo "[ERROR] Не удалось скачать Python. Попробуй руками, может, с DNS'ом жопа."
  exit 1
fi

echo "[2/3] Распаковываем архив..."
tar -xzf "$ARCHIVE_NAME"
cd "Python-${PYTHON_VERSION}" || exit 1

echo "[3/3] Собираем Python в $INSTALL_DIR..."
./configure --prefix="$(pwd)/../" > /dev/null
make -j"$(nproc)" > /dev/null
make install > /dev/null

cd ..
rm -rf "Python-${PYTHON_VERSION}" "$ARCHIVE_NAME"

if [ -f "bin/python3" ]; then
  echo "[✓] Python установлен успешно! Используй ./bin/python3"
else
  echo "[ERROR] Что-то пошло не так. Как всегда."
  exit 1
fi
