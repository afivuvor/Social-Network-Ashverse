### 

# Required imports
import os
import functions_framework
from flask import Flask, request, json, jsonify
from flask_cors import CORS, cross_origin
from firebase_admin import credentials, firestore, initialize_app
from json import JSONDecodeError
from google.cloud.exceptions import NotFound as NotFoundError
import datetime

# Initialize Flask app
flaskapp = Flask(__name__)
CORS(flaskapp)

# Use credentials to initialize firebase_admin
cred = credentials.Certificate("finalProject.json")
default_app = initialize_app(cred)
db = firestore.client()

# Enable CORS
# @flaskapp.after_request
# def after_request(response):
#     response.headers.add('Access-Control-Allow-Origin', '*')
#     response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
#     response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
#     return response


# Define the entry point for the cloud function
@cross_origin()
@functions_framework.http
def run_app(request):
      # Check the request method
    if request.method == 'POST' and 'userId' in request.get_json() and 'conf_password' in request.get_json():
      # Call the register_user function
      return register_user()
    elif request.method == 'GET' and 'userId' in request.args:
          # Call the view_user function
      return view_user()
    elif request.method == 'POST' and 'conf_password' not in request.args:
          # Call the sign in function
      return sign_in()
    elif request.method == 'GET' and 'email' in request.args and 'userId' not in request.args:
        # Call the view_userspost function
        return view_otheruser()
    elif request.method == 'PATCH' and 'userId' in request.args:
      # Call the edit_user function
      return edit_user()
    elif request.method == 'PATCH' and 'postBody' in request.get_json():
        # Call the create_post function
        return create_post()
    elif request.method == 'GET' and 'username' in request.args:
        # Call the view_userspost function
        return view_userposts()
    elif request.method == 'GET':
        # Call the view_post function
        return view_post()
    else:   
        return({'error': 'Invalid request'})
    
    # Endpoints
# Create user Profile
# @flaskapp.route('/profile', methods=['POST'])
def register_user():
    try:
        data = request.get_json()

        # Check if the request body is empty
        if not request.data:
            return jsonify({"error": "Request body is empty"}), 400
        
        # Get the request data
        record = json.loads(request.data)

        # Get user with the specified id
        user_ref = db.collection("users").document(record["userId"])
        user = user_ref.get()

            # If the user already exists, return a 400 error
        if user.exists:
            return jsonify({"error": "User already exists"}), 400
        else:
            # Add the user to the database
            db.collection("users").document(record["userId"]).set(record)
            db.collection("users").document(record["userId"]).update({"posts": []})
            return jsonify({"success": "User successfully added!"}), 201
    except Exception as e:
        return f"An Error Occurred: {e}"

# View user profile
# @flaskapp.route('/profile/<userId>', methods=['GET'])
def view_user():
    userId=request.args.get('userId')
    try:
        user_ref = db.collection("users").document(userId)
        user = user_ref.get()
        if user.exists:
            return jsonify(user.to_dict()), 200
        else:
            return jsonify({"error": "User does not exist"}), 400
    except Exception as e:
        return f"An Error Occurred: {e}"

def view_otheruser():
    email=request.args.get('email')
    try:
        query = db.collection('users').where('email', '==', email).limit(1)
        results = query.stream()
        results = list(results)

        # Check if a user with the specified email was found
        if len(results) == 0:
            return jsonify({'error': 'User does not exist'}), 404

            # Extract the user data from the first (and only) result
        for result in results:
            user_data = result.to_dict()

            # Return the user data as a JSON response
        return jsonify(user_data), 200
        # else:
        #     return jsonify({"error": "User does not exist"}), 400
    except Exception as e:
        return f"An Error Occurred: {e}"

