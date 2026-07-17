#!/bin/zsh
set -e

sudo chown -R $(whoami):$(whoami) .build 2>/dev/null || true

# Silence direnv output.
# In direnv 2.36+, DIRENV_LOG_FORMAT env var is ignored unless direnv.toml exists.
# See: https://github.com/direnv/direnv/issues/1418
mkdir -p ~/.config/direnv
cat > ~/.config/direnv/direnv.toml <<'EOF'
[global]
log_format = ""
hide_env_diff = true
EOF

# Resolve SPM dependencies if a project already exists.
if [ -f Package.swift ]; then
  swift package resolve
fi
