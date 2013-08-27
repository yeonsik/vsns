# If you want to use your local file system as storage in production mode well, please comment out the following CarrierWave.configure
CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV['S3_BUCKET_NAME']
  config.aws_acl    = :public_read
  config.asset_host = 'http://rorlab.s3-website-ap-northeast-1.amazonaws.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
end if Rails.env == 'production'
# ===================================================



# Allow non-ascii letters in uploaded filenames
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\s\.\-\+]/