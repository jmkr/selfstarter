#This is going to be created entirely from the admin page
class Diy < ActiveRecord::Base
  attr_accessible :title, :body, :image

  validates :title, :image, presence: true

end
