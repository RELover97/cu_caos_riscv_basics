#!/usr/bin/env bash
# Проверяем линейные программы по их выводу; в самих программах нет ветвлений.
set -euo pipefail
cd "$(dirname "$0")/.."
jar=${RARS_JAR:-tools/rars.jar}
java=${JAVA:-java}
[[ -f "$jar" ]] || { echo "JAR not found: $jar; see docs/setup.md" >&2; exit 1; }
for src in rars/*.asm; do
    case "$src" in
        *01_first*) expected=42 ;;
        *02_immediates*) expected=0 ;;
        *03_arithmetic*) expected=-3 ;;
        *04_bits*) expected=2 ;;
        *05_compare*) expected=1 ;;
        *06_poly*) expected=41 ;;
        *) echo "Unknown example: $src" >&2; exit 1 ;;
    esac
    actual=$("$java" -jar "$jar" nc me rv64 sm ae2 se3 1000 "$src" | tr -d '\r')
    if [[ "$actual" != "$expected" ]]; then
        printf 'FAIL %s: expected %s, got %s\n' "$src" "$expected" "$actual" >&2
        exit 1
    fi
    printf 'OK %s (%s)\n' "$src" "$actual"
done
