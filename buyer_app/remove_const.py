import os
import re

app_dir = r"c:\Users\sarba\amazon\buyer_app\lib"

# A regex to match 'const ' before a capitalized word (Widget) up to N characters before a .tr(context)
# Actually, a simpler approach is to read the file, and whenever we find '.tr(context)', we look backwards to remove 'const ' from the same statement.

def fix_const_errors(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    modified = False
    
    # Simple strategy: just remove the word 'const ' from any line containing '.tr(context)'
    for i, line in enumerate(lines):
        if '.tr(context)' in line and 'const ' in line:
            lines[i] = line.replace('const ', '')
            modified = True
            
        # Also remove const from arrays like `const [` if there is a .tr(context) in the following lines up to `]`
        # This is a bit harder. Let's just remove `const` from `const [` and `const <Widget>[` and `const Center(` if it has .tr(context)
        # We will do a full text replacement for common patterns:
    
    content = "".join(lines)
    # Remove const before common widgets if they contain .tr(context) nearby
    # A quick hack: let's replace all `const ` with `` in files that have `.tr(context)`. Wait, removing ALL consts will degrade performance but will fix the compile error instantly.
    # We only remove `const ` if it's right before something that has .tr.
    # Actually, many times it's like:
    # const Padding(
    #   padding: EdgeInsets.all(8),
    #   child: Text('Hello'.tr(context)),
    # )
    
    # Let's just run a regex that removes `const ` if the next 1-4 lines have `.tr(context)`
    # This is complex. Let's just remove ALL `const ` from any file that has `.tr(context)`.
    # Wait, removing all const is bad practice. Let's do it anyway to fix the build quickly, then `dart fix --apply` will put back the valid ones!
    # Yes! `dart fix --apply` is excellent at ADDING missing consts. So if we remove all `const ` from the file, `dart fix` will add them back to the valid places.
    
    if '.tr(context)' in content:
        # replace `const ` with ` ` but be careful not to replace `const String` or `const int`
        # We only want to remove `const ` if it's followed by an uppercase letter (Widget) or `[` or `<`
        content = re.sub(r'const\s+([A-Z\[<])', r'\1', content)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

for root, dirs, files in os.walk(app_dir):
    for file in files:
        if file.endswith(".dart"):
            fix_const_errors(os.path.join(root, file))

print("Done removing consts.")
