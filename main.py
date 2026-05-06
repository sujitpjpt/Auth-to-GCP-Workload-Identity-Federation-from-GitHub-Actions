import os
import logging
from flask import Flask, jsonify

# Initialize the Flask application
app = Flask(__name__)

# Configure logging so errors appear clearly in the Google Cloud Console
logging.basicConfig(level=logging.INFO)

# Define the "Route" for the homepage. 
# When a user visits the base URL ('/'), this function runs.
@app.route('/')
def hello_world():
    # Returns a simple string to the user's browser
    return "Hello, Cloud Run!"

# This block ensures the server only runs if the script is executed directly
if __name__ == "__main__":
    # 1. Look for the 'PORT' environment variable injected by Cloud Run.
    # 2. Default to 8080 if running locally (where 'PORT' isn't set).
    # 3. Convert the result to an integer (Flask requirement).
    port = int(os.environ.get("PORT", 8080))

    # Start the Flask development server.
    # - host='0.0.0.0': Makes the server accessible on the local network/container.
    # - port=port: Uses the port we identified above.
    # - debug=False: Always disable debug mode in a production environment.
    app.run(debug=False, host='0.0.0.0', port=port)