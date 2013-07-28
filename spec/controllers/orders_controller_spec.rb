require 'spec_helper'

describe OrdersController do
  [:index, :checkout].each do |method|
    it "should get #{method}" do
      get method
      response.should be_success
    end
  end
end