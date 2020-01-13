# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'invalid login' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {
      email: 'not@right.com', password: '123456'
    } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select 'div.alert-danger'
    get root_path
    assert flash.empty?
  end
end
