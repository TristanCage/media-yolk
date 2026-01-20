# Start from the official Parkervcp Python 3.12 yolk
FROM ghcr.io/parkervcp/yolks:python_3.12

USER root

# Base tools 
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl unzip ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install the latest Deno
ENV DENO_INSTALL=/usr/local/deno
RUN curl -fsSL https://deno.land/install.sh | sh
ENV PATH="/usr/local/deno/bin:${PATH}"


# Put browsers in a shared location readable by "container" user
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel && \
    python -m pip install --no-cache-dir playwright && \
    python -m playwright install --with-deps chromium && \
    mkdir -p /ms-playwright && \
    chown -R container:container /ms-playwright

# Sanity checks
RUN python --version && deno --version && ffmpeg -version | head -n 1 && \
    python -c "import playwright; print('playwright ok')"

# Back to the default container user expected by Pterodactyl
USER container
WORKDIR /home/container