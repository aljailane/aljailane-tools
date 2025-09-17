# Aljailane Tool Suite

![Aljailane Tools Logo](https://raw.githubusercontent.com/user-attachments/assets/e080645c-2048-4361-970d-770732817887)

**A professional suite of command-line tools for server management, security scanning, and advanced analysis.**

This suite provides a powerful, user-friendly dashboard to access essential server utilities. While it is designed and optimized for **OpenLiteSpeed (OLS) + CyberPanel** environments, its core components are built to be flexible and can operate effectively on most Linux distributions and control panels.

---

## <a name="table-of-contents"></a>Table of Contents

- [Features](#features)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [How to Use](#how-to-use)
- [Available Tools](#available-tools)
- [Updating the Suite](#updating)
- [Uninstallation](#uninstallation)
- [Contribution](#contribution)
- [License](#license)

---
<br>

<!-- ARABIC JUMP LINK -->
<p align="center">
  <a href="#arabic-version"><strong>عرض النسخة العربية (Click for Arabic Version)</strong></a>
</p>

---

## <a name="features"></a>✨ Features

-   **Bilingual Interface:** Full support for both English and Arabic.
-   **Central Dashboard:** A clean, professional launcher to access all tools.
-   **Powerful & Modular Tools:** A dedicated tool for security and another for disk analysis.
-   **Flexible Installation:** Choose between a simple one-line automatic installation or a manual method.
-   **Simple Updates:** Keep the tools up-to-date with a built-in update mechanism.
-   **Clean Uninstallation:** A dedicated script to remove the tool suite completely.
-   **Persistent Logging:** All critical operations are logged for review and auditing.

## <a name="dependencies"></a>⚙️ Dependencies

The tool suite relies on a few key external programs to function correctly. The installer will attempt to install them automatically.
-   **ClamAV:** The core antivirus engine used by the Security Scanner.
-   **pv (Pipe Viewer):** Used to display progress bars during scans and other operations.
-   **Git, coreutils, etc.:** Standard utilities for installation and operation.

## <a name="installation"></a>🚀 Installation

You can choose between two installation methods:

### Method 1: Automatic Installation (Recommended)
This is the fastest and easiest way. Open your terminal and run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/aljailane/aljailane-tools/main/install.sh | sudo bash
```

### Method 2: Manual Installation
This method gives you more control and allows you to review the code before installation.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/aljailane/aljailane-tools.git
    ```

2.  **Navigate into the directory:**
    ```bash
    cd aljailane-tools
    ```

3.  **Run the installer script:**
    ```bash
    sudo ./install.sh
    ```

Both methods will install the suite and create the universal `aljailane` command.

## <a name="how-to-use"></a>▶️ How to Use

After installation, you can run the main dashboard from anywhere in your terminal by simply typing:

```bash
aljailane
```

## <a name="available-tools"></a>🛠️ Available Tools

### 1. 🛡️ Security Scanner (`sec.sh`)
A comprehensive security tool powered by ClamAV.
-   **Virus Scanning & Cleaning:** Detect and clean viruses, malware, and other threats.
-   **Flexible Scan Targets:** Scan the entire `/home` directory, a specific website, or any custom path.
-   **Scan Scheduling:** Set up automatic daily, weekly, or monthly scans.
-   **ClamAV Management:** Update the ClamAV virus database directly from the tool.
-   **Secure Deletion:** Infected files are first backed up to a safe quarantine location.

### 2. 🔍 Advanced Analytics (`an.sh`)
A powerful tool to analyze and manage disk space.
-   **Find & Clean Large Files:** Search for files within a specific size range.
-   **Customizable Search:** Define the scan path and the min/max file size.
-   **Safe vs. Permanent Deletion:** Choose between moving files to a temporary trash bin or deleting them permanently.
-   **Persistent Logging:** All actions are recorded in a permanent log file.

## <a name="updating"></a>🔄 Updating the Suite

If you installed **manually**, you can update by navigating to the repository folder and running `git pull`.

If you installed **automatically**, the easiest way to update is to re-run the installation command:

```bash
curl -sSL https://raw.githubusercontent.com/aljailane/aljailane-tools/main/install.sh | sudo bash
```

## <a name="uninstallation"></a>🗑️ Uninstallation

You can uninstall the suite using the method that corresponds to your installation.

### Method 1: Automatic Uninstallation
Run the following command in your terminal:
```bash
curl -sSL https://raw.githubusercontent.com/aljailane/aljailane-tools/main/uninstall.sh | sudo bash
```

### Method 2: Manual Uninstallation
If you still have the repository folder, navigate into it and run the script:
```bash
# Navigate into the repository directory first
cd aljailane-tools 
sudo ./uninstall.sh
```
The uninstaller will remove the `aljailane` command and all its files, and will ask for confirmation before deleting any data directories (logs, reports, etc.).

## <a name="contribution"></a>🤝 Contribution

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/aljailane/aljailane-tools/issues).

## <a name="license"></a>📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

<br>
<hr>
<br>

# <a name="arabic-version"></a> جناح أدوات الجيلاني (النسخة العربية)

![Aljailane Tools Logo](https://raw.githubusercontent.com/user-attachments/assets/e080645c-2048-4361-970d-770732817887)

**مجموعة احترافية من أدوات سطر الأوامر لإدارة الخوادم، الفحص الأمني، والتحليل المتقدم.**

---

## ✨ الميزات

-   **واجهة ثنائية اللغة:** دعم كامل للغتين الإنجليزية والعربية.
-   **لوحة تحكم مركزية:** مشغل احترافي ونظيف للوصول إلى جميع الأدوات.
-   **أدوات قوية ونمطية:** أداة مخصصة للأمان وأخرى لتحليل القرص.
-   **تثبيت مرن:** اختر بين التثبيت التلقائي البسيط بسطر واحد أو الطريقة اليدوية.
-   **تحديثات بسيطة:** حافظ على تحديث الأدوات بآخر إصدار عبر آلية تحديث مدمجة.
-   **إلغاء تثبيت نظيف:** سكربت مخصص لإزالة مجموعة الأدوات بالكامل.
-   **تسجيل دائم:** يتم تسجيل جميع العمليات الهامة للمراجعة والتدقيق.

## ⚙️ الاعتماديات

تعتمد مجموعة الأدوات على بعض البرامج الخارجية لتعمل بشكل صحيح. سيحاول المثبت تثبيتها تلقائيًا.
-   **ClamAV:** محرك مكافحة الفيروسات الأساسي.
-   **pv (Pipe Viewer):** يستخدم لعرض أشرطة التقدم.
-   **Git, coreutils, etc.:** أدوات قياسية للتثبيت والتشغيل.

## 🚀 التثبيت

يمكنك الاختيار بين طريقتين للتثبيت:

### الطريقة الأولى: التثبيت التلقائي (موصى به)
هذه هي الطريقة الأسرع والأسهل. افتح الطرفية وقم بتشغيل الأمر التالي:

```bash
curl -sSL https://raw.githubusercontent.com/aljailane/aljailane-tools/main/install.sh | sudo bash
```

### الطريقة الثانية: التثبيت اليدوي
تمنحك هذه الطريقة مزيدًا من التحكم وتسمح لك بمراجعة الكود قبل التثبيت.

1.  **استنساخ المستودع:**
    ```bash
    git clone https://github.com/aljailane/aljailane-tools.git
    ```

2.  **الانتقال إلى المجلد:**
    ```bash
    cd aljailane-tools
    ```

3.  **تشغيل سكربت المثبت:**
    ```bash
    sudo ./install.sh
    ```
كلا الطريقتين ستقومان بتثبيت المجموعة وإنشاء الأمر العام `aljailane`.

## ▶️ كيفية الاستخدام

بعد التثبيت، يمكنك تشغيل لوحة التحكم الرئيسية من أي مكان في الطرفية ببساطة عن طريق كتابة:

```bash
aljailane
```

## 🛠️ الأدوات المتاحة

### 1. 🛡️ فاحص الأمان (`sec.sh`)
-   **فحص وتنظيف الفيروسات:** كشف وتنظيف الفيروسات باستخدام ClamAV.
-   **أهداف فحص مرنة:** فحص مجلد `/home`، موقع ويب محدد، أو أي مسار مخصص.
-   **جدولة الفحص:** إعداد عمليات فحص تلقائية يومية أو أسبوعية أو شهرية.
-   **إدارة ClamAV:** تحديث قاعدة بيانات الفيروسات مباشرة من الأداة.
-   **الحذف الآمن:** نسخ الملفات المصابة احتياطيًا إلى حجر صحي آمن.

### 2. 🔍 التحليلات المتقدمة (`an.sh`)
-   **بحث وتنظيف الملفات الكبيرة:** البحث عن الملفات ضمن نطاق حجم معين.
-   **بحث مخصص:** تحديد مسار الفحص والحد الأدنى/الأقصى لحجم الملف.
-   **الحذف الآمن مقابل الدائم:** اختر بين نقل الملفات إلى سلة مهملات مؤقتة أو حذفها نهائيًا.
-   **تسجيل دائم للإجراءات:** يتم تسجيل جميع الإجراءات في ملف سجل دائم.

## 🔄 تحديث المجموعة

إذا قمت بالتثبيت **يدويًا**، يمكنك التحديث بالانتقال إلى مجلد المستودع وتشغيل `git pull`.

إذا قمت بالتثبيت **تلقائيًا**، فإن أسهل طريقة للتحديث هي إعادة تشغيل أمر التثبيت:

```bash
curl -sSL https://raw.githubusercontent.com/aljailane/aljailane-tools/main/install.sh | sudo bash
```

## 🗑️ إلغاء التثبيت

يمكنك إلغاء تثبيت المجموعة باستخدام الطريقة التي تتوافق مع طريقة التثبيت.

### الطريقة الأولى: إلغاء التثبيت التلقائي
قم بتشغيل الأمر التالي في الطرفية:
```bash
curl -sSL https://raw.githubusercontent.com/aljailane/aljailane-tools/main/uninstall.sh | sudo bash
```

### الطريقة الثانية: إلغاء التثبيت اليدوي
إذا كان لا يزال لديك مجلد المستودع، فانتقل إليه وقم بتشغيل السكربت:
```bash
# انتقل إلى مجلد المستودع أولاً
cd aljailane-tools 
sudo ./uninstall.sh
```
سيقوم سكربت إلغاء التثبيت بإزالة الأمر `aljailane` وجميع ملفاته، وسيطلب تأكيدك قبل حذف أي مجلدات بيانات (سجلات، تقارير، إلخ).

## 🤝 المساهمة

المساهمات، الإبلاغ عن المشاكل، وطلبات الميزات هي موضع ترحيب! لا تتردد في مراجعة [صفحة المشاكل (issues)](https://github.com/aljailane/aljailane-tools/issues).

## 📄 الترخيص

هذا المشروع مرخص بموجب ترخيص MIT. انظر ملف `LICENSE` لمزيد من التفاصيل.

<p align="center">
  <a href="#table-of-contents"><strong>العودة إلى الأعلى (Back to Top)</strong></a>
</p>
