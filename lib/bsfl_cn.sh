#!/usr/bin/env bash
# -*- tab-width: 4; encoding: utf-8 -*-

## \mainpage
## \section 介绍
## Bash Shell 函数库 (BSFL) 是一个小型 Bash 脚本，充当 bash 脚本的库。
## 它提供了一些功能，使大多数人直接使用 shell 脚本更容易一些。

## @file
## @author Louwrentius <louwrentius@gmail.com>
## @author Paul-Emmanuel Raoul <skyper@skyplabs.net>
## @brief Bash Shell 函数库
## @copyright New BSD
## @version 0.1.0
## @par URL
## https://github.com/SkypLabs/bsfl
## @par Purpose
## Bash Shell 函数库 (BSFL) 是一个小型 Bash 脚本，充当 bash 脚本的库。
## 它提供了一些功能，使大多数人直接使用 shell 脚本更容易一些。

# 不要编辑这个文件。只需将其来源到您的脚本中
# 并覆盖变量以更改它们的值。

# 全局变量
# --------------------------------------------------------------#

## @var BSFL_版本
## @brief BSFL 版本号.
declare -rx BSFL_VERSION="0.1.1"

## @var DEBUG
## @brief 启用/禁用调试模式。
## @details 调试模式添加了用于故障排除目的的额外信息。
## Value: yes or no (y / n).
declare -x DEBUG="no"

## @var LOGDATEFORMAT
## @brief 设置日志数据格式（syslog 样式）。
declare -x LOGDATEFORMAT="%FT%T%z"

## @var LOG_FILE
## @brief 设置启用日志时要使用的日志文件。
declare -x LOG_FILE="$0.log"

## @var LOG_ENABLED
## @brief 启用/禁用文件中的日志记录。
## @details Value: yes or no (y / n).
declare -x LOG_ENABLED="no"

## @var SYSLOG_ENABLED
## @brief 启用/禁用日志记录到系统日志。
## @details Value: yes or no (y / n).
declare -x SYSLOG_ENABLED="no"

## @var SYSLOG_TAG
## @brief 与 syslog 一起使用的标记。
## @details Value: yes or no (y / n).
declare -x SYSLOG_TAG="$0"

## @var __START_WATCH
## @brief 内部变量，记录启动计时.
## @private
declare -x __START_WATCH=""

## @var __STACK
## @brief 内部变量，堆
## @private
declare -x __STACK

## @var __TMP_STACK
## @brief 内部变量，临时保存堆操作内容
## @private
declare -x __TMP_STACK

## @var RED
## @brief 内部变量，红色
declare -rx RED="tput setaf 1"

## @var GREEN
## @brief 内部变量，绿色
declare -rx GREEN="tput setaf 2"

## @var YELLOW
## @brief 内部变量，黄色
declare -rx YELLOW="tput setaf 3"

## @var BLUE
## @brief 内部变量，蓝色
declare -rx BLUE="tput setaf 4"

## @var MAGENTA
## @brief 内部变量，品红色
declare -rx MAGENTA="tput setaf 5"

## @var CYAN
## @brief 内部变量，青色
declare -rx CYAN="tput setaf 6"

## @var BOLD
## @brief 内部变量，粗体
declare -rx BOLD="tput bold"

## @var DEFAULT
## @brief 内部变量，恢复默认颜色（0 表示 =“默认再现（实现定义），取消数据流中任何先前出现的 SGR 的影响）
declare -rx DEFAULT="tput sgr0"

## @var RED_BG
## @brief 内部变量，红色背景
declare -rx RED_BG="tput setab 1"

## @var GREEN_BG
## @brief 内部变量，蓝色背景
declare -rx GREEN_BG="tput setab 2"

## @var YELLOW_BG
## @brief 内部变量，黄色背景
declare -rx YELLOW_BG="tput setab 3"

## @var BLUE_BG
## @brief 内部变量，蓝色背景
declare -rx BLUE_BG="tput setab 4"

