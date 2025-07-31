from fastapi import FastAPI, UploadFile, File
import subprocess
import os
import uuid

app = FastAPI()

@app.post("/transcribe")
async def transcribe(audio: UploadFile = File(...)):
    temp_filename = f"/tmp/{uuid.uuid4()}.wav"
    with open(temp_filename, "wb") as f:
        f.write(await audio.read())

    result_file = f"{temp_filename}.txt"
    command = f"./main -m models/ggml-base.en.bin -f {temp_filename} -otxt -of {temp_filename}"
    subprocess.run(command, shell=True)

    transcription = ""
    try:
        with open(result_file, "r") as r:
            transcription = r.read()
    except Exception as e:
        return {"error": str(e)}

    os.remove(temp_filename)
    os.remove(result_file)
    return {"text": transcription}