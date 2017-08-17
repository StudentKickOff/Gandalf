# frozen_string_literal: true

class AddPriceToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :price, :integer
  end
end
