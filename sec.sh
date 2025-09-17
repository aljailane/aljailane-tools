#!/bin/bash

#================================================================================
# أداة فحص الأمان (sec.sh)
# الإصدار: 5.4 (متكامل مع المشغل)
# المؤلف: تم إنشاؤه بواسطة aljailane
# الوصف: أداة متكاملة للفحص، الحذف الآمن، عرض السجلات، وجدولة الفحص التلقائي.
#================================================================================

# --- ألوان للواجهة ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- متغيرات عامة ---
LOG_DIR="/home/clamav_logs"
QUARANTINE_DIR="/home/clamav_quarantine"
SCRIPT_PATH="$(realpath "$0")"
CRON_COMMENT="Aljailane Security Scanner"

# --- ملفات اللغة ---
lang_ar() {
    TXT_LANG_NAME="العربية"
    TXT_WELCOME="مرحبا بك في أداة فحص الأمان الخاصة بـ aljailane"
    TXT_DESCRIPTION="الأداة تعتمد على clamav وتقوم بالفحص الدقيق للفيروسات"
    TXT_CHOOSE_ACTION="اختر الإجراء المطلوب"
    TXT_SCAN_HOME="فحص مجلد /home بالكامل"
    TXT_FIND_PATH="تحديد مسار موقع"
    TXT_SCAN_SITE="فحص موقع محدد"
    TXT_CHECK_CLAMAV="التحقق من تثبيت clamav"
    TXT_UPDATE_DB="تحديث قاعدة بيانات clamav"
    TXT_VIEW_PREV_RESULTS="عرض النتائج السابقة"
    TXT_CLAMAV_VERSION="إصدار ClamAV"
    TXT_SCHEDULE_SCAN="جدولة الفحص التلقائي"
    TXT_HELP="مساعدة"
    TXT_ABOUT="حول الأداة"
    # --- [MODIFICATION] Changed TXT_CLOSE to TXT_RETURN_TO_LAUNCHER
    TXT_RETURN_TO_LAUNCHER="العودة إلى المشغل الرئيسي"
    TXT_INVALID_OPTION="خيار غير صالح. يرجى المحاولة مرة أخرى."
    TXT_PRESS_ENTER="اضغط على Enter للعودة..."
    TXT_CLAMAV_NOT_INSTALLED="خطأ: ClamAV غير مثبت."
    TXT_PLEASE_INSTALL="يرجى تثبيته أولاً."
    TXT_UPDATING_DB="[*] جاري تحديث قاعدة بيانات ClamAV..."
    TXT_UPDATE_SUCCESS="[✔] تم تحديث قاعدة البيانات بنجاح."
    TXT_SCANNING_DIR="[*] بدأ فحص المجلد:"
    TXT_SCAN_COMPLETE="[✔] انتهى الفحص للمجلد:"
    TXT_DIR_NOT_FOUND="خطأ: المجلد غير موجود."
    TXT_VERSION="الإصدار"
    TXT_CREATED_BY="تم إنشاؤها بواسطة Manus لـ aljailane"
    TXT_CLAMAV_OK="[✔] ClamAV مثبت على النظام."
    # --- [MODIFICATION] Changed TXT_GOODBYE message
    TXT_GOODBYE="العودة إلى القائمة الرئيسية..."
    TXT_CALCULATING_FILES="[*] جاري حساب عدد الملفات للفحص..."
    TXT_LOG_SAVED="[✔] تم حفظ التقرير تلقائيًا في:"
    TXT_SCAN_PROGRESS="تقدم الفحص"
    TXT_PREVIOUS_REPORTS="--- تقارير الفحص السابقة ---"
    TXT_NO_REPORTS_FOUND="لم يتم العثور على تقارير سابقة."
    TXT_CHOOSE_REPORT_TO_EXPORT="اختر رقم التقرير لتصديره (أو 'c' لعرضه، 0 للعودة):"
    TXT_REPORT_EXPORTED="[✔] تم تصدير التقرير إلى:"
    TXT_CLAMAV_VERSION_INFO="--- معلومات إصدار ClamAV ---"
    TXT_DB_VERSION="إصدار قاعدة البيانات:"
    TXT_INFECTED_FILES_FOUND="[!] تم العثور على ملفات مصابة!"
    TXT_DELETE_PROMPT="هل ترغب في حذف الملفات المصابة؟ (سيتم أخذ نسخة احتياطية آمنة أولاً) (نعم/لا):"
    TXT_DELETE_CONFIRM="تحذير! أنت على وشك حذف الملفات التالية. هل أنت متأكد؟ (نعم/لا):"
    TXT_QUARANTINING="[*] جاري نقل الملفات المصابة إلى الحجر الصحي الآمن..."
    TXT_QUARANTINE_LOCATION="تم حفظ النسخ الاحتياطية في:"
    TXT_DELETING_FILES="[*] جاري حذف الملفات المصابة..."
    TXT_DELETE_COMPLETE="[✔] تم حذف جميع الملفات المصابة بنجاح."
    TXT_DELETE_ABORTED="تم إلغاء عملية الحذف."
    TXT_CRON_MENU_TITLE="--- إدارة الفحص المجدول ---"
    TXT_CRON_SETUP="إعداد/تحديث فحص مجدول"
    TXT_CRON_VIEW="عرض حالة الجدولة الحالية"
    TXT_CRON_REMOVE="إزالة الفحص المجدول"
    TXT_CRON_CHOOSE_FREQ="اختر تكرار الفحص:"
    TXT_CRON_DAILY="1) يوميًا (في 03:00 صباحًا)"
    TXT_CRON_WEEKLY="2) أسبوعيًا (كل يوم أحد في 03:00 صباحًا)"
    TXT_CRON_MONTHLY="3) شهريًا (في أول يوم من الشهر في 03:00 صباحًا)"
    TXT_CRON_CREATED="[✔] تم إعداد الفحص المجدول بنجاح."
    TXT_CRON_REMOVED="[✔] تم إزالة الفحص المجدول بنجاح."
    TXT_CRON_NOT_FOUND="لا يوجد فحص مجدول حاليًا."
    TXT_CRON_CURRENT_STATUS="--- حالة الجدولة الحالية ---"
    TXT_CRON_CHOOSE_TARGET="اختر هدف الفحص المجدول:"
    TXT_CRON_TARGET_HOME="1) فحص مجلد /home بالكامل"
    TXT_CRON_TARGET_SITE="2) فحص موقع محدد"
    TXT_CRON_TARGET_CUSTOM="3) فحص مسار مخصص"
    TXT_ENTER_CUSTOM_PATH="أدخل المسار المخصص الذي تريد فحصه:"
    TXT_ENTER_DOMAIN="أدخل اسم النطاق للموقع الذي تبحث عنه (e.g., example.com):"
    TXT_SITE_FOUND="[✔] تم العثور على الموقع."
    TXT_PATH_IS="المسار هو:"
    TXT_SITE_NOT_FOUND="[✘] لم يتم العثور على موقع بهذا الاسم في المسار المتوقع."
    TXT_SEARCHED_PATH="المسار الذي تم البحث فيه:"
}

