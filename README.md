# HideBar

أداة جيلبريك (iOS Jailbreak Tweak) لإخفاء شريط الهوم السفلي (الخط الأبيض / Home Indicator) بالكامل من الجهاز — في شاشة القفل، الشاشة الرئيسية، مبدّل التطبيقات، مركز التحكم، وداخل جميع التطبيقات، مع الحفاظ على عمل إيماءات السحب بشكل طبيعي.

## المميزات
- إخفاء فوري ومباشر لشريط الهوم بالكامل بدون أي إعدادات إضافية.
- تصميم آمن ومستقر يعمل داخل `SpringBoard` فقط (`com.apple.springboard`) لتفادي أي تعارض مع التطبيقات أو الدخول في Safe Mode.
- التحقق من وجود الفئات وتوقيع الدوال قبل ربطها بـ `MSHookMessageEx` لتوافق كامل مع **ElleKit** و**Roothide** و**arm64e**:
  - `MTLumaDodgePillView`
  - `MTStaticColorPillView`
  - `CSAlwaysOnHomeAffordancePillView`
  - `SBFHomeAffordanceView`
- يدعم معماريات `arm64` و `arm64e` (بما فيها أجهزة iPhone XS Max وما بعده).
- يدعم حزم **Roothide** (مثل Dopamine-roothide / relaxin / Serotonin) و **Rootless** و **Rootful**.
- بناء تلقائي عبر **GitHub Actions** لإنتاج ملفات `.deb` جاهزة للتثبيت.

## تحميل ملف التثبيت (.deb)
عند رفع التعديلات إلى GitHub، يقوم مسار `.github/workflows/build.yml` ببناء ثلاث نسخ تلقائياً:
- **Roothide** (`dist/roothide/*.deb` بلاحقة `iphoneos-arm64e.deb`) — جاهزة مباشرة لجيلبريك Roothide / relaxin على أجهزة مثل iPhone XS Max.
- **Rootless** (`dist/rootless/*.deb` بلاحقة `iphoneos-arm64.deb`) — لجيلبريك Dopamine و palera1n rootless و NathanLR.
- **Rootful** (`dist/rootful/*.deb` بلاحقة `iphoneos-arm.deb`) — لجيلبريك Rootful.

يمكنك تحميلها من تبويب **Actions** ثم اختيار آخر تشغيل ناجح وتحميل **HideBar-deb-packages**.

## البناء اليدوي (عبر Roothide Theos)
للبناء بصيغة **Roothide**:
```bash
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide
```

للبناء بصيغة **Rootless**:
```bash
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless
```

للبناء بصيغة **Rootful**:
```bash
make clean package FINALPACKAGE=1
```
