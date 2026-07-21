import os
import re
import json

app_dir = r"c:\Users\sarba\amazon\buyer_app\lib"
translations_file = r"c:\Users\sarba\amazon\buyer_app\lib\core\localization\translations.dart"

# We will collect all unique english strings here
en_strings = set()

# Regex to find Text('something') or Text("something")
# Avoiding strings with interpolation $
text_regex = re.compile(r"Text\(\s*(['\"])([^'\$]+?)\1")
section_title_regex = re.compile(r"SectionTitle\(\s*title:\s*(['\"])([^'\$]+?)\1")
title_regex = re.compile(r"title:\s*(['\"])([^'\$]+?)\1\s*,")
label_regex = re.compile(r"label:\s*(['\"])([^'\$]+?)\1")
hint_regex = re.compile(r"hintText:\s*(['\"])([^'\$]+?)\1")
button_regex = re.compile(r"CustomButton\(\s*text:\s*(['\"])([^'\$]+?)\1")

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    modified = False

    def text_replacer(match):
        nonlocal modified
        quote = match.group(1)
        text = match.group(2)
        if len(text.strip()) == 0:
            return match.group(0)
        en_strings.add(text)
        modified = True
        return f"Text({quote}{text}{quote}.tr(context)"

    def section_replacer(match):
        nonlocal modified
        quote = match.group(1)
        text = match.group(2)
        if len(text.strip()) == 0:
            return match.group(0)
        en_strings.add(text)
        modified = True
        return f"SectionTitle(title: {quote}{text}{quote}.tr(context)"

    def label_replacer(match):
        nonlocal modified
        quote = match.group(1)
        text = match.group(2)
        if len(text.strip()) == 0:
            return match.group(0)
        en_strings.add(text)
        modified = True
        return f"label: {quote}{text}{quote}.tr(context)"
        
    def hint_replacer(match):
        nonlocal modified
        quote = match.group(1)
        text = match.group(2)
        if len(text.strip()) == 0:
            return match.group(0)
        en_strings.add(text)
        modified = True
        return f"hintText: {quote}{text}{quote}.tr(context)"

    def button_replacer(match):
        nonlocal modified
        quote = match.group(1)
        text = match.group(2)
        if len(text.strip()) == 0:
            return match.group(0)
        en_strings.add(text)
        modified = True
        return f"CustomButton(text: {quote}{text}{quote}.tr(context)"

    content = text_regex.sub(text_replacer, content)
    content = section_title_regex.sub(section_replacer, content)
    # Be careful with title: and label: as they might not have context available directly or might not be widgets
    # But usually .tr(context) works if context is in scope.
    content = label_regex.sub(label_replacer, content)
    content = hint_regex.sub(hint_replacer, content)
    content = button_regex.sub(button_replacer, content)

    if modified:
        # Add import if not exists
        import_stmt = "import 'package:buyer_app/core/localization/string_extension.dart';"
        if import_stmt not in content:
            # find first import
            import_idx = content.find('import ')
            if import_idx != -1:
                content = content[:import_idx] + import_stmt + '\n' + content[import_idx:]
            else:
                content = import_stmt + '\n\n' + content

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated: {filepath}")

for root, dirs, files in os.walk(app_dir):
    for file in files:
        if file.endswith(".dart") and not file.endswith("translations.dart") and not file.endswith("string_extension.dart") and not file.endswith("app_localizations.dart"):
            process_file(os.path.join(root, file))

# Write extracted strings to a temp json so we can translate them and put them in translations.dart
with open('strings.json', 'w', encoding='utf-8') as f:
    json.dump(list(en_strings), f, indent=4)

print("Done parsing. Extracted", len(en_strings), "strings.")
