#!/bin/bash

#================================================================================
# المشغل الرئيسي لأدوات Aljailane
# الإصدار: 2.5 (إصلاح نهائي للمسارات باستخدام readlink)
# المؤلف: تم إنشاؤه وتطويره بواسطة aljailane
# الوصف: واجهة رسومية نصية احترافية لتشغيل مجموعة أدوات إدارة الخادم.
#================================================================================

# --- إعدادات الأمان والخروج عند الخطأ ---
set -uo pipefail

# --- [FINAL FIX] تحديد مسار السكربت الحقيقي، حتى عند استدعائه عبر رابط رمزي ---
# readlink -f يضمن أننا نحصل على المسار الفعلي للملف وليس مسار الرابط.
SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# --- تعريف الألوان ---
C_RESET='\033[0m'; C_BOLD='\033[1m'; C_RED='\033[0;31m'; C_GREEN='\033[0;32m';
C_YELLOW='\033[0;33m'; C_BLUE='\033[0;34m'; C_CYAN='\033[0;36m'; C_MAGENTA='\033[0;35m';

# --- استخدام المسارات المطلقة الصحيحة للسكربتات الفرعية ---
SCANNER_SCRIPT="$SCRIPT_DIR/sec.sh"
ANALYTICS_SCRIPT="$SCRIPT_DIR/an.sh"

# --- مصفوفة اللغة المتقدمة ---
declare -A TEXTS
SELECTED_LANG="en" # لغة افتراضية

# ... (بقية الكود الكامل لـ launcher.sh كما هو دون تغيير) ...
# لقد قمت فقط بتغيير الأسطر الخمسة الأولى، كل ما يليها يبقى كما هو.

load_texts() {
    # Arabic Texts
    TEXTS[ar_main_welcome]="مرحبا بك في لوحة تحكم أدوات Aljailane"
    TEXTS[ar_choose_tool]="الرجاء تحديد الأداة المطلوبة:"
    TEXTS[ar_tool_analytics]="🔍 التحليلات المتقدمة"
    TEXTS[ar_tool_scanner]="🛡️ فحص الفيروسات والأمان"
    TEXTS[ar_tool_help]="❓ مساعدة"
    TEXTS[ar_tool_about]="ℹ️ حول الأداة"
    TEXTS[ar_tool_close]="🚪 إغلاق"
    TEXTS[ar_invalid_option]="خيار غير صالح. يرجى المحاولة مرة أخرى."
    TEXTS[ar_goodbye]="شكرًا لاستخدامك أدوات Aljailane. إلى اللقاء!"
    TEXTS[ar_press_enter]="اضغط على Enter للعودة..."
    TEXTS[ar_help_header]="========== مساعدة المشغل الرئيسي =========="
    TEXTS[ar_help_analytics]="يقوم بتشغيل أداة التحليل المتقدم للملفات والمساحة."
    TEXTS[ar_help_scanner]="يقوم بتشغيل أداة فحص الفيروسات المتقدمة (ClamAV)."
    TEXTS[ar_help_help]="يعرض شاشة المساعدة هذه."
    TEXTS[ar_help_about]="يعرض معلومات حول لوحة التحكم."
    TEXTS[ar_help_close]="يخرج من البرنامج بشكل آمن."
    TEXTS[ar_about_header]="============ حول لوحة التحكم ============"
    TEXTS[ar_about_desc_1]="هذه هي لوحة التحكم الرئيسية لمجموعة أدوات Aljailane."
    TEXTS[ar_about_desc_2]="تم تصميمها لتكون نقطة انطلاق مركزية وسهلة الاستخدام"
    TEXTS[ar_about_desc_3]="للوصول إلى مختلف سكربتات إدارة وأمان الخادم."
    TEXTS[ar_about_version]="الإصدار: 2.5"
    TEXTS[ar_about_author]="تم إنشاؤها وتطويرها بواسطة aljailane"
    TEXTS[ar_script_not_found]="خطأ: ملف الأداة '%s' غير موجود. يرجى التأكد من وجوده في نفس المجلد."

    # English Texts
    TEXTS[en_main_welcome]="Welcome to the Aljailane Tools Dashboard"
    TEXTS[en_choose_tool]="Please select the desired tool:"
    TEXTS[en_tool_analytics]="🔍 Advanced Analytics"
    TEXTS[en_tool_scanner]="🛡️ Security & Virus Scanner"
    TEXTS[en_tool_help]="❓ Help"
    TEXTS[en_tool_about]="ℹ️ About"
    TEXTS[en_tool_close]="🚪 Exit"
    TEXTS[en_invalid_option]="Invalid option. Please try again."
    TEXTS[en_goodbye]="Thank you for using Aljailane Tools. Goodbye!"
    TEXTS[en_press_enter]="Press Enter to return..."
    TEXTS[en_help_header]="========== Main Launcher Help =========="
    TEXTS[en_help_analytics]="Runs the advanced tool for file and space analysis."
    TEXTS[en_help_scanner]="Runs the advanced virus scanning tool (ClamAV)."
    TEXTS[en_help_help]="Displays this help screen."
    TEXTS[en_help_about]="Displays information about this dashboard."
    TEXTS[en_help_close]="Exits the program safely."
    TEXTS[en_about_header]="============ About The Dashboard ============"
    TEXTS[en_about_desc_1]="This is the main dashboard for the Aljailane tool suite."
    TEXTS[en_about_desc_2]="It is designed as a central and user-friendly starting point"
    TEXTS[en_about_desc_3]="to access various server management and security scripts."
    TEXTS[en_about_version]="Version: 2.5"
    TEXTS[en_about_author]="Created and developed by aljailane"
    TEXTS[en_script_not_found]="Error: The tool script '%s' was not found. Please ensure it is in the same directory."
}

