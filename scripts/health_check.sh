#!/bin/bash

# StegoShield Health Check Script
# Run this to verify the app is running correctly
# Usage: bash scripts/health_check.sh
# Usage with custom URL: bash scripts/health_check.sh http://your-server:5000

BASE_URL="${1:-http://localhost:5000}"

PASS=0
FAIL=0

check() {
    local name=$1
    local url=$2
    local expected=$3

    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")

    if [ "$response" = "$expected" ]; then
        echo "✅ $name — HTTP $response"
        PASS=$((PASS + 1))
    else
        echo "❌ $name — Expected HTTP $expected, got HTTP $response"
        FAIL=$((FAIL + 1))
    fi
}

echo ""
echo "🏥 StegoShield Health Check"
echo "🌐 Target: $BASE_URL"
echo "─────────────────────────────"

# ── CHECKS ───────────────────────────────────────────────────
check "Backend alive"        "$BASE_URL/ping"         "200"
check "Database connection"  "$BASE_URL/api/test_db"  "200"
check "Login route"          "$BASE_URL/login"        "200"
check "Upload route"         "$BASE_URL/upload"       "200"

# ── SUMMARY ──────────────────────────────────────────────────
echo "─────────────────────────────"
echo "✅ Passed: $PASS"
echo "❌ Failed: $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "🎉 All checks passed! StegoShield is healthy."
    exit 0
else
    echo "⚠️  Some checks failed. Check your backend logs."
    exit 1
fi