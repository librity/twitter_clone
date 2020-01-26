# frozen_string_literal: true

# Gloabal helper methods for the Application.
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    return base_title if page_title.empty?

    page_title + ' | ' + base_title
  end

  def pluralize_without_count(count, noun, text = nil)
    return if count.negative?

    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
  end
end
