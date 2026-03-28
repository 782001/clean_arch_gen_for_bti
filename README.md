# 🛠️ My Personal Clean Architecture Generator (Internal Tool)

**English ([English](#english)) | العربية ([بالبلدي](#arabic))**

---

<a name="english"></a>
## 🌏 English - Author's Note & Usage Guide

> [!IMPORTANT]
> **Internal Use Only:** This tool is custom-built specifically for my personal projects and architectural patterns. It is not intended for general distribution as it relies on my specific project structures (like the DI container markers).

### 🚀 What's New Today?
1.  **Isolated Dependency Injection:** Every feature now gets its own `service_injection` folder containing `{feature}_injection.dart`. This keeps dependencies decoupled and the main injection container clean.
2.  **Automatic Entity/Model Prefixing:** All generated sub-classes for Entities and Models are now intelligently prefixed using the root name (e.g., `GetCategoryByIdResponseEntity` prefixes all sub-classes with `GetCategoryById`).
3.  **Multiple Endpoints Support:** The generator now perfectly supports merging multiple endpoints/use-cases into the same feature-isolated Cubit and DI file without duplication.
4.  **Cubit Method Cleanup:** Methods generated in the Cubit now check if parameters exist. If no parameters are needed, the empty braces `{}` are removed for cleaner code (e.g., `void getMethod() async`).

### 🚀 Why I built this?
To automate the repetitive parts of my Flutter development. It specifically:
1.  **Parses APIs my way:** Handles recursive JSON to generate Models/Entities according to my Clean Architecture standards.
2.  **Isolated DI:** Generates feature-specific `init()` methods and automatically wires them into the main `injection_container.dart` under the `//! Features` marker.
3.  **Matches my templates:** Uses `.tpl` files that contain the exact boilerplate I prefer.
4.  **Cubit Integration:** Automatically generates the ready-to-use endpoint method directly inside the Cubit, supporting multiple use-case injections in the constructor.

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
    "entity": "LoginResponseEntity", //entity name (prefix will be 'Login')
    //here put the Full response after "data":
    "data": {
      "token": "string",
      "user": { "id": 1, "name": "John" }
    }
  },
  "endpoint": {
    "url": "loginEndpoint", //endpoint name 
    "method": "post" //post or get or any other method
  },
  "request": {
    "query": {
      "email": "String",//pass  parameter name and type
      "password": "String"//query parameters for passing data to the endpoint
    },
    "body": {} //body parameters for passing data to the endpoint
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

### 🚀 إيه الجديد النهاردة؟
1.  **فصل الـ Dependencies:** كل فيتشر بقى ليها ملف DI خاص بيها في فولدر اسمه `service_injection`. ده بيخلي الكود منظم والملف الأساسي بتاع المشروع مش زحمة.
2.  **تسمية تلقائية (Prefixing):** الـ Models والـ Entities الفرعية دلوقتي بيتبدؤوا باسم الفيتشر الأساسي أوتوماتيك (زي `GetCategoryById`).
3.  **دعم أكتر من Endpoint:** الأداة دلوقتي تقدر تضيف أكتر من UseCase و Endpoint لنفس الـ Cubit ونفس ملف الـ DI من غير ما تمسح القديم.
4.  **تنظيف الـ Cubit Methods:** لو الـ API مش محتاج Parameters، الـ Method بتتعمل من غير أقواس فاضية `{}` وشكل الكود بيبقى أنضف.

### 🚀 أنا عملت الكود ده ليه؟
عشان أوفر وقت في الحاجات اللي بتتعاد كل شوية في الـ Flutter. بالظبط بتعمل كدة:
1.  **بتقرأ الـ API بطريقتي:** بتطلع الـ Models والـ Entities أوتوماتيك من أي JSON معقد وبتحط لها الـ Prefix المناسب.
2.  **حقن Dependencies منظم:** بيعمل ملف DI لكل فيتشر وبينادي عليه في ملف الـ `injection_container.dart` الأساسي تحت سطر الـ `//! Features`.
3.  **ماشية على الـ Templates بتاعتي:** بتستخدم ملفات الـ `.tpl` اللي فيها شكل الكود اللي أنا بكتبه والـ Service Locator بتاعي `sl`.
4.  **تكامل مع الـ Cubit:** بيبني لك الـ Method جاهز جوه الـ Cubit وبيدعم إضافة أكتر من UseCase في الـ Constructor أوتوماتيك.

### 🛠 بشغله إزاي؟
```bash
dart run clean_arch_gen.dart generate feature.json
```

---

### 📌 ملاحظات ليّ أنا (Personal Notes):
- لما أغير في شكل الكود الأساسي، لازم أعدل ملفات الـ `.tpl` في فولدر الـ `templates`.
- ملف الـ DI الأساسي لازم يكون فيه سطر `//! Features` عشان الـ Generator يعرف يحط الـ `await FeatureDI.init()` فين.
- الـ Generator بيحول الـ `initDependencies` أوتوماتيك لـ `async` عشان يدعم الـ `init` بتاع الفيتشرز.
