FROM python:3.8.1-slim-buster

ARG POETRY_VERSION=1.0.2
ARG VENV_PATH=/opt/venv
ARG POETRY_PATH=/opt/poetry

ENV TZ Asia/Tokyo
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="$POETRY_PATH/bin:$VENV_PATH/bin:$PATH"

RUN apt update \
    && apt install -y --no-install-recommends curl \
    && curl -o /root/get-poetry.py -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py \
    && python /root/get-poetry.py -y --version ${POETRY_VERSION} \
    && rm -f /root/get-poetry.py \
    && mv /root/.poetry $POETRY_PATH \
    && python -m venv $VENV_PATH \
    && poetry config virtualenvs.create false \
    && apt remove -y --purge curl \
    && apt -y autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["poetry", "run"]
