# frozen_string_literal: true

class AddCommentBooleanToAccessLevel < ActiveRecord::Migration
  def change
    add_column :access_levels, :has_comment, :boolean
  end
end
