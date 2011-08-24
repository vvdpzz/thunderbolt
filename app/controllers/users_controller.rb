class UsersController < ApplicationController
  set_tab :profile
  
  def show
    @user = User.find params[:id]
  end
end
