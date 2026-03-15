# 🚀 Clean Architecture Generator (clean_arch_gen)

**Bilingual Documentation: [English](#english) | [العربية (مصري)](#arabic-egyptian)**

---

<a name="english"></a>

## 🌏 English - Professional Documentation

### Overview

`clean_arch_gen` is a powerful CLI tool designed for Flutter developers to automate the creation of Clean Architecture layers. It doesn't just create folders; it parses complex, nested JSON responses to generate Entities and Models recursively, sets up UseCases, Repositories, and even integrates with your existing Dependency Injection container.

### Key Features

- **⚡ Rapid Generation:** Generate all boilerplate for a feature in seconds.
- **🧠 Complex JSON Parser:** Recursively handles nested objects, lists, and dynamic types from any API response.
- **💉 DI Integration:** Automatically injects new feature dependencies into your existing `injection_container.dart`.
- **📂 Flexible Paths:** Support for custom `base_path` and `layer_path` to fit any project structure.
- **🏗️ Clean Architecture Adherence:** Strictly follows Data, Domain, and Presentation layer separation.

### Installation

Activate the package globally or use it within your project:

```bash
dart pub global activate --source path .
# Or run within project:
dart run clean_arch_gen.dart generate feature.json
```

### Configuration (`feature.json`)

```json
{
  "feature": "login", //feature name
  "base_path": "F:\\myApps\\my_project\\lib\\features", //base project path
  "layer_path": "auth", //layer under base_path
  "response": {
    "entity": "LoginResponseEntity", //entity name
    "data": {
      //here put the Full response
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

<a name="arabic-egyptian"></a>

## 🇪🇬 العربية (بلهجة مصرية) - التوثيق الرسمي

### يعني إيه `clean_arch_gen`؟

دي أداة (CLI tool) معمولة مخصوص لمطورين Flutter عشان تخلصهم من وجع الدماغ بتاع كتابة الـ Boilerplate كل شوية. الأداة دي بتبني لك الـ Clean Architecture كاملة، مش بس فولدرات، لا دي كمان بتقرأ الـ API Response وتعملك الـ Models والـ Entities لوحدها مهما كانت معقدة.

### المميزات اللي هتروق عليك:

- **🚀 سرعة الصاروخ:** بتبني الفيتشر (Feature) كلها في ثانية.
- **🧩 ذكاء اصطناعي في الـ Parsing:** مبيفرقش معاها الـ JSON كبير ولا صغير، متداخل (Nested) ولا فيه Lists، هتعملك الـ Classes صح.
- **🔌 حقن التبعيات (Dependency Injection):** بتدخل الكود الجديد في ملف الـ `injection_container.dart` بتاعك أوتوماتيك تحت سطر `//! Features`.
- **🗺️ حرية في المسارات:** تقدر تحدد لها الـ `base_path` اللي إنت عاوزه والـ `layer_path` كمان.

### إزاي تشغلها يا بطل؟

نزل التبعيات وشغلها من الـ Terminal عادي جداً:

```bash
dart run clean_arch_gen.dart generate feature.json
```

### شكل ملف الإعدادات (`feature.json`):

```json
{
  "feature": "login",
  "base_path": "F:\\مشروعي\\lib\\features",
  "layer_path": "auth",
  "response": {
    "entity": "LoginResponseEntity", //entity name
    "data": {
      //here put the Full response
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

### 🛠️ Advanced Usage / استخدامات متقدمة

- **Injection Container Injection:**
  Ensure your `injection_container.dart` has a comment line like `//! Features` so the tool knows exactly where to put the new registrations.
  تأكد إن ملف الـ `injection_container.dart` بتاعك فيه سطر الكومنت ده `//! Features` عشان الأداة تعرف تحط الكود الجديد فين بالظبط.

- **Entity & Model Naming:**
  The tool intelligently replaces "Entity" with "Model" for data layer classes.
  الأداة بتعرف تفرق بين الـ Entity والـ Model وبتظبط الأسامي لوحدها في الـ Data Layer.
