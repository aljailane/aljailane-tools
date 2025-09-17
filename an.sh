#!/usr/bin/env bash

#============================================================
#          FILE: an.sh (Formerly aljup_refined_analyzer.sh
#
# وصف: أداة تحليل وتنظيف احترافية بتصميم مُحسَّن لخوادم CyberPanel.
#  - واجهة محسنة متعددة اللغات.
#  - تحديد مسار ونطاق حجم البحث.
#  - الاختيار بين النقل لسلة المحذوفات أو الحذف النهائي.
#  - تسجيل جميع الإجراءات في ملف سجل دائم.
#
#  REQUIREMENTS: pv, numfmt (e.g., sudo dnf install -y pv coreutils)
#  AUTHOR: (Mohammed Al-Jailani) - Modified for launcher
#  CREATED: 2025-09-16
#  REVISION: 1.3 (Full Language Sync)
#=============================================================

#-------------------------------------------------------------------------------
# SETUP & CONFIGURATION
#-------------------------------------------------------------------------------

# --- إعدادات الأمان والخروج عند الخطأ ---
set -euo pipefail

# --- تعريف الألوان والرموز ---
C_RESET='\033[0m'; C_BOLD='\033[1m'; C_RED='\033[0;31m'; C_GREEN='\033[0;32m';
C_YELLOW='\033[0;33m'; C_CYAN='\033[0;36m'; C_MAGENTA='\033[0;35m';
ICON_WARN="⚠️"; ICON_OK="✅"; ICON_TRASH="♻️"; ICON_DEL="🗑️"; ICON_SEARCH="🔍"; ICON_CONFIG="⚙️"; ICON_LOG="📋";

# --- ملفات اللغة ---
LANG_FILE=$(mktemp)
trap 'rm -f "$LANG_FILE"' EXIT

