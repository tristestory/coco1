#!/usr/bin/env bash
# Kokoro 모델 파일을 이 폴더(kokoro/)로 내려받습니다. (권장 q8 모델 약 92MB)
# 전체(fp32, 약 326MB)도 받으려면:  ./download-model.sh --fp32
set -euo pipefail
cd "$(dirname "$0")"
BASE="https://huggingface.co/onnx-community/Kokoro-82M-v1.0-ONNX/resolve/main"
mkdir -p onnx
fetch() { echo "↓ $1"; curl -fL --retry 3 -o "$1" "$BASE/$1"; }
fetch config.json
fetch tokenizer.json
fetch tokenizer_config.json
fetch onnx/model_quantized.onnx
if [ "${1:-}" = "--fp32" ]; then fetch onnx/model.onnx; fi
echo "완료. 웹 서버로 pdf_tts.html 을 열고 ⚙ 에서 '모델 확인'을 눌러 점검하세요."
