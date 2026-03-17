#!/bin/bash

# StegoShield Setup Script
# Run this on a fresh clone: bash setup.sh
# Usage: bash scripts/setup.sh

set -e  # stop if any command fails

echo "🚀 Setting up StegoShield..."

# ── CHECK PYTHON ────────────────────────────────────────────
echo ""
echo "🔍 Checking Python..."

if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found. Please install Python 3.11+"
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# ── CHECK NODE ──────────────────────────────────────────────
echo ""
echo "🔍 Checking Node..."

if ! command -v node &> /dev/null; then
    echo "❌ Node not found. Please install Node.js 18+"
    exit 1
fi

echo "✅ Node found: $(node --version)"

# ── CHECK FFMPEG ─────────────────────────────────────────────
echo ""
echo "🔍 Checking ffmpeg (needed for audio/video processing)..."

if ! command -v ffmpeg &> /dev/null; then
    echo "⚠️  ffmpeg not found."
    echo "👉 Install it:"
    echo "   Mac:   brew install ffmpeg"
    echo "   Linux: sudo apt install ffmpeg"
else
    echo "✅ ffmpeg found: $(ffmpeg -version 2>&1 | head -n 1)"
fi

# ── BACKEND SETUP ────────────────────────────────────────────
echo ""
echo "📦 Setting up Python backend..."

cd backend

# Create virtual environment
echo "🔧 Creating virtual environment..."
python3 -m venv venv

# Activate it
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
echo "📥 Installing Python dependencies (torch is large, be patient)..."
pip install -r requirements.txt

echo "✅ Backend dependencies installed"

# Check backend .env
echo ""
if [ ! -f .env ]; then
    echo "⚠️  No backend .env file found."
    if [ -f .env.example ]; then
        echo "👉 Copy and fill in your values:"
        echo "   cp backend/.env.example backend/.env"
    fi
else
    echo "✅ Backend .env file found"
fi

cd ..

# ── FRONTEND SETUP ───────────────────────────────────────────
echo ""
echo "📦 Setting up React frontend..."

cd frontend

# Check frontend .env
echo ""
if [ ! -f .env ]; then
    echo "⚠️  No frontend .env file found."
    if [ -f .env.example ]; then
        echo "👉 Copy and fill in your values:"
        echo "   cp frontend/.env.example frontend/.env"
    else
        echo "👉 Create frontend/.env with your Firebase and API config"
    fi
else
    echo "✅ Frontend .env file found"
fi

echo "📥 Installing Node dependencies..."
npm install

echo "🔨 Building React frontend..."
npm run build

echo "✅ Frontend built successfully"

cd ..

# ── DONE ─────────────────────────────────────────────────────
echo ""
echo "✅ Setup complete!"
echo ""
echo "▶️  To start the backend:"
echo "   cd backend && source venv/bin/activate && python app.py"
echo ""
echo "▶️  To start the frontend (dev mode):"
echo "   cd frontend && npm run dev"
echo ""
echo "▶️  Frontend build output is in frontend/dist/"
echo "   Flask will serve it automatically when backend runs."