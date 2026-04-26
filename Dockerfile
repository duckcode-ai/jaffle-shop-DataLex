FROM node:20-bookworm-slim

ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PORT=3030
ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /workspace

RUN apt-get update \
  && apt-get install -y --no-install-recommends python3 python3-venv python3-pip ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

ARG DATALEX_VERSION=1.3.5

COPY requirements.txt ./
RUN python3 -m venv /opt/venv \
  && pip install --upgrade pip \
  && pip install -r requirements.txt \
  && pip install "datalex-cli[duckdb]==${DATALEX_VERSION}"

COPY . .

EXPOSE 3030

CMD ["sh", "-c", "rm -rf target && dbt seed --profiles-dir . && dbt build --profiles-dir . && datalex serve --project-dir /workspace --no-browser --port ${PORT:-3030}"]
