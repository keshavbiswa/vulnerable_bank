class AvatarsController < ApplicationController
  before_action :require_login

  def create
    url = params[:avatar_url]

    begin
      downloaded = Net::HTTP.get(URI(url))

      avatar_path = Rails.root.join("public/uploads/avatars/#{current_user.id}_avatar.png")
      FileUtils.mkdir_p(File.dirname(avatar_path))

      File.open(avatar_path, "wb") do |f|
        f.write(downloaded)
      end

      render plain: "Avatar uploaded successfully!"
    rescue => e
      render plain: "Upload failed: #{e.message}", status: 400
    end
  end
end
