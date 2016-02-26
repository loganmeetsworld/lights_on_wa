class UsersController < ApplicationController
  def show
    @candidates = current_user.candidates
  end
end
