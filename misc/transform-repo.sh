#!/bin/bash

# Ask for repo name
read -p "Enter the name of the repo: " REPO_NAME

# Function to safely create a directory if it doesn't exist
create_dir() {
    [ ! -d "$1" ] && mkdir -p "$1"
}

# Create required directories
create_dir dockerfiles
create_dir handlers
create_dir setup
create_dir src

# Move Dockerfiles to dockerfiles directory
dockerfiles_exist=false
for file in *; do
    if [[ $file =~ ^Dockerfile\..* ]]; then
        mv "$file" dockerfiles/
        dockerfiles_exist=true
    fi
done
$dockerfiles_exist || echo "No Dockerfiles matching 'Dockerfile.*' found."

# Move *_handler.py files to handlers directory
find . -type f -name "*_handler.py" -not -path "./handlers/*" -exec mv {} handlers/ \;

# Move builder files to setup directory
if [ -d "builder" ]; then
    mv builder/* setup/
    rmdir builder
else
    echo "Builder directory not found."
fi

# Ensure __init__.py exists
for dir in handlers setup src; do
    [ ! -f "$dir/__init__.py" ] && touch "$dir/__init__.py"
done

# Move start.sh to setup directory
if [ -f "src/start.sh" ]; then
    mv src/start.sh setup/
else
    echo "start.sh not found in src directory."
fi

# Create setup.py if it doesn't exist
if [ ! -f "setup/setup.py" ]; then
    cat <<EOF > setup/setup.py
from setuptools import find_packages, setup

setup(
    name="$REPO_NAME",
    version="0.1.0",
    packages=find_packages(
        include=["src", "src.*", "setup", "setup.*", "handlers", "handlers*"]
    ),
)
EOF
else
    echo "setup.py already exists in the setup directory."
fi

# Function to replace hard-coded file paths
replace_hardcoded_paths_with_check() {
    local directory="$1"
    local search_pattern="$2"
    local replace_pattern="$3"

    # Ensure patterns are not empty
    if [[ -z "$search_pattern" || -z "$replace_pattern" ]]; then
        echo "Error: Search or replace pattern is empty. Skipping replacements in $directory."
        return
    fi

    # Perform find and replace, ensuring paths already corrected are not replaced again
    find "$directory" -type f | while read -r file; do
        sed -i "s|$search_pattern|$replace_pattern|g" "$file" 2>/dev/null
    done
}

# Replace hard-coded paths
replace_hardcoded_paths_with_check "src" "/src" "/app/src"
replace_hardcoded_paths_with_check "handlers" "/src" "/app/src"

replace_hardcoded_paths_with_check "handlers" "/inputs" "/app/inputs"
replace_hardcoded_paths_with_check "src" "/inputs" "/app/inputs"

replace_hardcoded_paths_with_check "handlers" "/outputs" "/app/outputs"
replace_hardcoded_paths_with_check "src" "/outputs" "/app/outputs"

replace_hardcoded_paths_with_check ".github/workflows" "./Dockerfile" "./dockerfiles/Dockerfile"

# Replace /workspace with /app in setup/start.sh
if [ -f "setup/start.sh" ]; then
    sed -i 's|/workspace|/app|g' setup/start.sh
fi

# Delete setup_nb.sh and remove lines referencing it
if [ -f "setup/setup_nb.sh" ]; then
    rm setup/setup_nb.sh
fi
sed -i '/setup_nb.sh/d' setup/start.sh

echo "Restructuring complete. The repo has been transformed into the desired structure."