lang_en() {
    TXT_LANG_NAME="English"
    TXT_WELCOME="Welcome to aljailane's Security Scan Tool"
    TXT_DESCRIPTION="This tool uses clamav for in-depth virus scanning"
    TXT_CHOOSE_ACTION="Choose the desired action"
    TXT_SCAN_HOME="Scan /home directory completely"
    TXT_FIND_PATH="Find a website's path"
    TXT_SCAN_SITE="Scan a specific website"
    TXT_CHECK_CLAMAV="Check clamav installation"
    TXT_UPDATE_DB="Update clamav database"
    TXT_VIEW_PREV_RESULTS="View Previous Results"
    TXT_CLAMAV_VERSION="ClamAV Version"
    TXT_SCHEDULE_SCAN="Schedule Automatic Scan"
    TXT_HELP="Help"
    TXT_ABOUT="About"
    # --- [MODIFICATION] Changed TXT_CLOSE to TXT_RETURN_TO_LAUNCHER
    TXT_RETURN_TO_LAUNCHER="Return to Main Launcher"
    TXT_INVALID_OPTION="Invalid option. Please try again."
    TXT_PRESS_ENTER="Press Enter to return..."
    TXT_CLAMAV_NOT_INSTALLED="Error: ClamAV is not installed."
    TXT_PLEASE_INSTALL="Please install it first."
    TXT_UPDATING_DB="[*] Updating ClamAV virus database..."
    TXT_UPDATE_SUCCESS="[✔] Database updated successfully."
    TXT_SCANNING_DIR="[*] Starting scan for directory:"
    TXT_SCAN_COMPLETE="[✔] Scan finished for directory:"
    TXT_DIR_NOT_FOUND="Error: Directory not found."
    TXT_VERSION="Version"
    TXT_CREATED_BY="Created by Manus for aljailane"
    TXT_CLAMAV_OK="[✔] ClamAV is installed on the system."
    # --- [MODIFICATION] Changed TXT_GOODBYE message
    TXT_GOODBYE="Returning to main launcher..."
    TXT_CALCULATING_FILES="[*] Calculating the number of files to scan..."
    TXT_LOG_SAVED="[✔] Report automatically saved to:"
    TXT_SCAN_PROGRESS="Scan Progress"
    TXT_PREVIOUS_REPORTS="--- Previous Scan Reports ---"
    TXT_NO_REPORTS_FOUND="No previous reports found."
    TXT_CHOOSE_REPORT_TO_EXPORT="Enter report number to export (or 'c' to view, 0 to return):"
    TXT_REPORT_EXPORTED="[✔] Report exported to:"
    TXT_CLAMAV_VERSION_INFO="--- ClamAV Version Information ---"
    TXT_DB_VERSION="Database version:"
    TXT_INFECTED_FILES_FOUND="[!] Infected files found!"
    TXT_DELETE_PROMPT="Do you want to delete the infected files? (A secure backup will be made first) (yes/no):"
    TXT_DELETE_CONFIRM="WARNING! You are about to delete the following files. Are you sure? (yes/no):"
    TXT_QUARANTINING="[*] Moving infected files to secure quarantine..."
    TXT_QUARANTINE_LOCATION="Backups saved in:"
    TXT_DELETING_FILES="[*] Deleting infected files..."
    TXT_DELETE_COMPLETE="[✔] All infected files have been deleted successfully."
    TXT_DELETE_ABORTED="Delete operation aborted."
    TXT_CRON_MENU_TITLE="--- Scheduled Scan Management ---"
    TXT_CRON_SETUP="Setup/Update a Scheduled Scan"
    TXT_CRON_VIEW="View Current Schedule Status"
    TXT_CRON_REMOVE="Remove Scheduled Scan"
    TXT_CRON_CHOOSE_FREQ="Choose scan frequency:"
    TXT_CRON_DAILY="1) Daily (at 03:00 AM)"
    TXT_CRON_WEEKLY="2) Weekly (every Sunday at 03:00 AM)"
    TXT_CRON_MONTHLY="3) Monthly (on the 1st of the month at 03:00 AM)"
    TXT_CRON_CREATED="[✔] Scheduled scan has been set up successfully."
    TXT_CRON_REMOVED="[✔] Scheduled scan has been removed successfully."
    TXT_CRON_NOT_FOUND="No scheduled scan is currently set."
    TXT_CRON_CURRENT_STATUS="--- Current Schedule Status ---"
    TXT_CRON_CHOOSE_TARGET="Choose the target for the scheduled scan:"
    TXT_CRON_TARGET_HOME="1) Scan the entire /home directory"
    TXT_CRON_TARGET_SITE="2) Scan a specific website"
    TXT_CRON_TARGET_CUSTOM="3) Scan a custom path"
    TXT_ENTER_CUSTOM_PATH="Enter the custom path you want to scan:"
    TXT_ENTER_DOMAIN="Enter the domain name of the site you are looking for (e.g., example.com):"
    TXT_SITE_FOUND="[✔] Website found."
    TXT_PATH_IS="The path is:"
    TXT_SITE_NOT_FOUND="[✘] No site with this name was found in the expected path."
    TXT_SEARCHED_PATH="The path searched was:"
}

