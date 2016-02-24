class UsersController < ApplicationController
  def show
    @candidates = User.find(params[:id]).candidates
  end
end
