class SearchController < ApplicationController
  def index
    if params[:query].present?
      query = params[:query]
      @users = User.where("first_name LIKE '%#{query}%' OR last_name LIKE '%#{query}%' OR email LIKE '%#{query}%'")
      @accounts = Account.where("account_number LIKE '%#{query}%' OR account_type LIKE '%#{query}%'")
    else
      @users = []
      @accounts = []
    end
  end
end
