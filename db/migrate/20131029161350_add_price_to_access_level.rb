# frozen_string_literal: true

class AddPriceToAccessLevel < ActiveRecord::Migration
  def change
    add_column :access_levels, :price, :integer
  end
end
