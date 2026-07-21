import json

with open('strings.json', 'r', encoding='utf-8') as f:
    strings = json.load(f)

translations = {
    'en': {s: s for s in strings},
    'ar': {s: s + ' (AR)' for s in strings},
    'ckb': {s: s + ' (CKB)' for s in strings},
    'ku': {s: s + ' (KU)' for s in strings},
}

ar_dict = {
    'Login': 'تسجيل الدخول', 'Register': 'إنشاء حساب', 'Home': 'الرئيسية',
    'Cart': 'عربة التسوق', 'Profile': 'الملف الشخصي', 'Settings': 'الإعدادات',
    'Search products...': 'ابحث عن المنتجات...', 'Categories': 'الفئات',
    'Language': 'اللغة', 'Logout': 'تسجيل الخروج', 'Orders': 'الطلبات',
    'Total': 'المجموع', 'Checkout': 'الدفع', 'Choose Language': 'اختر اللغة'
}

ckb_dict = {
    'Login': 'چوونە ژوورەوە', 'Register': 'خۆتۆمارکردن', 'Home': 'سەرەکی',
    'Cart': 'سەبەتە', 'Profile': 'هەژمار', 'Settings': 'ڕێکخستنەکان',
    'Search products...': 'گەڕان بۆ بەرهەمەکان...', 'Categories': 'پۆلەکان',
    'Language': 'زمان', 'Logout': 'چوونە دەرەوە', 'Orders': 'داواکارییەکان',
    'Total': 'کۆی گشتی', 'Checkout': 'پارەدان', 'Choose Language': 'زمان هەڵبژێرە'
}

ku_dict = {
    'Login': 'Têketin', 'Register': 'Tomarkirin', 'Home': 'Mal',
    'Cart': 'Sivik', 'Profile': 'Profîl', 'Settings': 'Mîheng',
    'Search products...': 'Lêgerîna berheman...', 'Categories': 'Kategorî',
    'Language': 'Ziman', 'Logout': 'Derketin', 'Orders': 'Daxwazî',
    'Total': 'Giştî', 'Checkout': 'Pere dan', 'Choose Language': 'Ziman Hilbijêre'
}

for s in strings:
    if s in ar_dict: translations['ar'][s] = ar_dict[s]
    if s in ckb_dict: translations['ckb'][s] = ckb_dict[s]
    if s in ku_dict: translations['ku'][s] = ku_dict[s]

output = '''class Translations {
  static const Map<String, Map<String, String>> dictionary = {
'''

for lang, dict_data in translations.items():
    output += f"    '{lang}': {{\n"
    for k, v in dict_data.items():
        k_esc = k.replace("'", "\\'").replace("\\n", "\\\\n")
        v_esc = v.replace("'", "\\'").replace("\\n", "\\\\n")
        output += f"      '{k_esc}': '{v_esc}',\n"
    output += "    },\n"

output += '''  };
}
'''

with open(r'c:\Users\sarba\amazon\buyer_app\lib\core\localization\translations.dart', 'w', encoding='utf-8') as f:
    f.write(output)

print('translations.dart generated successfully!')
