import os

from flask import Flask, jsonify

app = Flask(__name__)

APP_NAME = "secure-kubernetes-cicd"
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def home():
    return jsonify(
        {
            "application": APP_NAME,
            "version": APP_VERSION,
            "message": "Application is running",
        }
    )


@app.get("/health")
def health():
    return jsonify(
        {
            "status": "healthy",
            "application": APP_NAME,
            "version": APP_VERSION,
        }
    )


@app.get("/version")
def version():
    return jsonify(
        {
            "application": APP_NAME,
            "version": APP_VERSION,
        }
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)