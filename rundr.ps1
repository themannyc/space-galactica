#!/usr/bin/env sh
echo --% >/dev/null;: ' | Out-Null
<#'
# ---------- Unix (sh) ----------
cd "$(dirname "$0")" || exit 1
case "$(uname -s)" in
    Linux*)  exec ./dragonruby.linux "$@" ;;
    Darwin*) exec ./dragonruby.macos "$@" ;;
    CYGWIN*|MINGW*|MSYS*) exec ./dragonruby.exe "$@" ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac
#>
# ---------- Windows (PowerShell) ----------
Set-Location -LiteralPath $PSScriptRoot
& (Join-Path $PSScriptRoot 'dragonruby.exe') @args
exit $LASTEXITCODE
