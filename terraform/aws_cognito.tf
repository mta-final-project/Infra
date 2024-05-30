resource "aws_cognito_user_pool" "user_pool" {
  name = "ac-user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers = true
  }

  mfa_configuration = "OFF"

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
    email_subject = "AcademEase Account Confirmation"
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "given_name"
    required                 = true
    string_attribute_constraints {
      min_length = 1
      max_length = 20
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "family_name"
    required                 = true
    string_attribute_constraints {
      min_length = 1
      max_length = 20
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "ac-cognito-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
  
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "ac-auth"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}
