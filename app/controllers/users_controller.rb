class UsersController < ApplicationController
  before_filter :user_signed_in?, only: [:settings, :orders]

  def settings
  end

end
