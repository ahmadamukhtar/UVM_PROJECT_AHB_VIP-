import os

def process_files_in_directory(directory="."):
    original = "Usama Ahmed (Lead)\nAhmad Mukhtar"
    replacement = "Ahmad Mukhtar\nUsama Ahmed"

    for root, _, files in os.walk(directory):
        for file_name in files:
            file_path = os.path.join(root, file_name)

            try:
                with open(file_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                if original in content:
                    new_content = content.replace(original, replacement)
                    with open(file_path, 'w', encoding='utf-8') as file:
                        file.write(new_content)
                    print(f"✅ Updated: {file_path}")
            except (UnicodeDecodeError, PermissionError) as e:
                print(f"⚠️ Skipped: {file_path} ({e})")

# Just call it
process_files_in_directory()
