# Import firebase_admin, firestore, credentials
import firebase_admin
from firebase_admin import credentials, firestore

# Use credentials to initialize firebase_admin
cred = credentials.Certificate("finalProject.json")

firebase_admin.initialize_app(cred)
db = firestore.client()

# Import Flask, request, json, jsonify
from flask import Flask, request, json, jsonify

# Initialize Flask app
flaskapp = Flask(__name__)

# Endpoints
    # Create user Profile
@flaskapp.route('/profile', methods=['POST'])
def register_user():
    # student ID number, name, email, date of birth, yeargroup, 
    # major, whether or not they have campus residence, 
    # their best food, and their best movie
    if not request.data:
        return jsonify({"error": "Request body is empty"}), 400
    record = json.loads(request.data)
    user_ref = db.collection("users").document(record["userId"])
    user = user_ref.get()
    if user.exists:
        return jsonify({"error": "User already exists"}), 400
    else:
        db.collection("users").document(record["userId"]).set(record)
        return jsonify({"success": "User successfully added!"}), 200

    # View user profile
@flaskapp.route('/profile/<userId>', methods=['GET'])
def view_user(userId):
    user_ref = db.collection("users").document(userId)
    user = user_ref.get()
    if user.exists:
        return jsonify(user.to_dict()), 200
    else:
        return jsonify({"error": "User does not exist"}), 400

    # Edit user profile
@flaskapp.route('/profile/<userId>', methods=['PATCH'])
def edit_user(userId):
    if not request.data:
        return jsonify({"error": "Request body is empty"}), 400
    record = json.loads(request.data)
    user_ref = db.collection("users").document(userId)
    user = user_ref.get()
    # If the user doesn't exist, return a 404 error
    if not user:
        return jsonify({"error": "User does not exist :("}), 404
    else:
        db.collection("users").document(userId).update(record)
        return jsonify({"success": "User successfully updated!"}), 200

# Post


# Feed

if __name__ == '__main__':
    flaskapp.run(debug=True)