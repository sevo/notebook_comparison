# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_WA_session',
  :secret      => '9d787930aa6aeb57ecc8e280215c3362d4eb048427d2658714379729e4be31f3cddcf2c04afc3758ec6df25c36f19c06d2d915f4edb16f9924901e379e4c8dd4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