## @var MAGENTA_BG
## @brief 内部变量，品红背景
declare -rx MAGENTA_BG="tput setab 5"

## @var CYAN_BG
## @brief 内部变量，青色背景
declare -rx CYAN_BG="tput setab 6"

# 全局配置
# --------------------------------------------------------------#

# Bash 的错误修复，解析感叹号。
set +o histexpand

# 函数组
# --------------------------------------------------------------#

## @defgroup array Array
## @defgroup command Command
## @defgroup file_and_dir File and Directory
## @defgroup log Log
## @defgroup message Message
## @defgroup misc Miscellaneous
## @defgroup network Network
## @defgroup stack Stack
## @defgroup string String
## @defgroup time Time
## @defgroup variable Variable

# Functions
# --------------------------------------------------------------#

# 组: 变量
# ----------------------------------------------------#

## @fn defined()
## @ingroup variable
## @brief 测试一个变量是否已经被定义了
## @param 要操作的变量。
## @retval 0 变量被定义了
## @retval 1 其他情况
defined() {
    [[ "${!1-X}" == "${!1-Y}" ]]
}

## @fn has_value()
## @ingroup variable
## @brief 测试变量是否有值。
## @param 要操作的变量。
## @retval 0 变量已定义且值的长度 > 0，则为 0
## @retval 1 其他情况
has_value() {
    defined "$1" && [[ -n ${!1} ]]
}

## @fn option_enabled()
## @ingroup variable
## @brief 检查变量是否设置为“y”或“yes”。
## @details 用于检测是否设置了布尔配置选项。
## @param 要操作的变量。
## @retval 0 如果变量设置为“y”或“yes”，则为 0。
## @retval 1 其他情况
option_enabled() {
    VAR="$1"
    VAR_VALUE=$(eval echo \$"$VAR")
    if [[ "$VAR_VALUE" == "y" ]] || [[ "$VAR_VALUE" == "yes" ]]; then
        return 0
    else
        return 1
    fi
}

# 组: 文件和目录
# ----------------------------------------------------#

## @fn directory_exists()
## @ingroup file_and_dir
## @brief 测试目录是否存在。
## @param 要操作的目录。
## @retval 0 如果目录存在，则为0。
## @retval 1 其他情况
directory_exists() {
    if [[ -d "$1" ]]; then
        return 0
    fi
    return 1
}

## @fn file_exists()
## @ingroup file_and_dir
## @brief 测试文件是否存在
## @param 要操作的文件
## @retval 0 如果目录存在，则为0。
## @retval 1 其他情况
file_exists() {
    if [[ -f "$1" ]]; then
        return 0
    fi
    return 1
}

## @fn device_exists()
## @ingroup file_and_dir
## @brief 测试设备是否存在。
## @param 要操作的设备。
## @retval 0 如果目录存在，则为0。
## @retval 1 其他情况
device_exists() {
    if [[ -b "$1" ]]; then
        return 0
    fi
    return 1
}

# 组: 字符串
# ----------------------------------------------------#

## @fn to_lower()
## @ingroup string
## @brief 将字符串中的大写字符转换为小写
## @param 要操作的字符串
## @return 变为小写后的字符串
to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

## @fn to_upper()
## @ingroup string
## @brief 将字符串中的小写字符转换为大写
## @param 要操作的字符串
## @return 变为大写后的字符串
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

