#!/bin/bash

# SQL scripts in correct execution order
SCRIPTS=(
  "001-setup-auth.sql"
  "002-create-tables.sql"
  "003-create-indexes.sql"
  "004-create-rls-policies.sql"
  "005-create-functions.sql"
  "006-seed-data.sql"
)

echo "🚀 Starting Supabase SQL setup..."
echo "📁 Using root directory for SQL scripts."

# Confirm execution
read -p "Are you sure you want to run these SQL scripts in order? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
  echo "❌ Cancelled by user."
  exit 1
fi

# Loop through each script and run it
for script in "${SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    echo "▶️ Running: $script"
    supabase db query < "$script"
    if [ $? -ne 0 ]; then
      echo "❌ Error in $script. Halting execution."
      exit 1
    fi
  else
    echo "⚠️ File not found: $script"
  fi
done

echo "✅ All SQL scripts executed successfully!"
