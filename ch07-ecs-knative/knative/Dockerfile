# Use the official Python image from the Docker Hub
FROM python:3.9.19-alpine3.20

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Change working directory
ENV PYTHONUNBUFFERED=True
ENV APP_HOME=/app
WORKDIR $APP_HOME

#Copy requirements file, and install them
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copy the application code
COPY . .

# Expose the application's port
EXPOSE 5000

# Run the flask app
ENTRYPOINT ["flask", "run"]