# --- دوال الأداة ---

delete_infected_files() {
    local log_file=$1
    local infected_files=($(grep 'FOUND$' "$log_file" | sed -e 's/:.*//'))
    if [ ${#infected_files[@]} -eq 0 ]; then return; fi
    echo -e "\n${RED}${TXT_INFECTED_FILES_FOUND}${NC}"
    read -p "${YELLOW}${TXT_DELETE_PROMPT}${NC} " delete_choice
    if [[ ! "$delete_choice" =~ ^(yes|y|نعم|ن)$ ]]; then echo -e "${YELLOW}${TXT_DELETE_ABORTED}${NC}"; return; fi
    clear; echo -e "${YELLOW}The following files will be backed up and deleted:${NC}"; printf '%s\n' "${infected_files[@]}"
    read -p "${RED}${TXT_DELETE_CONFIRM}${NC} " confirm_choice
    if [[ ! "$confirm_choice" =~ ^(yes|y|نعم|ن)$ ]]; then echo -e "${YELLOW}${TXT_DELETE_ABORTED}${NC}"; return; fi
    echo -e "${BLUE}${TXT_QUARANTINING}${NC}"
    sudo mkdir -p "$QUARANTINE_DIR"
    for file in "${infected_files[@]}"; do
        if [ -f "$file" ]; then
            local dest_path="$QUARANTINE_DIR$(dirname "$file")"
            sudo mkdir -p "$dest_path"
            sudo cp "$file" "${dest_path}/$(basename "$file").infected"
        fi
    done
    echo -e "${GREEN}${TXT_QUARANTINE_LOCATION} ${YELLOW}$QUARANTINE_DIR${NC}"
    echo -e "${BLUE}${TXT_DELETING_FILES}${NC}"
    for file in "${infected_files[@]}"; do sudo rm -f "$file"; done
    echo -e "${GREEN}${TXT_DELETE_COMPLETE}${NC}"
}

scan_directory() {
    local target_dir=$1; local is_cron=${2:-false}
    if [ ! -d "$target_dir" ]; then echo -e "${RED}${TXT_DIR_NOT_FOUND} '$target_dir'${NC}"; return; fi
    local scan_output_file=$(mktemp)
    if [ "$is_cron" = false ]; then
        echo -e "${YELLOW}${TXT_CALCULATING_FILES}${NC}"
        local total_files=$(sudo find "$target_dir" -type f 2>/dev/null | wc -l)
        if [ "$total_files" -eq 0 ]; then echo -e "${YELLOW}No files to scan.${NC}"; rm "$scan_output_file"; sleep 2; return; fi
        echo -e "${BLUE}=====================================================${NC}"
        echo -e "${YELLOW}${TXT_SCANNING_DIR} $target_dir (${total_files} files)${NC}"
        echo -e "${BLUE}=====================================================${NC}"
        sudo clamscan --infected --remove=no -r "$target_dir" 2>&1 | tee "$scan_output_file" | \
        ( while IFS= read -r line; do if [[ "$line" == *"Scanned files:"* ]]; then scanned_files=$(echo "$line" | grep -oP 'Scanned files: \K[0-9]+'); if [[ -n "$scanned_files" && "$total_files" -gt 0 ]]; then percentage=$((scanned_files * 100 / total_files)); progress=$((percentage / 2)); printf -v p_bar '%*s' "$progress" ''; p_bar=${p_bar// /#}; printf "\r${BLUE}[%-50s] %d%%${NC}" "$p_bar" "$percentage"; fi; fi; done )
        printf "\r${BLUE}[%-50s] 100%%${NC}\n" "##################################################"
    else
        sudo clamscan --infected --remove=no -r "$target_dir" > "$scan_output_file" 2>&1
    fi
    local log_file="$LOG_DIR/scan_report_$(date +'%Y-%m-%d_%H-%M-%S').log"
    { echo "Scan Report for: $target_dir"; echo "Date: $(date)"; echo "----------------------------------------"; cat "$scan_output_file"; } | sudo tee "$log_file" > /dev/null
    if [ "$is_cron" = false ]; then
        echo -e "${GREEN}${TXT_SCAN_COMPLETE} $target_dir ${NC}"
        echo -e "${BLUE}--- Scan Summary ---${NC}"; sudo grep -E '^(Infected files:|Scanned files:|Scanned directories:|Total errors:|Time:)' "$log_file"; echo -e "${BLUE}--------------------${NC}"
        echo -e "${GREEN}${TXT_LOG_SAVED} ${YELLOW}$log_file${NC}"
        if sudo grep -q "Infected files: [1-9]" "$log_file"; then delete_infected_files "$log_file"; fi
        echo -e "\n${TXT_PRESS_ENTER}"; read -r
    fi
    rm "$scan_output_file"
}

setup_cron_job() {
    while true; do
        clear; echo -e "${BLUE}${TXT_CRON_MENU_TITLE}${NC}"; echo -e "1) ${TXT_CRON_SETUP}\n2) ${TXT_CRON_VIEW}\n3) ${TXT_CRON_REMOVE}\n0) $(TXT_RETURN_TO_LAUNCHER)"; echo "----------------------------"; read -p "${TXT_CHOOSE_ACTION}: " choice
        case $choice in
            1)
                clear; echo -e "${YELLOW}${TXT_CRON_CHOOSE_TARGET}${NC}"; echo -e "${TXT_CRON_TARGET_HOME}\n${TXT_CRON_TARGET_SITE}\n${TXT_CRON_TARGET_CUSTOM}"; read -p "Choice [1-3]: " target_choice
                local target_path=""
                case $target_choice in
                    1) target_path="/home";;
                    2)
                        local sites=($(ls -d /home/*/ 2>/dev/null | grep -v 'backup' | grep -v 'cyberpanel')); if [ ${#sites[@]} -eq 0 ]; then echo -e "${RED}No sites found${NC}"; sleep 2; continue; fi
                        local i=1; for site in "${sites[@]}"; do echo -e "${GREEN}$i)${NC} $(basename "$site")"; i=$((i+1)); done; read -p "Choose site: " site_choice
                        if [[ "$site_choice" =~ ^[0-9]+$ ]] && [ "$site_choice" -ge 1 ] && [ "$site_choice" -le "${#sites[@]}" ]; then target_path="${sites[$((site_choice-1))]}public_html"; else echo -e "${RED}${TXT_INVALID_OPTION}${NC}"; sleep 2; continue; fi
                        ;;
                    3) read -p "${TXT_ENTER_CUSTOM_PATH} " custom_path; if [ -d "$custom_path" ]; then target_path="$custom_path"; else echo -e "${RED}${TXT_DIR_NOT_FOUND}${NC}"; sleep 2; continue; fi;;
                    *) echo -e "${RED}${TXT_INVALID_OPTION}${NC}"; sleep 2; continue;;
                esac
                clear; echo -e "${YELLOW}${TXT_CRON_CHOOSE_FREQ}${NC}"; echo -e "${TXT_CRON_DAILY}\n${TXT_CRON_WEEKLY}\n${TXT_CRON_MONTHLY}"; read -p "Choice [1-3]: " freq_choice
                local cron_schedule=""; case $freq_choice in 1) cron_schedule="0 3 * * *";; 2) cron_schedule="0 3 * * 0";; 3) cron_schedule="0 3 1 * *";; *) echo -e "${RED}${TXT_INVALID_OPTION}${NC}"; sleep 2; continue;; esac
                local cron_job_cmd="\"$SCRIPT_PATH\" --cron-scan \"$target_path\""
                (sudo crontab -u root -l 2>/dev/null | grep -v "$CRON_COMMENT"; echo "$cron_schedule $cron_job_cmd # $CRON_COMMENT") | sudo crontab -u root -
                echo -e "${GREEN}${TXT_CRON_CREATED}${NC}"; sleep 2
                ;;
            2) clear; echo -e "${BLUE}${TXT_CRON_CURRENT_STATUS}${NC}"; sudo crontab -u root -l | grep "$CRON_COMMENT" || echo -e "${RED}${TXT_CRON_NOT_FOUND}${NC}"; echo -e "\n${TXT_PRESS_ENTER}"; read -r;;
            3) sudo crontab -u root -l | grep -v "$CRON_COMMENT" | sudo crontab -u root -; echo -e "${GREEN}${TXT_CRON_REMOVED}${NC}"; sleep 2;;
            0) return;;
            *) echo -e "${RED}${TXT_INVALID_OPTION}${NC}"; sleep 2;;
        esac
    done
}

view_previous_results() {
    while true; do
        clear; echo -e "${BLUE}${TXT_PREVIOUS_REPORTS}${NC}"
        if [ ! -d "$LOG_DIR" ] || [ -z "$(sudo ls -A $LOG_DIR)" ]; then echo -e "${RED}${TXT_NO_REPORTS_FOUND}${NC}"; echo -e "\n${TXT_PRESS_ENTER}"; read -r; return; fi
        local reports=($(sudo ls -1t "$LOG_DIR" | head -n 50)); local report_paths=(); local i=1
        for report in "${reports[@]}"; do echo -e "${GREEN}$i)${NC} $report"; report_paths+=("$LOG_DIR/$report"); i=$((i+1)); done
        echo "---------------------------------------"; read -p "${TXT_CHOOSE_REPORT_TO_EXPORT} " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#report_paths[@]}" ]; then
            local selected_report=${report_paths[$((choice-1))]}; local export_filename=$(basename "$selected_report")
            sudo cp "$selected_report" "./$export_filename" && sudo chown "$(logname):$(logname)" "./$export_filename"
            echo -e "${GREEN}${TXT_REPORT_EXPORTED} ${YELLOW}$(pwd)/$export_filename${NC}"
        elif [[ "$choice" == "c" || "$choice" == "C" ]]; then
            read -p "Enter report number to view: " view_choice
            if [[ "$view_choice" =~ ^[0-9]+$ ]] && [ "$view_choice" -ge 1 ] && [ "$view_choice" -le "${#report_paths[@]}" ]; then clear; sudo less "${report_paths[$((view_choice-1))]}"; fi
        elif [ "$choice" == "0" ]; then return
        else echo -e "${RED}${TXT_INVALID_OPTION}${NC}"; sleep 2
        fi
        if [[ "$choice" != "c" && "$choice" != "C" ]]; then echo -e "\n${TXT_PRESS_ENTER}"; read -r; fi
    done
}

find_website_path() {
    read -p "${TXT_ENTER_DOMAIN} " domain_name
    local site_path="/home/${domain_name}/public_html"
    if [ -d "$site_path" ]; then
        echo -e "${GREEN}${TXT_SITE_FOUND}${NC}"
        echo -e "${TXT_PATH_IS} ${YELLOW}${site_path}${NC}"
    else
        echo -e "${RED}${TXT_SITE_NOT_FOUND}${NC}"
        echo -e "${TXT_SEARCHED_PATH} ${YELLOW}${site_path}${NC}"
    fi
    echo -e "\n${TXT_PRESS_ENTER}"; read -r
}

show_clamav_version() { clear; echo -e "${BLUE}${TXT_CLAMAV_VERSION_INFO}${NC}"; local version_info=$(clamscan --version); echo -e "${GREEN}${TXT_VERSION}:${NC} ${version_info}"; local db_version=$(freshclam --version | head -n 1); echo -e "${GREEN}${TXT_DB_VERSION}:${NC} ${db_version}"; echo -e "${BLUE}=====================================================${NC}\n\n${TXT_PRESS_ENTER}"; read -r; }
check_clamav_installed() { if ! command -v clamscan &> /dev/null; then echo -e "${RED}${TXT_CLAMAV_NOT_INSTALLED}${NC}\n${YELLOW}${TXT_PLEASE_INSTALL}${NC}"; exit 1; fi; }
update_clamav_db() { echo -e "${BLUE}=====================================================${NC}\n${YELLOW}${TXT_UPDATING_DB}${NC}\n${BLUE}=====================================================${NC}"; sudo freshclam; echo -e "${GREEN}${TXT_UPDATE_SUCCESS}${NC}\n\n${TXT_PRESS_ENTER}"; read -r; }
scan_specific_website() { local sites=($(ls -d /home/*/ 2>/dev/null | grep -v 'backup' | grep -v 'cyberpanel')); if [ ${#sites[@]} -eq 0 ]; then echo -e "${RED}No sites found${NC}"; sleep 2; return; fi; echo -e "${BLUE}Available sites:${NC}"; local i=1; for site in "${sites[@]}"; do echo -e "${GREEN}$i)${NC} $(basename "$site")"; i=$((i+1)); done; read -p "Choose site [1-${#sites[@]}]: " choice; if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#sites[@]}" ]; then scan_directory "${sites[$((choice-1))]}public_html"; fi; }
show_help() { clear; echo "Help content here..."; echo -e "\n${TXT_PRESS_ENTER}"; read -r; }
show_about() { clear; echo -e "${BLUE}About Tool...${NC}\nVersion: 5.4\nCreated by Manus for aljailane\n\n${TXT_PRESS_ENTER}"; read -r; }

# --- القائمة الرئيسية ---
main_menu() {
    check_clamav_installed
    sudo mkdir -p "$LOG_DIR" "$QUARANTINE_DIR"
    while true; do
        clear; echo -e "${BLUE}=====================================================${NC}"; echo -e "      ${YELLOW}${TXT_WELCOME} (v5.4)${NC}"; echo -e "${BLUE}=====================================================${NC}"
        echo -e "  ${GREEN}1)${NC} ${TXT_SCAN_HOME}"
        echo -e "  ${GREEN}2)${NC} ${TXT_SCAN_SITE}"
        echo -e "  ${GREEN}3)${NC} ${TXT_FIND_PATH}"
        echo -e "  ${GREEN}4)${NC} ${TXT_UPDATE_DB}"
        echo -e "  ${YELLOW}------------------- [ ${TXT_LANG_NAME} ] -------------------${NC}"
        echo -e "  ${GREEN}5)${NC} ${TXT_VIEW_PREV_RESULTS}"
        echo -e "  ${GREEN}6)${NC} ${TXT_SCHEDULE_SCAN}"
        echo -e "  ${GREEN}7)${NC} ${TXT_CLAMAV_VERSION}"
        echo -e "  ${GREEN}8)${NC} ${TXT_HELP}"
        echo -e "  ${GREEN}9)${NC} ${TXT_ABOUT}"
        # --- [MODIFICATION] Changed option text to use the new variable
        echo -e "  ${RED}10)${NC} ${TXT_RETURN_TO_LAUNCHER}"
        echo -e "${BLUE}-----------------------------------------------------${NC}"; read -p "${TXT_CHOOSE_ACTION} [1-10]: " choice
        case $choice in 
            1) scan_directory "/home";; 
            2) scan_specific_website;; 
            3) find_website_path;; 
            4) update_clamav_db;; 
            5) view_previous_results;; 
            6) setup_cron_job;; 
            7) show_clamav_version;; 
            8) show_help;; 
            9) show_about;; 
            # --- [MODIFICATION] Changed action from 'exit 0' to 'break'
            10) echo -e "${YELLOW}${TXT_GOODBYE}${NC}"; sleep 1; break;; 
            *) echo -e "${RED}${TXT_INVALID_OPTION}${NC}"; sleep 2;; 
        esac
    done
}

# --- نقطة بداية السكربت ---

# --- [MODIFICATION] Removed the language_selection function and added this block ---
# Handle cron job execution
if [ "$1" = "--cron-scan" ] && [ -n "$2" ]; then 
    lang_en 
    scan_directory "$2" true
    exit 0
fi

# Set language based on the argument passed from launcher.sh
if [ "$1" == "ar" ]; then
    lang_ar
else
    # Default to English if no argument or an unknown argument is passed
    lang_en
fi

# Run the main menu
main_menu

# Exit gracefully, returning control to the launcher script
exit 0

