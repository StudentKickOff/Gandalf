# frozen_string_literal: true

class AddCapacityToAccessLevel < ActiveRecord::Migration
  def change
    add_column :access_levels, :capacity, :integer
  end
end
