FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências necessárias para Whisper.cpp e scipy
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    ffmpeg \
    curl \
    gfortran \
    cmake \
    pkg-config \
    libatlas-base-dev \
    liblapack-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# Baixar e compilar Whisper.cpp
RUN git clone https://github.com/ggerganov/whisper.cpp.git && \
    cd whisper.cpp && make && \
    bash ./models/download-ggml-model.sh medium

# Criar diretório da aplicação Flask
WORKDIR /app

# Copiar requirements.txt e instalar dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir numpy==1.26.4 scipy==1.11.4

# Copiar a API Flask
COPY api.py .

# Expor a porta da API
EXPOSE 5000

# Comando para rodar a API
CMD ["python", "api.py"]
