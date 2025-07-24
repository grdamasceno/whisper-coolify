from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)
MODEL_PATH = "whisper.cpp/models/ggml-medium.bin"

@app.route('/transcribe', methods=['POST'])
def transcribe():
    audio_file = request.files['audio']
    audio_file.save('input.wav')

    result = subprocess.run(
        ["./whisper.cpp/main", "-m", MODEL_PATH, "-f", "input.wav"],
        capture_output=True,
        text=True
    )
    return jsonify({"transcript": result.stdout.strip()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
