class EmailList < ActiveRecord::Base
  attr_accessible :email

  validates :email, email_format: { message: "That doesn't look like an email address" }
  validates :email, uniqueness: true
end
