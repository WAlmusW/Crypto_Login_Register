from flask import Flask, request, jsonify
import auth
import logging
import crypto_utils  # Import the crypto_utils module

app = Flask(__name__)

# Generate RSA key pair (run this once and then comment it out)
crypto_utils.generate_rsa_key_pair()

@app.route('/check_registration', methods=['POST'])
def check_registration():
    try:
        data = request.form
        device_udid = data.get('device_udid')
        print("device_udid: ", device_udid)

        # Retrieve registration status from Firestore based on the device ID
        is_registered = auth.FirestoreClient.check_registration_status(device_udid)

        # Generate server's public key
        server_public_key = crypto_utils.get_public_key('server_public_key.pem')

        return jsonify({'is_registered': is_registered, 'server_public_key': server_public_key})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.form
        username = data.get('username')
        password = data.get('password')

        # Check login status from Firestore based on the provided username and password
        is_logged_in = auth.FirestoreClient.check_login_status(username, password)

        # Generate server's public key
        server_public_key = crypto_utils.get_public_key('server_public_key.pem')

        return jsonify({'is_logged_in': is_logged_in, 'server_public_key': server_public_key})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


@app.route('/register', methods=['POST'])
def register():
    try:
        data = request.form
        username = data.get('username')
        password = data.get('password')
        device_udid = data.get('device_udid')

        # Register the user in Firestore based on the provided username and password
        auth.FirestoreClient.register_user(username, password, device_udid)

        # Generate server's public key
        server_public_key = crypto_utils.get_public_key('server_public_key.pem')

        return jsonify({'message': 'User registered successfully', 'server_public_key': server_public_key})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500
    
    
@app.route("/exchange_key", methods=['POST'])
def exchange_key():
    try:
        data = request.form
        session_key = data.get('session_key')
        
        crypto_utils.store_key(session_key)
        
        return jsonify({'message': 'Exchange session key completed'})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # You can choose a different port if needed
