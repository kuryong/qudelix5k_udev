#!/bin/bash

# 관리자 권한 확인
if [[ "$EUID" -ne 0 ]]; then
  echo "이 스크립트는 관리자 권한으로 실행해야 합니다."
  exit 1
fi

UDEV_RULES_PATH="/etc/udev/rules.d"
UDEV_FILE_NAME="99-qudelix.rules"
UDEV_FULL_PATH="${UDEV_RULES_PATH}/${UDEV_FILE_NAME}"
UDEV_RULES_CONTENT='SUBSYSTEM=="usb", ATTRS{idVendor}=="0a12", MODE="0660", GROUP="plugdev", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"'

# 파일 존재 여부 확인
if [ -f "${UDEV_FULL_PATH}" ]; then
  read -p "${UDEV_FILE_NAME} 파일이 이미 존재합니다. 삭제하시겠습니까? (y/n) " -r REPLY
  echo    # 개행
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "기존 파일 삭제: ${UDEV_FULL_PATH}"
    rm "${UDEV_FULL_PATH}"
    if [ $? -eq 0 ]; then
      echo "${UDEV_FILE_NAME} 파일이 성공적으로 삭제되었습니다."
    else
      echo "오류: 기존 파일 삭제에 실패했습니다."
      exit 1
    fi
  else
    echo "파일 삭제를 취소합니다. 스크립트를 종료합니다."
  fi
else
  # 파일이 없으면 생성 및 udev 재시작
  echo "${UDEV_FILE_NAME} 파일이 존재하지 않습니다. 생성합니다."
  echo "${UDEV_RULES_CONTENT}" > "${UDEV_FULL_PATH}"
  if [ $? -eq 0 ]; then
    echo "udev 규칙 파일이 성공적으로 생성되었습니다."
    echo "udev 서비스 재시작..."
    systemctl restart udev.service
    if [ $? -eq 0 ]; then
      echo "udev 서비스가 성공적으로 재시작되었습니다."
    else
      echo "오류: udev 서비스 재시작에 실패했습니다."
      exit 1
    fi
  else
    echo "오류: udev 규칙 파일 생성에 실패했습니다."
    exit 1
  fi
fi

exit 0
