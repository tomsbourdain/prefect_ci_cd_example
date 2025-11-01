FROM python:3.11-slim AS builder

WORKDIR /app

# System deps (add any native libs your packages need)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc && \
    rm -rf /var/lib/apt/lists/*~

# Install dependencies into /opt/venv for a lean runtime
ENV VENV_PATH=/opt/venv
RUN python -m venv $VENV_PATH
ENV PATH="$VENV_PATH/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# Stage 2: runtime
FROM python:3.11-slim

WORKDIR /app

# Copy venv from builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Add non-code files if needed, then copy code
COPY flows ./flows

# Small runtime user and safety
RUN useradd --create-home appuser
USER appuser

# Default command (used for local testing / container runs)
CMD ["python", "flows/hello_flow.py"]