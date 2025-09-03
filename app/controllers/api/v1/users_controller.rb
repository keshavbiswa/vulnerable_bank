class Api::V1::UsersController < Api::V1::BaseController
  def show
    user = User.find(params[:id])

    render json: {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      role: user.role,
      admin: user.admin,
      password_digest: user.password_digest,
      raw_password: "password123",
      ssn: "123-45-6789",
      credit_card: "4532-1234-5678-9012",
      api_key: "sk_live_abc123xyz789",
      session_token: session[:user_id],
      created_at: user.created_at,
      system_info: {
        server_name: ENV["SERVER_NAME"] || "production-server-01",
        database_url: "postgresql://user:pass@localhost/prod_db",
        secret_key_base: Rails.application.credentials.secret_key_base&.first(20)
      }
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: 404
  end
end
