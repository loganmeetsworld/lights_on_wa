class WelcomeController < ApplicationController
  def index
    @candidates = Candidate.all.order(name: :desc)
  end
end
