FROM node:20-bookworm-slim

ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PORT=3030
ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /workspace

RUN apt-get update \
  && apt-get install -y --no-install-recommends python3 python3-venv python3-pip git ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

ARG DATALEX_REPO=https://github.com/duckcode-ai/DataLex.git
ARG DATALEX_REF=main

COPY requirements.txt ./
RUN python3 -m venv /opt/venv \
  && pip install --upgrade pip \
  && pip install -r requirements.txt \
  && git clone --depth 1 --branch "${DATALEX_REF}" "${DATALEX_REPO}" /opt/DataLex \
  && pip install -e "/opt/DataLex[duckdb]" \
  && npm --prefix /opt/DataLex/packages/api-server install --silent \
  && npm --prefix /opt/DataLex/packages/web-app install --silent \
  && npm --prefix /opt/DataLex/packages/web-app run build --silent

COPY . .

EXPOSE 3030

CMD ["sh", "-c", "rm -rf target && dbt seed --profiles-dir . && dbt build --profiles-dir . && datalex serve --project-dir /workspace --no-browser --port ${PORT:-3030}"]
