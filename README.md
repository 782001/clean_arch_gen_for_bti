# 🛠️ My Personal Clean Architecture Generator (Internal Tool)

**English ([English](#english)) | العربية ([بالبلدي](#arabic))**

---

<a name="english"></a>
## 🌏 English - Author's Note & Usage Guide

> [!IMPORTANT]
> **Internal Use Only:** This tool is custom-built specifically for my personal projects and architectural patterns. It is not intended for general distribution as it relies on my specific project structures (like the DI container markers).

### 🚀 Why I built this?
To automate the repetitive parts of my Flutter development. It specifically:
1.  **Parses APIs my way:** Handles recursive JSON to generate Models/Entities according to my Clean Architecture standards.
2.  **Integrates into my DI:** Injects code directly into my `injection_container.dart` where I've placed the `//! Features` marker.
3.  **Matches my templates:** Uses `.tpl` files that contain the exact boilerplate I prefer.

### 🛠 How I run it:
```bash
# Running from the project root
dart run clean_arch_gen.dart generate feature.json
```

### 📝 My `feature.json` Configuration:
```json
{
  "feature": "login", //feature name
  "base_path": "F:\\myApps\\my_project\\lib\\features", //base project path
  "layer_path": "auth", //layer under base_path
  "response": {
    "entity": "LoginResponseEntity", //entity name
    //here put the Full response after "data":
    "data": {
      "token": "string",
      "user": { "id": 1, "name": "John" }
    }
  },
  "presentation": {
    "cubit": true, //true or false
    "injection_container": true, //true or false
    "injection_container_path": "lib\\core\\services\\injection_container.dart" //path to injection_container.dart
  }
}
```

---

<a name="arabic"></a>
## 🇪🇬 بالعربي - بتاع مين وايه لزمته؟

> [!IMPORTANT]
> **استخدام شخصي فقط:** الأداة دي معمولة ليّ أنا ولوحدي عشان تمشي مع طريقة الكود اللي أنا بكتبها والـ Structure بتاع مشاريعي. مش معمولة للنشر العام لأنها بتعتمد على "علامات" معينة بحطها في ملفات الـ Injection بتاعتي.

### 🚀 أنا عملت الكود ده ليه؟
عشان أوفر وقت في الحاجات اللي بتتعاد كل شوية في الـ Flutter. بالظبط بتعمل كدة:
1.  **بتقرأ الـ API بطريقتي:** بتطلع الـ Models والـ Entities أوتوماتيك من أي JSON معقد.
2.  **بتحقن الـ Dependencies عندي:** بتدخل الكود الجديد في ملف الـ `injection_container.dart` بتاعي بالظبط تحت سطر الـ `//! Features`.
3.  **ماشية على الـ Templates بتاعتي:** بتستخدم ملفات الـ `.tpl` اللي فيها شكل الكود اللي أنا بحبه.

### 🛠 بشغله إزاي؟
```bash
dart run clean_arch_gen.dart generate feature.json
```

### 📝 شكل ملف الـ `feature.json` اللي بستخدمه:
```json
{
  "feature": "login", //feature name
  "base_path": "F:\\myApps\\مشروعي\\lib\\features", //base project path
  "layer_path": "auth", //layer under base_path
  "response": {
    "entity": "LoginResponseEntity", //entity name
    //here put the Full response after "data":
    "data": {
      "success": true,
      "data": { "token": "..." }
    }
  },
  "presentation": {
    "cubit": true, //true or false
    "injection_container": true, //true or false
    "injection_container_path": "lib\\core\\services\\injection_container.dart" //path to injection_container.dart
  }
}
```

---

### 📌 ملاحظات ليّ أنا (Personal Notes):
- لما أغير في شكل الكود الأساسي، لازم أعدل ملفات الـ `.tpl` في فولدر الـ `templates`.
- لازم دايماً أتأكد إن سطر `//! Features` موجود في ملف الـ DI عشان الـ Generator ميتلخبطش.
