# 1. Use the official lightweight Python image.
FROM python:3.11-slim

# 2. Set environment variables using the 'key=value' format.
# PYTHONUNBUFFERED ensures logs are delivered to Cloud Run in real-time.
ENV PYTHONUNBUFFERED=True
ENV APP_HOME=/app

# 3. Set the working directory and copy local code into the container.
WORKDIR $APP_HOME
COPY . ./

# 4. Install production dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# 5. THE START COMMAND:
# We use the JSON array format ["sh", "-c", "..."] for two critical reasons:
#
#   A) VARIABLE EXPANSION: By invoking 'sh', we create a shell environment that 
#      can "read" the $PORT variable provided by Cloud Run. Without 'sh', 
#      Gunicorn would literally try to bind to the text ":$PORT" and crash.
#
#   B) SIGNAL HANDLING (exec): We use 'exec' inside the shell string so that 
#      Gunicorn replaces the shell process. This makes Gunicorn 'PID 1'.
#      When Cloud Run sends a SIGTERM to shut down, Gunicorn receives it directly
#      and can finish active requests (Graceful Shutdown) rather than being 
#      abruptly "hard killed."
#
CMD ["sh", "-c", "exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app"]