# --- [FINAL LANGUAGE FIX] All user-facing strings are now in the language file ---
cat > "$LANG_FILE" << 'EOF'
[ar]
main_menu_header="قائمة أداة التحليل"
start_scan="بدء فحص جديد"
exit_script="العودة إلى المشغل الرئيسي"
scan_settings="إعدادات الفحص"
default_path="مسار الفحص"
prompt_path="اضغط Enter للاحتفاظ بالمسار الحالي أو أدخل مسارًا جديدًا"
path_not_found="المسار غير موجود."
min_size_prompt="الحد الأدنى لحجم البحث (مثال: 500M, 1G)"
max_size_prompt="الحد الأقصى لحجم البحث (مثال: 1G, 10G)"
invalid_size="صيغة الحجم غير صالحة. استخدم M للميجابايت و G للجيجابايت."
select_mode="اختر وضع التشغيل"
mode_safe="النقل إلى سلة المهملات (آمن)"
mode_danger="الحذف النهائي (خطير)"
safe_mode_selected="تم اختيار الوضع الآمن. سيتم نقل الملفات إلى:"
danger_mode_selected="تحذير: لقد اخترت وضع الحذف النهائي. لا يمكن التراجع عن هذا الإجراء!"
confirm_delete_prompt="اكتب 'تأكيد الحذف' للمتابعة في هذا الوضع:"
delete_cancelled="تم الإلغاء. لم يتم اختيار وضع الحذف النهائي."
filter_prompt="هل تريد البحث عن أنواع ملفات معينة؟ (مثال: *.zip *.log)"
filter_prompt_no="لا، ابحث عن كل الأنواع"
dir_analysis="تحليل مساحة المجلدات"
dir_folder="المجلد"
used_space="المساحة المستخدمة"
no_folders_found="لم يتم العثور على أي مجلدات فرعية."
search_results="نتائج البحث"
searching_files="جارٍ البحث عن الملفات... قد يستغرق هذا بعض الوقت."
no_files_found="لم يتم العثور على ملفات تطابق معايير البحث."
action_options="خيارات الإجراء"
action_prompt_1="ملفات محددة (بالـ ID)"
action_prompt_2="جميع الملفات المعروضة"
action_prompt_3="العودة إلى القائمة الرئيسية"
enter_choice="أدخل اختيارك"
enter_ids="أدخل أرقام الـ ID للملفات (مثال: 1 5 12)"
confirm_action_prompt="هل أنت متأكد؟ (اكتب 'نعم' للتأكيد):"
action_cancelled="تم إلغاء الإجراء."
action_completed="اكتمل الإجراء بنجاح."
exit_message="العودة إلى القائمة الرئيسية..."
final_report="تقرير المساحة الإجمالية للقرص (بعد الإجراء)"
log_file_location="تم تسجيل جميع الإجراءات في:"
press_enter_to_return="اضغط على Enter للعودة إلى القائمة..."
invalid_option="خيار غير صالح. الرجاء إدخال رقم صحيح."
will_action="سوف يتم %s %s."
desc_selected_files="الملفات المحددة"
desc_all_files="جميع الملفات المعروضة"
col_id="معرف:"
moved_msg="تم نقل:"
deleted_msg="تم حذف:"
[en]
main_menu_header="Analyzer Tool Menu"
start_scan="Start a New Scan"
exit_script="Return to Main Launcher"
scan_settings="Scan Settings"
default_path="Scan Path"
prompt_path="Press Enter to keep the current path, or enter a new one"
path_not_found="Path not found."
min_size_prompt="Minimum search size (e.g., 500M, 1G)"
max_size_prompt="Maximum search size (e.g., 1G, 10G)"
invalid_size="Invalid size format. Use M for Megabytes and G for Gigabytes."
select_mode="Select Operation Mode"
mode_safe="Move to Trash (Safe)"
mode_danger="Permanent Delete (Dangerous)"
safe_mode_selected="Safe mode selected. Files will be moved to:"
danger_mode_selected="Warning: You have selected Permanent Delete mode. This action cannot be undone!"
confirm_delete_prompt="Type 'confirm delete' to proceed in this mode:"
delete_cancelled="Cancelled. Permanent delete mode was not selected."
filter_prompt="Filter by specific file types? (e.g., *.zip *.log)"
filter_prompt_no="No, search for all types"
dir_analysis="Directory Space Analysis"
dir_folder="Directory"
used_space="Used Space"
no_folders_found="No sub-directories found."
search_results="Search Results"
searching_files="Searching for files... This may take a while."
no_files_found="No files matching the search criteria were found."
action_options="Action Options"
action_prompt_1="Specific files (by ID)"
action_prompt_2="All listed files"
action_prompt_3="Return to Main Menu"
enter_choice="Enter your choice"
enter_ids="Enter the file IDs (e.g., 1 5 12)"
confirm_action_prompt="Are you sure? (Type 'yes' to confirm):"
action_cancelled="Action cancelled."
action_completed="Action completed successfully."
exit_message="Returning to main menu..."
final_report="Final Disk Space Report (Post-Action)"
log_file_location="All actions have been logged to:"
press_enter_to_return="Press Enter to return to the menu..."
invalid_option="Invalid option. Please enter a valid number."
will_action="Will %s %s."
desc_selected_files="selected files"
desc_all_files="all listed files"
col_id="ID:"
moved_msg="Moved:"
deleted_msg="Deleted:"
EOF

#-------------------------------------------------------------------------------
# CORE FUNCTIONS
#-------------------------------------------------------------------------------

print_header() { printf "\n${C_BOLD}${C_CYAN}============================================================${C_RESET}\n${C_BOLD}${C_CYAN} %-58s ${C_RESET}\n${C_BOLD}${C_CYAN}============================================================${C_RESET}\n"; }
die() { printf "\n${C_BOLD}${C_RED}Error: %s${C_RESET}\n" "$1" >&2; exit 1; }
check_dependencies() { for cmd in du find awk pv numfmt; do if ! command -v "$cmd" &> /dev/null; then die "Command '$cmd' not found. Please install it (e.g., sudo dnf install -y $cmd)"; fi; done; }

