from flask import Flask, request, jsonify
import redis
import os

app = Flask(__name__)

# Redis connection settings (from env vars)
redis_host = os.getenv("REDIS_HOST", "localhost")
redis_port = int(os.getenv("REDIS_PORT", 6379))
redis_client = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)

# Health check endpoint
@app.route("/healthz", methods=["GET"])
def healthz():
    try:
        redis_client.ping()
        return jsonify({"status": "ok"}), 200
    except redis.exceptions.ConnectionError:
        return jsonify({"status": "unhealthy"}), 500

# Homepage counter
@app.route("/", methods=["GET"])
def index():
    count = redis_client.incr("hits")
    return f"Hello from Flask + Redis on Kubernetes! Visits: {count}\n"

# Set a key/value
@app.route("/set", methods=["POST"])
def set_value():
    data = request.json
    if not data or "key" not in data or "value" not in data:
        return jsonify({"error": "Missing key or value"}), 400
    redis_client.set(data["key"], data["value"])
    return jsonify({"message": "Value stored"}), 201

# Get a key/value
@app.route("/get/<key>", methods=["GET"])
def get_value(key):
    value = redis_client.get(key)
    if value is None:
        return jsonify({"error": "Key not found"}), 404
    return jsonify({"key": key, "value": value}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
