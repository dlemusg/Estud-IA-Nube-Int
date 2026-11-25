# Mercado Raíces · API de pedidos
FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 PORT=8080
WORKDIR /app

# Primero las librerías: esta capa se reutiliza mientras requirements.txt no cambie
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

# Usuario sin privilegios
RUN useradd --create-home --uid 10001 mercado
USER mercado

EXPOSE 8080
# 0.0.0.0: escuchar en todas las interfaces del contenedor
CMD ["sh", "-c", "exec gunicorn --bind 0.0.0.0:${PORT} --workers 2 --access-logfile - app:app"]
