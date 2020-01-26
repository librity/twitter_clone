# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', test: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test 'stats with pluralization' do
    get user_path(@user)
    assert_select 'div.stats', count: 1
    followers = @user.followers.count
    following = @user.following.count
    assert_select 'strong', followers.to_s
    assert_select 'strong', following.to_s
    assert_select 'a', test: 'followers'
    assert_select 'a', test: 'following'
    get user_path(users(:malory))
    assert_select 'a', test: 'follower'
  end
end
