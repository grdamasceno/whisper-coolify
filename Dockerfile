FROM ubuntu:22.04

# Instalar dependências
RUN apt update && apt install -y \
    build-essential \
    git \
    ffmpeg \
    python3 \
    python3-pip \
    curl

# Instalar Whisper.cpp
RUN git clone https://github.com/ggerganov/whisper.cpp.git && \
    cd whisper.cpp && make && \
    bash ./models/download-ggml-model.sh medium

# Copiar API Flask
WORKDIR /app
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY api.py .

# Expor porta
EXPOSE 5000

CMD ["python3", "api.py"]
