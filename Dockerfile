FROM python:3.13-slim-bookworm AS build

COPY --from=ghcr.io/astral-sh/uv:0.12.4 /uv /bin/uv

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=0

COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

FROM python:3.13-slim-bookworm AS runtime

# hadolint ignore=DL3008,DL3005
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 1000 app \
    && useradd --uid 1000 --gid app --create-home --shell /usr/sbin/nologin app

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

COPY --from=build /app/.venv /app/.venv
COPY src ./src

# pip/ensurepip ship unfixed setuptools and msgpack that Trivy flags.
# The runtime image does not need pip.
RUN rm -rf \
      /usr/local/lib/python*/ensurepip \
      /usr/local/lib/python*/site-packages/pip \
      /usr/local/lib/python*/site-packages/pip-*.dist-info \
      /usr/local/bin/pip \
      /usr/local/bin/pip3 \
      /usr/local/bin/pip3.* \
      /usr/local/lib/python*/site-packages/setuptools \
      /usr/local/lib/python*/site-packages/setuptools-*.dist-info \
      /usr/local/lib/python*/site-packages/pkg_resources

USER 1000

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