L() { local key="${SELECTED_LANG}_$1"; if [[ -v TEXTS[$key] ]]; then echo "${TEXTS[$key]}"; elif [[ -v TEXTS[en_$1] ]]; then echo "${TEXTS[en_$1]}"; else echo "[$1:TEXT_NOT_FOUND]"; fi; }
print_logo() { printf "${C_BOLD}${C_CYAN}"; cat << "EOF"
    █████╗ ██╗      ██████╗ ██╗ ██╗ ██╗   ██╗ ███╗   ██╗███████╗
   ██╔══██╗██║     ██╔════╝ ██║ ██║ ██║   ██║ ████╗  ██║██╔════╝
   ███████║██║     ██║  ███╗███████║ ██║   ██║ ██╔██╗ ██║█████╗  
   ██╔══██║██║     ██║   ██║██╔══██║ ██║   ██║ ██║╚██╗██║██╔══╝  
   ██║  ██║███████╗╚██████╔╝██║  ██║ ╚██████╔╝ ██║ ╚████║███████╗
   ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝  ╚═════╝  ╚═╝  ╚═══╝╚══════╝
EOF
printf "${C_RESET}"; }

show_main_help() { clear; print_logo; echo -e "\n${C_BOLD}${C_YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_CYAN}$(L help_header)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╠══════════════════════════════════════════════════════════════════════════════╣${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}1- $(L tool_analytics):${C_RESET} $(L help_analytics)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}2- $(L tool_scanner):${C_RESET} $(L help_scanner)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}3- $(L tool_help):${C_RESET} $(L help_help)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}4- $(L tool_about):${C_RESET} $(L help_about)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_RED}5- $(L tool_close):${C_RESET} $(L help_close)"; echo -e "${C_BOLD}${C_YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${C_RESET}"; echo ""; read -p "$(L press_enter)"; }
show_main_about() { clear; print_logo; echo -e "\n${C_BOLD}${C_YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_CYAN}$(L about_header)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╠══════════════════════════════════════════════════════════════════════════════╣${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  $(L about_desc_1)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  $(L about_desc_2)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  $(L about_desc_3)"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}    ${C_GREEN}$(L about_version)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}    ${C_GREEN}$(L about_author)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${C_RESET}"; echo ""; read -p "$(L press_enter)"; }
run_script() { local script_path=$1; if [ ! -f "$script_path" ]; then printf "\n${C_RED}"; printf "$(L script_not_found)" "$script_path"; printf "${C_RESET}\n"; sleep 3; return; fi; clear; bash "$script_path" "$SELECTED_LANG"; }

main_hub_menu() { while true; do clear; print_logo; echo -e "\n${C_BOLD}${C_YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_CYAN}$(L main_welcome)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╠══════════════════════════════════════════════════════════════════════════════╣${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}1) $(L tool_analytics)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}2) $(L tool_scanner)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_CYAN}3) $(L tool_help)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_CYAN}4) $(L tool_about)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_RED}5) $(L tool_close)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╠══════════════════════════════════════════════════════════════════════════════╣${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_BOLD}$(L choose_tool)${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${C_RESET}"; printf "${C_BOLD}${C_YELLOW}>> ${C_RESET}"; read -r choice; case ${choice:-0} in 1) run_script "$ANALYTICS_SCRIPT" ;; 2) run_script "$SCANNER_SCRIPT" ;; 3) show_main_help ;; 4) show_main_about ;; 5) clear; echo -e "\n${C_GREEN}$(L goodbye)${C_RESET}\n"; exit 0 ;; *) printf "\n${C_RED}$(L invalid_option)${C_RESET}\n"; sleep 2 ;; esac; done; }
language_selection() { while true; do clear; print_logo; echo -e "\n${C_BOLD}${C_YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_CYAN}Select a Language${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╠══════════════════════════════════════════════════════════════════════════════╣${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}1) English${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_GREEN}2) Arabic${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET}  ${C_RED}3) Close${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╠══════════════════════════════════════════════════════════════════════════════╣${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_BOLD}Your choice:${C_RESET}"; echo -e "${C_BOLD}${C_YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${C_RESET}"; printf "${C_BOLD}${C_YELLOW}>> ${C_RESET}"; read -r lang_choice; case ${lang_choice:-0} in 1) SELECTED_LANG="en"; main_hub_menu ;; 2) SELECTED_LANG="ar"; main_hub_menu ;; 3) clear; echo -e "\n${C_GREEN}Goodbye!${C_RESET}\n"; exit 0 ;; *) printf "\n${C_RED}Invalid choice. Please enter 1, 2, or 3.${C_RESET}\n"; sleep 2 ;; esac; done; }

load_texts
language_selection
