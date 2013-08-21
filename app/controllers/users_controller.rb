class UsersController < ApplicationController
  before_filter :user_signed_in?, only: [:settings]

  def settings
  end

end