# View user posts
def view_userposts():
    username=request.args.get('username')
    try:
        user_ref = db.collection("users").where('username', '==', username).limit(1)
        # query = db.collection('users').where('email', '==', email).limit(1)
        user = user_ref.stream()
        results = list(user)

        # Check if a user with the specified email was found
        if len(results) == 0:
            return jsonify({'error': 'User does not exist'}), 404

            # Extract the user data from the first (and only) result
        for result in results:
            user_data = result.to_dict()
            posts = user_data["posts"]
            postsArray = []
            for post in posts:
                post_ref = db.collection("feedposts").document(post)
                post = post_ref.get().to_dict()
                postsArray.append(post)
            return jsonify(postsArray), 200
    except Exception as e:
        return f"An Error Occurred: {e}", 400

# Sign in user
def sign_in():
    try:
        # Check if the request body is empty
        if not request.data:
            return jsonify({"error": "Request body is empty"}), 500
        
        # Get the request data
        record = json.loads(request.data)

        # Get user with the specified id
        user_ref = db.collection("users").document(record["userId"])
        user = user_ref.get()

        # Get the user data
        user_data = user.to_dict()
        email = user_data["email"]
        userId = user_data["userId"]

        # If the user doesn't exist, return a 404 error
        if not user.exists:
            return jsonify({"error": "User does not exist"}), 404
        else:
            # Check if the password is correct
            if user.to_dict()["password"] != record["password"]:
                return jsonify({"error": "Incorrect password"}), 403
            else:
                # return jsonify({"success": "User successfully signed in!", "email":email, "userId":userId}), 200
                return jsonify({"success": "User successfully signed in!", "email":email, "userId":userId}), 200
    except JSONDecodeError:
        return jsonify({"error": "Invalid request body"}), 400

    except NotFoundError:
        return jsonify({"error": "User does not exist"}), 404

    except KeyError:
        return jsonify({"error": "Missing required field in request body"}), 400

    except Exception as e:
        return f"An Error Occurred: {e}", 500

# Edit user profile
# @flaskapp.route('/profile/<userId>', methods=['PATCH'])
def edit_user():
    # Get the user id from the request
    userId=request.args.get('userId')

    try:
        # Check if the request body is empty
        if not request.data:
            return jsonify({"error": "Request body is empty"}), 400
        
        # Get the request data
        record = json.loads(request.data)

        # Get the user
        user_ref = db.collection("users").document(userId)
        user = user_ref.get()

        # If the user doesn't exist, return a 404 error
        if not user:
            return jsonify({"error": "User does not exist :("}), 404
        else:
            db.collection("users").document(userId).update(record)
            return jsonify({"success": "User successfully updated!"}), 200
    except Exception as e:
        return f"An Error Occurred: {e}"

# Post
    # Endpoints
# Create post
def create_post():
    try:
        record = json.loads(request.data)

        # Get user id
        postersId = record["postersId"] 

        # Get post data
        postBody = record["postBody"]

        # Get user
        user = db.collection("users").document(postersId)
        user_ref = user.get().to_dict()

        # Get user email
        email = user_ref["email"]

        # Get user's posts
        userPosts = user_ref['posts']

        time = datetime.datetime.now()
        timeStamp = time.strftime('%d-%m-%Y %H:%M:%S')

        userPosts.append(timeStamp)
        # update user posts array
        user.update({'posts': userPosts})

        # create and add post objects to posts collection
        postObject = {
            "email": email,
            "postBody": postBody,
            "postTime": timeStamp,
            "likes": 0
        }

        # create and add posts to postsfeed collection
        db.collection("feedposts").document(timeStamp).set(postObject)

        # return success message
        return jsonify({"success": "Post successfully made!"}), 201
    except Exception as e:
        return f"An Error Occurred: {e}"

# View posts
def view_post():
    try:
        # Get all posts
        posts = db.collection("feedposts").get()

        # Create an array of posts
        postsArray = []

        # Add each post to the array
        for post in posts:
            postsArray.append(post.to_dict())

        # Return the array of posts
        return jsonify(postsArray), 200
    except Exception as e:
        return f"An Error Occurred: {e}"


# Run Flask app
# port = int(os.environ.get('PORT', 8080))
# if __name__ == '__main__':
#     flaskapp.run(threaded=True, host='0.0.0.0', port=port)