print_credit_box() {
    local text1="Script developed by: Mohammed Al-Jailani"
    local text2="Yemen - Hodeidah"
    local text3="admin@aljup.com"
    
    printf "\n\n"
    printf "${C_BOLD}${C_MAGENTA}╔══════════════════════════════════════════════════════════════╗${C_RESET}\n"
    printf "${C_BOLD}${C_MAGENTA}║ %-56s ║${C_RESET}\n" ""
    printf "${C_BOLD}${C_MAGENTA}║${C_RESET} ${C_CYAN}%-60s${C_BOLD}${C_MAGENTA}║${C_RESET}\n" "$(printf '%*s' $(( (56 - ${#text1}) / 2 )) '')${text1}"
    printf "${C_BOLD}${C_MAGENTA}║${C_RESET} ${C_YELLOW}%-58s${C_BOLD}${C_MAGENTA}║${C_RESET}\n" "$(printf '%*s' $(( (56 - ${#text2}) / 2 )) '')${text2}"
    printf "${C_BOLD}${C_MAGENTA}║${C_RESET} ${C_YELLOW}%-58s${C_BOLD}${C_MAGENTA}║${C_RESET}\n" "$(printf '%*s' $(( (56 - ${#text3}) / 2 )) '')${text3}"
    printf "${C_BOLD}${C_MAGENTA}║ %-56s ║${C_RESET}\n" ""
    printf "${C_BOLD}${C_MAGENTA}╚══════════════════════════════════════════════════════════════╝${C_RESET}\n\n"
}

#-------------------------------------------------------------------------------
# UI & INTERACTION FUNCTIONS
#-------------------------------------------------------------------------------

set_language() {
    LANG_CODE=${1:-en} 
    L() { grep -Po "(?<=^$1=).*$" <(sed -n "/\[$LANG_CODE\]/,/\[/p" "$LANG_FILE"); }
    CONFIRM_YES=$([ "$LANG_CODE" == "ar" ] && echo "نعم" || echo "yes")
    CONFIRM_DELETE_TEXT=$([ "$LANG_CODE" == "ar" ] && echo "تأكيد الحذف" || echo "confirm delete")
}

interactive_menu() {
    local -n files_by_id_ref=$1
    local ACTION_VERB=$2
    local MODE=$3
    local TRASH_DIR=$4
    local LOG_FILE=$5

    while true; do
        print_header "$(L action_options): ($ACTION_VERB)"
        read -p "$(echo -e "\n  1 - ${ACTION_VERB} $(L action_prompt_1)\n  2 - ${ACTION_VERB} $(L action_prompt_2)\n  3 - $(L action_prompt_3)\n${C_BOLD}$(L enter_choice) [1-3]: ${C_RESET}")" choice

        case ${choice:-0} in
            1|2)
                local ids_to_process action_desc
                if [ "$choice" -eq 1 ]; then
                    read -p "$(L enter_ids): " ids_to_process
                    if [ -z "$ids_to_process" ]; then continue; fi
                    action_desc="$(L desc_selected_files)"
                else
                    ids_to_process=$(printf "%s " "${!files_by_id_ref[@]}")
                    action_desc="$(L desc_all_files)"
                fi

                printf "\n${C_YELLOW}${C_BOLD}"
                printf "$(L will_action)" "$ACTION_VERB" "$action_desc"
                printf "${C_RESET}\n"
                
                read -p "$(L confirm_action_prompt): " confirm
                if [[ "${confirm,,}" == "${CONFIRM_YES,,}" ]]; then
                    for id in $ids_to_process; do
                        if [ -n "${files_by_id_ref[$id]+_}" ]; then
                            local file_to_process="${files_by_id_ref[$id]}"
                            if [ "$MODE" -eq 1 ]; then
                                mv --parents "$file_to_process" "$TRASH_DIR" && printf "${C_GREEN}${ICON_TRASH} $(L moved_msg) %s${C_RESET}\n" "$file_to_process"
                                echo "$(date): MOVED: $file_to_process -> $TRASH_DIR" >> "$LOG_FILE"
                            else
                                rm -f "$file_to_process" && printf "${C_GREEN}${ICON_DEL} $(L deleted_msg) %s${C_RESET}\n" "$file_to_process"
                                echo "$(date): DELETED: $file_to_process" >> "$LOG_FILE"
                            fi
                        fi
                    done
                    printf "\n${C_GREEN}${ICON_OK} $(L action_completed)${C_RESET}\n"
                else
                    printf "\n${C_YELLOW}$(L action_cancelled)${C_RESET}\n"
                fi
                read -p "$(L press_enter_to_return)"
                ;;
            3)
                printf "\n${C_GREEN}$(L exit_message)${C_RESET}\n"; sleep 1
                return
                ;;
            *)
                printf "\n${C_RED}$(L invalid_option)${C_RESET}\n"; sleep 2
                ;;
        esac
    done
}

