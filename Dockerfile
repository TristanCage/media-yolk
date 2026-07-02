FROM ghcr.io/parkervcp/yolks:python_3.12

USER root

# =========================
# BASE SYSTEM DEPENDENCIES
# =========================
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      unzip \
      ffmpeg \
      git \
      jq \
      gnupg \
      software-properties-common \
    && rm -rf /var/lib/apt/lists/*


# =========================
# NODE.JS (better yt-dlp JS runtime)
# =========================
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Optional sanity check
RUN node -v && npm -v


# =========================
# DENO (optional fallback)
# =========================
ENV DENO_INSTALL=/usr/local/deno
RUN curl -fsSL https://deno.land/install.sh | sh
ENV PATH="/usr/local/deno/bin:${PATH}"

RUN deno --version


# =========================
# PLAYWRIGHT + CHROMIUM
# =========================
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN python -m pip install --no-cache-dir --upgrade \
      pip setuptools wheel && \
    python -m pip install --no-cache-dir \
      playwright \
      curl_cffi

# Install Chromium + required Linux deps
RUN python -m playwright install --with-deps chromium

# Shared browser cache
RUN mkdir -p /ms-playwright && \
    chown -R container:container /ms-playwright


# =========================
# OPTIONAL EXTRA TOOLS
# =========================

# Useful for yt-dlp extraction edge cases
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      aria2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tesseract-ocr \
        tesseract-ocr-eng \
    && rm -rf /var/lib/apt/lists/*

# =========================
# SANITY CHECKS
# =========================
RUN python --version && \
    ffmpeg -version | head -n 1 && \
    node -v && \
    deno --version && \
    python -c "import playwright; print('playwright ok')"


# =========================
# FINAL SETUP
# =========================
USER container
WORKDIR /home/container
