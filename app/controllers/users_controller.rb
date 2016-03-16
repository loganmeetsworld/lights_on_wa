class UsersController < ApplicationController
  def show
    @candidates = current_user.candidates
    set_last_seen_at
  end
end
