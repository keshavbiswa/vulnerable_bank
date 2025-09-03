Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src "*"

    policy.script_src "'unsafe-inline'", "'unsafe-eval'", "*"
    policy.style_src "'unsafe-inline'", "*"
    policy.img_src "*", "data:", "blob:"
    policy.font_src "*", "data:"

    policy.object_src "*"

    policy.connect_src "*"
  end

  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
