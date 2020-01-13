# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  def hello
    render html: 'Hello WORLD!'
  end
end
