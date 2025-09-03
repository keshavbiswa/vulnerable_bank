class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_user_from_token

  private

  def set_user_from_token
    token = request.headers["Authorization"]&.gsub("Bearer ", "")

    if token.present?
      begin
        user_id = token.to_i
        @current_user = User.find(user_id) if user_id > 0
      rescue
        @current_user = nil
      end
    end
  end
end
