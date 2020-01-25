# frozen_string_literal: true

require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @incative_user = users(:inactive)
  end

  test 'showing an incative user should redirect to the root url' do
    get user_path(@incative_user)
    assert_redirected_to root_url
  end
end