## @fn trim()
## @ingroup string
## @brief 从字符串的两端删除空格。
## @see <a href="https://unix.stackexchange.com/a/102021">Linux Stack Exchange</a>
## @param 要操作的字符串
## @return 从两端去除空格后的字符串。
trim() {
    echo "${1}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# 组: 日志
# ----------------------------------------------------#

## @fn log2syslog()
## @ingroup log
## @brief 使用系统日志记录消息。
## @param 要记录的消息
log2syslog() {
    if option_enabled  SYSLOG_ENABLED; then
        MESSAGE="$1"
        logger -t "$SYSLOG_TAG" " $MESSAGE" # The space is not a typo!
    fi
}

## @fn log()
## @ingroup log
## @brief 在日志文件和/或系统日志中写入消息
## @param 要记录的消息
## @param 消息状态
log() {
    if option_enabled LOG_ENABLED || option_enabled SYSLOG_ENABLED; then
        LOG_MESSAGE="$1"
        STATE="$2"
        DATE=$(date +"$LOGDATEFORMAT")

        if has_value LOG_MESSAGE; then
            LOG_STRING="$DATE $STATE - $LOG_MESSAGE"
        else
            LOG_STRING="$DATE -- empty log message, no input received --"
        fi

        if option_enabled LOG_ENABLED; then
            echo "$LOG_STRING" >> "$LOG_FILE"
        fi

        if option_enabled SYSLOG_ENABLED; then
            # Syslog 已经预先设置了日期/时间戳，因此只记录消息。
            log2syslog "$LOG_MESSAGE"
        fi
    fi
}

## @fn log_status()
## @ingroup log
## @brief 记录一条消息及其状态。
## @details 日志消息的格式是： 状态 + 内容。
## @param 要记录的消息
## @param 消息状态
log_status() {
    if option_enabled LOG_ENABLED; then
        MESSAGE="$1"
        STATUS="$2"

        log "$MESSAGE" "$STATUS"
    fi
}

## @fn log_emergency()
## @ingroup log
## @brief 记录一条状态为“emergency”的消息。
## @param 要记录的消息
log_emergency() {
    MESSAGE="$1"
    STATUS="EMERGENCY"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_alert()
## @ingroup log
## @brief 记录一条状态为“alert”的消息。
## @param 要记录的消息
log_alert() {
    MESSAGE="$1"
    STATUS="ALERT"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_critical()
## @ingroup log
## @brief 记录一条状态为“critical”的消息。
## @param 要记录的消息
log_critical() {
    MESSAGE="$1"
    STATUS="CRITICAL"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_error()
## @ingroup log
## @brief 记录一条状态为“error”的消息。
## @param 要记录的消息
log_error() {
    MESSAGE="$1"
    STATUS="ERROR"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_warning()
## @ingroup log
## @brief 记录一条状态为“warning”的消息。
## @param 要记录的消息
log_warning() {
    MESSAGE="$1"
    STATUS="WARNING"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_notice()
## @ingroup log
## @brief 记录一条状态为“notice”的消息。
## @param 要记录的消息
log_notice() {
    MESSAGE="$1"
    STATUS="NOTICE"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_info()
## @ingroup log
## @brief 记录一条状态为“info”的消息。
## @param 要记录的消息
log_info() {
    MESSAGE="$1"
    STATUS="INFO"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_debug()
## @ingroup log
## @brief 记录一条状态为“debug”的消息。
## @param 要记录的消息
log_debug() {
    MESSAGE="$1"
    STATUS="DEBUG"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_ok()
## @ingroup log
## @brief 记录一条状态为“ok”的消息。
## @param 要记录的消息
log_ok() {
    MESSAGE="$1"
    STATUS="OK"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_not_ok()
## @ingroup log
## @brief 记录一条状态为“not ok”的消息。
## @param 要记录的消息
log_not_ok() {
    MESSAGE="$1"
    STATUS="NOT_OK"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_failed()
## @ingroup log

## @brief 记录一条状态为“failed”的消息。
## @param 要记录的消息
log_failed() {
    MESSAGE="$1"
    STATUS="FAILED"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_success()
## @ingroup log
## @brief 记录一条状态为“success”的消息。
## @param 要记录的消息
log_success() {
    MESSAGE="$1"
    STATUS="SUCCESS"
    log_status "$MESSAGE" "$STATUS"
}

## @fn log_passed()
## @ingroup log
## @brief 记录一条状态为“passed”的消息。
## @param 要记录的消息
log_passed() {
    MESSAGE="$1"
    STATUS="PASSED"
    log_status "$MESSAGE" "$STATUS"
}

# 组: 消息
# ----------------------------------------------------#

## @fn msg()
## @ingroup message
## @brief 类似于“echo”功能，但具有额外的功能。
## @details 这个函数基本上取代了 bash 脚本中的“echo”函数，附加功能是记录和使用颜色。
## @param 要显示的消息。
## @param 文本颜色
msg() {
    MESSAGE="$1"
    COLOR="$2"

    if ! has_value COLOR; then
        COLOR="$DEFAULT"
    fi

    if has_value "MESSAGE"; then
        $COLOR
        echo "$MESSAGE"
        $DEFAULT
        if ! option_enabled "DONOTLOG"; then
            log "$MESSAGE"
        fi
    else
        echo "-- no message received --"
        if ! option_enabled "DONOTLOG"; then
            log "$MESSAGE"
        fi
    fi
}

## @fn msg_status()
## @ingroup message
## @brief 在行尾显示一条消息及其状态。
## @param 要显示的消息。
## @param 要记录的消息
msg_status() {
    MESSAGE="$1"
    STATUS="$2"

    export DONOTLOG="yes"
    log_status "$MESSAGE" "$STATUS"
    msg "$MESSAGE"
    display_status "$STATUS"
    export DONOTLOG="no"
}

## @fn msg_emerg
## @ingroup message
## @brief 显示消息以'emergency'状态.
## @param 要显示的消息。
msg_emergency() {
    MESSAGE="$1"
    STATUS="EMERGENCY"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_alert()
## @ingroup message
## @brief 显示消息以'alert'状态.
## @param 要显示的消息。
msg_alert() {
    MESSAGE="$1"
    STATUS="ALERT"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_critical()
## @ingroup message
## @brief 显示消息以'critical'状态.
## @param 要显示的消息。
msg_critical() {
    MESSAGE="$1"
    STATUS="CRITICAL"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_error()
## @ingroup message
## @brief 显示消息以'error'状态.
## @param 要显示的消息。
msg_error() {
    MESSAGE="$1"
    STATUS="ERROR"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_warning()
## @ingroup message
## @brief 显示消息以'warning'状态.
## @param 要显示的消息。
msg_warning() {
    MESSAGE="$1"
    STATUS="WARNING"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_notice()
## @ingroup message
## @brief 显示消息以'notice'状态.
## @param 要显示的消息。
msg_notice() {
    MESSAGE="$1"
    STATUS="NOTICE"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_info()
## @ingroup message
## @brief 显示消息以'info'状态.
## @param 要显示的消息。
msg_info() {
    MESSAGE="$1"
    STATUS="INFO"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_debug()
## @ingroup message
## @brief 显示消息以'debug'状态.
## @param 要显示的消息。
msg_debug() {
    MESSAGE="$1"
    STATUS="DEBUG"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_ok()
## @ingroup message
## @brief 显示消息以'ok'状态.
## @param 要显示的消息。
msg_ok() {
    MESSAGE="$1"
    STATUS="OK"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_not_ok()
## @ingroup message
## @brief 显示消息以'not ok'状态.
## @param 要显示的消息。
msg_not_ok() {
    MESSAGE="$1"
    STATUS="NOT_OK"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_failed()
## @ingroup message
## @brief 显示消息以'failed'状态.
## @param 要显示的消息。
msg_failed() {
    MESSAGE="$1"
    STATUS="FAILED"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_success()
## @ingroup message
## @brief 显示消息以'success'状态.
## @param 要显示的消息。
msg_success() {
    MESSAGE="$1"
    STATUS="SUCCESS"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn msg_passed()
## @ingroup message
## @brief 显示消息以'passed'状态.
## @param 要显示的消息。
msg_passed() {
    MESSAGE="$1"
    STATUS="PASSED"
    msg_status "$MESSAGE" "$STATUS"
}

## @fn __raw_status()
## @ingroup message
## @brief 内部使用
## @private
## @details 此函数只是将光标定位到右上一行。然后它打印消息以使用指定的颜色显示。它用于在屏幕右侧显示彩色状态消息。
## @param 要记录的消息
## @param 消息颜色
__raw_status() {
    STATUS="$1"
    COLOR="$2"

    position_cursor () {
        ((RES_COL=$(tput cols)-12))
        tput cuf "$RES_COL"
        tput cuu1
    }

    position_cursor
    echo -n "["
    $DEFAULT
    $BOLD
    $COLOR
    echo -n "$STATUS"
    $DEFAULT
    echo "]"
}

## @fn display_status()
## @ingroup message
## @brief 在屏幕右侧显示指定的消息状态。
## @param 要显示的消息状态。
display_status() {
    STATUS="$1"

    case $STATUS in
        EMERGENCY )
            STATUS="EMERGENCY"
            COLOR="$RED"
            ;;
        ALERT )
            STATUS="  ALERT  "
            COLOR="$RED"
            ;;
        CRITICAL )
            STATUS="CRITICAL "
            COLOR="$RED"
            ;;
        ERROR )
            STATUS="  ERROR  "
            COLOR="$RED"
            ;;
        WARNING )
            STATUS=" WARNING "
            COLOR="$YELLOW"
            ;;
        NOTICE )
            STATUS=" NOTICE  "
            COLOR="$BLUE"
            ;;
        INFO )
            STATUS="  INFO   "
            COLOR="$CYAN"
            ;;
        DEBUG )
            STATUS="  DEBUG  "
            COLOR="$DEFAULT"
            ;;
        OK  )
            STATUS="   OK    "
            COLOR="$GREEN"
            ;;
        NOT_OK)
            STATUS=" NOT OK  "
            COLOR="$RED"
            ;;
        PASSED )
            STATUS=" PASSED  "
            COLOR="$GREEN"
            ;;
        SUCCESS )
            STATUS=" SUCCESS "
            COLOR="$GREEN"
            ;;
        FAILURE | FAILED )
            STATUS=" FAILED  "
            COLOR="$RED"
            ;;
        *)
            STATUS="UNDEFINED"
            COLOR="$YELLOW"
    esac

    __raw_status "$STATUS" "$COLOR"
}

# 组: 命令
# ----------------------------------------------------#

## @fn cmd()
## @ingroup command
## @brief 执行命令并显示其状态（“OK”或“FAILED”）。
## @param 要执行的命令。
cmd() {
    COMMAND="$*"
    msg "Executing: $COMMAND"

    RESULT=$(eval "$COMMAND" 2>&1)
    ERROR="$?"

    MSG="Command: ${COMMAND:0:29}..."

    tput cuu1

    if [ "$ERROR" == "0" ]; then
        msg_ok "$MSG"
        if option_enabled DEBUG; then
            msg "$RESULT"
        fi
    else
        msg_failed "$MSG"
        log "$RESULT"
    fi

    return "$ERROR"
}

# Group: Time
# ----------------------------------------------------#

## @fn now()
## @ingroup time
## @brief 显示当前时间戳。
## @return 当前时间戳
now() {
    date +%s
}

## @fn elapsed()
## @ingroup time
## @brief 显示“start”和“stop”之间经过的时间
## parameters.
## @param 开始时间戳
## @param 停止时间戳
## @return Time elapsed between the 'start' and 'stop' parameters.
## @return “start”和“stop”参数之间经过的时间。
elapsed() {
    START="$1"
    STOP="$2"

    ELAPSED=$(( STOP - START ))
    echo $ELAPSED
}

## @fn start_watch()
## @ingroup time
## @brief 开始计时
start_watch() {
    __START_WATCH=$(now)
}

## @fn stop_watch()
## @ingroup time
## @brief 停止计时并显示经过的时间。
## @retval 0 计时成功
## @retval 1 计时没有启动
## @return 自计时启动以来经过的时间
stop_watch() {
    if has_value __START_WATCH; then
        STOP_WATCH=$(now)
        elapsed "$__START_WATCH" "$STOP_WATCH"
        return 0
    else
        return 1
    fi
}

# 组: 杂项
# ----------------------------------------------------#

## @fn die()
## @ingroup misc
## @brief 将错误消息打印到 stderr 并以作为参数给出的错误代码退出。该消息也被记录。
## @param errcode 错误码
## @param errmsg 错误消息
die() {
    local -r err_code="$1"
    local -r err_msg="$2"
    local -r err_caller="${3:-$(caller 0)}"

    msg_failed "ERROR: $err_msg"
    msg_failed "ERROR: At line $err_caller"
    msg_failed "ERROR: Error code = $err_code"
    exit "$err_code"
} >&2 # 函数写入标准错误

## @fn die_if_false()
## @ingroup misc
## @brief 如果上一个命令失败（如果其错误代码不是“0”），则显示一条错误消息并退出。
## @param errcode 错误码
## @param errmsg 错误消息
die_if_false() {
    local -r err_code=$1
    local -r err_msg=$2
    local -r err_caller=$(caller 0)

    if [[ "$err_code" != "0" ]]; then
        die "$err_code" "$err_msg" "$err_caller"
    fi
} >&2 # 函数写入标准错误

## @fn die_if_true()
## @ingroup misc
## @brief 如果上一个命令失败（如果其错误代码不是“0”），则显示一条错误消息并退出。
## @param errcode 错误码
## @param errmsg 错误消息
die_if_true() {
    local -r err_code=$1
    local -r err_msg=$2
    local -r err_caller=$(caller 0)

    if [[ "$err_code" == "0" ]]; then
        die "$err_code" "$err_msg" "$err_caller"
    fi
} >&2 # 函数写入标准错误

# 组: 数组
# ----------------------------------------------------#

## @fn __array_append()
## @ingroup array
## @brief 内部使用
## @private
## @param array 数组名
## @param 要追加的item
# shellcheck disable=SC2016
__array_append() {
    echo -n 'eval '
    echo -n "$1" # 数组名
    echo -n '=( "${'
    echo -n "$1"
    echo -n '[@]}" "'
    echo -n "$2" # 需要追加的item
    echo -n '" )'
}

## @fn __array_append_first()
## @ingroup array
## @brief 内部使用
## @private
## @param array 数组名
## @param 要追加的item
__array_append_first() {
    echo -n 'eval '
    echo -n "$1" # 数组名
    echo -n '=( '
    echo -n "$2" # 需要追加的item
    echo -n ' )'
}

## @fn __array_len()
## @ingroup array
## @brief 内部使用
## @private
## @param 变量名
## @param array 数组名
# shellcheck disable=SC2016
__array_len() {
    echo -n 'eval local '
    echo -n "$1" # variable name
    echo -n '=${#'
    echo -n "$2" # 数组名
    echo -n '[@]}'
}

## @fn array_append()
## @ingroup array
## @brief 将一项或多项附加到数组。
## @details 如果数组不存在，此函数将创建它。
## @param array 要操作的数组
# shellcheck disable=SC2091
array_append() {
    local array=$1; shift 1
    local len

    $(__array_len len "$array")

    if (( len == 0 )); then
        $(__array_append_first "$array" "$1" )
        shift 1
    fi

    local i
    for i in "$@"; do
        $(__array_append "$array" "$i")
    done
}

## @fn array_size()
## @ingroup array
## @brief 返回数组大小
## @param array 要操作的数组
## @return 作为参数给出的数组的大小。
# shellcheck disable=SC2091
array_size() {
    local size

    $(__array_len size "$1")
    echo "$size"
}

## @fn array_print()
## @ingroup array
## @brief 打印数组的内容。
## @param array 要操作的数组
## @return 作为参数给出的数组的内容。
array_print() {
    eval "printf '%s\n' \"\${$1[@]}\""
}

# 组: 字符串
# ----------------------------------------------------#

## @fn str_replace()
## @ingroup string
## @brief 替换字符串中的一些文本。
## @param 被替换的文本
## @param 替换的文本
## @param 被操作的数据
## @return 替换后的数据
str_replace() {
    local ORIG="$1"
    local DEST="$2"
    local DATA="$3"

    echo "${DATA//$ORIG/$DEST}"
}

## @fn str_replace_in_file()
## @ingroup string
## @brief 替换文件中的一些文本
## @param 被替换的文本
## @param 替换的文本
## @param file File to operate on.
## @retval 0 如果原始内容已被替换。
## @retval 1 如果发生错误。
str_replace_in_file() {
    [[ $# -lt 3 ]] && return 1

    local ORIG="$1"
    local DEST="$2"

    for FILE in "${@:3:$#}"; do
        file_exists "$FILE" || return 1

        printf ',s/%s/%s/g\nw\nQ' "${ORIG}" "${DEST}" | ed -s "$FILE" > /dev/null 2>&1 || return "$?"
    done

    return 0
}

# Group: Stack
# ----------------------------------------------------#

## @fn __stack_push_tmp()
## @ingroup stack
## @brief 内部使用
## @private
## @param item 要添加到临时堆栈的item
__stack_push_tmp() {
    local TMP="$1"

    if has_value __TMP_STACK; then
        __TMP_STACK="${__TMP_STACK}"$'\n'"${TMP}"
    else
        __TMP_STACK="$TMP"
    fi
}

## @fn stack_push()
## @ingroup stack
## @brief 在堆栈上添加一个item。
## @param 添加的item
stack_push() {
    line="$1"

    if has_value __STACK; then
        __STACK="${line}"$'\n'"${__STACK}"
    else
        __STACK="$line"
    fi
}

## @fn stack_pop()
## @ingroup stack
## @brief 移除堆栈的最高项并将其放入“REGISTER”变量中。
## @retval 0 成功
## @retval 1 其他情况
stack_pop() {
    __TMP_STACK=""
    i=0
    tmp=""
    for x in $__STACK; do
        if [ "$i" == "0" ]; then
            tmp="$x"
        else
            __stack_push_tmp "$x"
        fi
        ((i++))
    done
    __STACK="$__TMP_STACK"
    REGISTER="$tmp"
    if [ -z "$REGISTER" ]; then
        return 1
    else
        return 0
    fi
}

# 组: 网络
# ----------------------------------------------------#

## @fn is_ipv4()
## @ingroup network
## @brief 测试是否是一个ipv4的地址
## @param 被测试的地址
## @retval 0 是ipv4的地址
## @retval 1 其他情况
is_ipv4() {
    local -r regex='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

    [[ $1 =~ $regex ]]
    return $?
}

## @fn is_fqdn()
## @ingroup network
## @brief 测试 FQDN：完全合格域名（英语：Fully qualified domain name），缩写为FQDN
## @param 被测试的FQDN
## @retval 0 是FQDN
## @retval 1 其他情况
is_fqdn() {
    echo "$1" | grep -Pq '(?=^.{4,255}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}\.?$)'

    return $?
}

## @fn is_ipv4_netmask()
## @ingroup network
## @brief 测试 IPv4 十进制网络掩码是否有效。
## @param 被测试的IPv4 十进制网络掩码
## @retval 0 IPv4 十进制网络掩码有效
## @retval 1 其他情况
# shellcheck disable=SC2154
is_ipv4_netmask() {
    is_ipv4 "$1" || return 1

    IFS='.' read -r ipb[1] ipb[2] ipb[3] ipb[4] <<< "$1"

    local -r list_msb='0 128 192 224 240 248 252 254'

    for i in {1,2,3,4}; do
        if [[ $rest_to_zero ]]; then
            [[ ${ipb[i]} -eq 0 ]] || return 1
        else
            if [[ $list_msb =~ (^|[[:space:]])${ipb[i]}($|[[:space:]]) ]]; then
                local -r rest_to_zero=1
            elif [[ ${ipb[i]} -eq 255 ]]; then
                continue
            else
                return 1
            fi
        fi
    done

    return 0
}

## @fn is_ipv4_cidr()
## @ingroup network
## @brief 测试 IPv4 CIDR 网络掩码 ：无类别域间路由（英语：Classless Inter-Domain Routing，简称CIDR）
## @param 被测试的CIRD
## @retval 0 IPv4 CIDR 网络掩码有效
## @retval 1 其他情况
is_ipv4_cidr() {
    local -r regex='^[[:digit:]]{1,2}$'

    [[ $1 =~ $regex ]] || return 1
    [ "$1" -gt 32 ] || [ "$1" -lt 0 ] && return 1

    return 0
}

## @fn is_ipv4_subnet()
## @ingroup network
## @brief 测试 IPv4 子网。
## @param 使用带/CIDR进行测试的子网。
## @retval 0 子网有效
## @retval 1 其他情况
is_ipv4_subnet() {
    IFS='/' read -r tip tmask <<< "$1"

    is_ipv4_cidr "$tmask" || return 1
    is_ipv4 "$tip" || return 1

    return 0
}

## @fn get_ipv4_network()
## @ingroup network
## @brief 计算 IPv4 子网的网络地址。
## @param IPv4 地址.
## @param IPv4 掩码.
## @retval 0 IPv4 地址以及掩码有效
## @retval 1 其他情况
## @return 网络地址
get_ipv4_network() {
    is_ipv4 "$1" || return 1
    is_ipv4_netmask "$2" || return 1

    IFS='.' read -r ipb1 ipb2 ipb3 ipb4 <<< "$1"
    IFS='.' read -r mb1 mb2 mb3 mb4 <<< "$2"

    echo "$((ipb1 & mb1)).$((ipb2 & mb2)).$((ipb3 & mb3)).$((ipb4 & mb4))"
}

## @fn get_ipv4_broadcast()
## @ingroup network
## @brief 计算 IPv4 子网的广播地址。
## @param IPv4 地址.
## @param IPv4 掩码.
## @retval 0 IPv4 子网的广播地址有效
## @retval 1 其他情况
## @return 广播地址
get_ipv4_broadcast() {
    is_ipv4 "$1" || return 1
    is_ipv4_netmask "$2" || return 1

    IFS='.' read -r ipb1 ipb2 ipb3 ipb4 <<< "$1"
    IFS='.' read -r mb1 mb2 mb3 mb4 <<< "$2"

    nmb1=$((mb1 ^ 255))
    nmb2=$((mb2 ^ 255))
    nmb3=$((mb3 ^ 255))
    nmb4=$((mb4 ^ 255))

    echo "$((ipb1 | nmb1)).$((ipb2 | nmb2)).$((ipb3 | nmb3)).$((ipb4 | nmb4))"
}

## @fn mask2cidr()
## @ingroup network
## @brief 将 IPv4 十进制网络掩码表示法转换为 CIDR。
## @param 要转换的十进制网络掩码。
## @retval 0 输入参数有效。
## @retval 1 其他情况
## @return 十进制表示法的CIDR。
mask2cidr() {
    is_ipv4_netmask "$1" || return 1

    local x=${1##*255.}
    set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) "${x%%.*}"
    x=${1%%$3*}
    echo $(( $2 + (${#x}/4) ))
}

## @fn cidr2mask()
## @ingroup network
## @brief 将 CIDR 表示法转换为 IPv4 十进制网络掩码。
## @param 要转换的网络掩码 CIDR。
## @retval 0 输入参数有效。
## @retval 1 其他情况
## @return 十进制表示法的IPv4 网络掩码。
cidr2mask() {
    is_ipv4_cidr "$1" || return 1

    local i mask=""
    local full_octets=$(($1/8))
    local partial_octet=$(($1%8))

    for ((i=0;i<4;i+=1)); do
        if [ "$i" -lt $full_octets ]; then
            mask+=255
        elif [ "$i" -eq $full_octets ]; then
            mask+=$((256 - 2**(8-partial_octet)))
        else
            mask+=0
        fi

        test "$i" -lt 3 && mask+=.
    done

    echo $mask
}
