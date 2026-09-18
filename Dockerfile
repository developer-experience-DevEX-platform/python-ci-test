FROM python:3.13-slim-bookworm AS build

WORKDIR /app

# hadolint ignore=DL3013
RUN pip install --no-cache-dir --prefix=/install fastapi uvicorn

FROM python:3.13-slim-bookworm AS runtime

# hadolint ignore=DL3008,DL3005
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 app \
    && useradd --uid 1000 --gid app --create-home --shell /usr/sbin/nologin app

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --from=build /install /usr/local
COPY src ./src

# hadolint ignore=DL3013
RUN python -m pip uninstall -y setuptools msgpack || true \
    && python -m pip install --no-cache-dir "setuptools>=78.1.1" \
    && rm -rf /usr/local/lib/python*/ensurepip \
    && find /usr -iname 'msgpack*' -delete

USER 1000

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
