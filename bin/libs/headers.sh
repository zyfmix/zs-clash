#!/usr/bin/env bash

# [Colorizer-@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# 通用配色...
function ebc_success() {
  echo -e "\e[1;32m$1\e[0m"
}

function ebc_info() {
  echo -e "\e[1;36m$1\e[0m"
}

function ebc_warn() {
  echo -e "\e[1;33m$1\e[0m"
}

function ebc_error() {
  echo -e "\e[1;31m$1\e[0m"
}

function ebc_debug() {
  echo -e "\e[1;35m$1\e[0m"
}
