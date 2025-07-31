FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    git build-essential cmake curl python3 python3-pip ffmpeg wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Baixar whisper.cpp e compilar
RUN git clone https://github.com/ggerganov/whisper.cpp.git && \
    cd whisper.cpp && make

# Copiar a aplicação
COPY app /app

# Instalar dependências
RUN pip3 install -r requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]