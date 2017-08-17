# frozen_string_literal: true

class AddCheckinColumnToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :checked_in_at, :datetime, default: nil
  end
end