#-------------------------------------------------------------------------------
# MAIN SCAN WORKFLOW
#-------------------------------------------------------------------------------

run_scan() {
    print_header "${ICON_CONFIG} $(L scan_settings)"

    local SCAN_PATH="/home"
    printf "${C_CYAN}$(L default_path): ${C_YELLOW}${SCAN_PATH}${C_RESET}\n"
    read -p "$(L prompt_path): " new_path
    SCAN_PATH=${new_path:-$SCAN_PATH}
    if [ ! -d "$SCAN_PATH" ]; then echo -e "\n${C_RED}$(L path_not_found)${C_RESET}"; sleep 2; return; fi

    local MIN_SIZE="500M" MAX_SIZE="1G"
    printf "\n${C_CYAN}$(L min_size_prompt) [${MIN_SIZE}]: ${C_RESET}"; read -r new_min_size
    MIN_SIZE=${new_min_size:-$MIN_SIZE}
    printf "${C_CYAN}$(L max_size_prompt) [${MAX_SIZE}]: ${C_RESET}"; read -r new_max_size
    MAX_SIZE=${new_max_size:-$MAX_SIZE}
    if ! [[ "$MIN_SIZE" =~ ^[0-9]+[MG]$ ]] || ! [[ "$MAX_SIZE" =~ ^[0-9]+[MG]$ ]]; then echo -e "\n${C_RED}$(L invalid_size)${C_RESET}"; sleep 2; return; fi

    print_header "$(L select_mode)"
    read -p "$(echo -e "\n  1 - $(L mode_safe)\n\n  2 - $(L mode_danger)\n\n$(L enter_choice) [1]: ")" mode
    local MODE=${mode:-1}
    
    local REPORTS_DIR="/home/reports"
    mkdir -p "$REPORTS_DIR"
    local LOG_FILE="$REPORTS_DIR/aljup_analyzer_log_$(date +%F).txt"
    local ACTION_VERB ACTION_ICON TRASH_DIR

    if [ "$MODE" -eq 1 ]; then
        ACTION_VERB=$([ "$LANG_CODE" == "ar" ] && echo "نقل" || echo "Move")
        ACTION_ICON=$ICON_TRASH
        TRASH_DIR="/home/trash_bin_$(date +%Y-%m-%d_%H-%M-%S)"
        mkdir -p "$TRASH_DIR"
        printf "\n${C_GREEN}$(L safe_mode_selected) ${C_YELLOW}${TRASH_DIR}${C_RESET}\n"
    else
        ACTION_VERB=$([ "$LANG_CODE" == "ar" ] && echo "حذف" || echo "Delete")
        ACTION_ICON=$ICON_DEL
        TRASH_DIR="" 
        printf "\n${C_RED}${ICON_WARN} $(L danger_mode_selected)${C_RESET}\n"
        read -p "$(L confirm_delete_prompt): " confirm_delete
        if [[ "$confirm_delete" != "$CONFIRM_DELETE_TEXT" ]]; then echo -e "\n${C_YELLOW}$(L delete_cancelled)${C_RESET}"; sleep 2; return; fi
    fi
    echo "--- Log started at $(date) for scan on path '$SCAN_PATH' ---" >> "$LOG_FILE"

    local file_pattern
    printf "\n${C_CYAN}$(L filter_prompt) [$(L filter_prompt_no)]:${C_RESET} "; read -r file_pattern

    print_header "$(L dir_analysis)"
    mapfile -d $'\0' site_dirs < <(find "$SCAN_PATH" -maxdepth 1 -mindepth 1 -type d -not -name "lost+found" -not -name "cyberpanel" -not -path "${TRASH_DIR:-/dev/null}*" -print0)
    if [ ${#site_dirs[@]} -eq 0 ]; then
        printf "${C_YELLOW}$(L no_folders_found)${C_RESET}\n"
    else
        printf "%-40s | %-15s\n" "$(L dir_folder)" "$(L used_space)"; printf -- "-%.0s" {1..60}; printf "\n"
        for dir in "${site_dirs[@]}"; do
            local size dir_name
            size=$(du -sh "$dir" 2>/dev/null | awk '{print $1}')
            dir_name=$(basename "$dir")
            printf "%-40s | ${C_GREEN}%-15s${C_RESET}\n" "$dir_name" "$size"
        done
    fi

    local find_cmd="find \"$SCAN_PATH\" -type f -size +${MIN_SIZE} -size -${MAX_SIZE}"
    if [ -n "$file_pattern" ]; then
        local pattern_args=(); for p in $file_pattern; do pattern_args+=(-o -name "$p"); done
        find_cmd+=" \( ${pattern_args[@]:1} \)"
    fi
    if [ -n "$TRASH_DIR" ]; then find_cmd+=" -not -path \"${TRASH_DIR}/*\""; fi

    print_header "${ICON_SEARCH} $(L search_results)"
    local large_files_list=$(mktemp)
    
    printf "$(L searching_files)\n"
    eval "$find_cmd -printf '%s %p\n' 2>/dev/null" | sort -rn > "$large_files_list"

    if [ ! -s "$large_files_list" ]; then
        printf "\n${C_GREEN}${ICON_OK} $(L no_files_found)${C_RESET}\n"
        if [ "$MODE" -eq 1 ]; then rmdir "$TRASH_DIR"; fi
        read -p "$(L press_enter_to_return)"
        return
    fi

    declare -A files_by_id
    local file_id=1
    while read -r line; do
        local size_bytes file_path human_size
        size_bytes=$(echo "$line" | awk '{print $1}')
        file_path=$(echo "$line" | cut -d' ' -f2-)
        files_by_id["$file_id"]="$file_path"
        human_size=$(numfmt --to=iec-i --suffix=B --format="%.2f" "$size_bytes")
        printf "[%s] ${C_MAGENTA}%-5s${C_RESET} ${C_RED}%-12s${C_RESET} %s\n" "$(printf "%02d" $file_id)" "$(L col_id)" "$human_size" "$file_path"
        file_id=$((file_id + 1))
    done < "$large_files_list"
    rm -f "$large_files_list"

    interactive_menu files_by_id "$ACTION_VERB" "$MODE" "$TRASH_DIR" "$LOG_FILE"
    
    if [ "$MODE" -eq 1 ] && [ -d "$TRASH_DIR" ] && [ -z "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
        rmdir "$TRASH_DIR"
    fi
}

#-------------------------------------------------------------------------------
# MAIN PROGRAM LOGIC
#-------------------------------------------------------------------------------

check_dependencies
if [ "$EUID" -ne 0 ]; then
  printf "\n${C_YELLOW}${ICON_WARN} Warning: This script must be run with root privileges (sudo).${C_RESET}\n"; sleep 3;
fi

set_language "$1"

while true; do
    clear
    print_header "$(L main_menu_header)"
    read -p "$(echo -e "\n  1 - $(L start_scan)\n\n  2 - $(L exit_script)\n\n${C_BOLD}$(L enter_choice) [1-2]: ${C_RESET}")" main_choice

    case ${main_choice:-0} in
        1)
            run_scan
            read -p "$(L press_enter_to_return)"
            ;;
        2)
            break 
            ;;
        *)
            printf "\n${C_RED}$(L invalid_option)${C_RESET}\n"; sleep 2
            ;;
    esac
done

clear
print_credit_box
printf "${C_GREEN}$(L exit_message)${C_RESET}\n"; sleep 1
exit 0

