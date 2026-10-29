# Kokoro 모델 폴더

`pdf_tts.html`의 **Kokoro (고품질)** 엔진이 읽는 폴더입니다. 기본 경로는 HTML 옆의 `./kokoro/` 이고,
HTML의 ⚙ 설정에서 다른 경로(상대 경로 또는 `http(s)://` 주소)로 바꿀 수 있습니다.

## 필요한 파일

Hugging Face 저장소 [`onnx-community/Kokoro-82M-v1.0-ONNX`](https://huggingface.co/onnx-community/Kokoro-82M-v1.0-ONNX)와 같은 구조입니다.

```
kokoro/
├── config.json
├── tokenizer.json
├── tokenizer_config.json
├── onnx/
│   ├── model_quantized.onnx   ← 권장 (약 92MB, CPU/WASM)
│   ├── model.onnx             ← 선택 (약 326MB, WebGPU용 fp32)
│   └── model_fp16.onnx        ← 선택
└── voices/
    └── af_heart.bin …         ← 영어 음성 16종은 이 저장소에 포함되어 있음
```

이 저장소에는 **음성(`voices/`)만** 들어 있습니다. 모델 파일(`config.json`, `tokenizer*.json`, `onnx/*.onnx`)은 용량 때문에
넣지 않았으니 아래 중 한 방법으로 받아 이 폴더에 두세요.

```bash
# 방법 1) 스크립트 (curl 필요, 권장 모델 q8 + 설정 파일)
./kokoro/download-model.sh

# 방법 2) huggingface-cli
huggingface-cli download onnx-community/Kokoro-82M-v1.0-ONNX \
  config.json tokenizer.json tokenizer_config.json onnx/model_quantized.onnx \
  --local-dir kokoro
```

WebGPU로 더 빠르게 돌리려면 `onnx/model.onnx`(fp32)도 함께 두세요. **자동** 설정은
WebGPU가 되고 `model.onnx`가 있으면 WebGPU를, 아니면 `model_quantized.onnx`로 CPU(WASM)를 씁니다.

## 서버로 열어야 합니다

브라우저는 `file://` 로 연 페이지에서 모델 파일을 읽지 못합니다. 이 폴더를 웹 서버로 서비스하세요.

```bash
python3 -m http.server 8000     # 그 다음 http://localhost:8000/pdf_tts.html
```

배포 시 폴더 구조는 다음과 같습니다.

```
pdf_tts.html
vendor/            ← Kokoro 라이브러리와 ONNX Runtime (이 저장소에 포함)
kokoro/            ← 모델 폴더 (이 README가 있는 곳)
```

## ⚙ 설정 창

- **모델 폴더 경로**: 기본 `./kokoro/`. 다른 서버의 주소도 가능(해당 서버가 CORS를 허용해야 함).
- **장치 / 모델 정밀도**: 보통 자동이면 됩니다.
- **모델 확인**: 필요한 파일이 제자리에 있는지 점검합니다.
- **캐시 비우기**: 브라우저에 저장된 모델·음성 캐시를 지웁니다 (모델 파일을 교체했을 때).

## 라이선스

Kokoro-82M 모델과 `kokoro-js`는 Apache-2.0 입니다. 포함된 라이브러리 라이선스는 `vendor/LICENSE-*.txt` 를 참고하세요.
