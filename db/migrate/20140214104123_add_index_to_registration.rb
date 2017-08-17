# frozen_string_literal: true

class AddIndexToRegistration < ActiveRecord::Migration
  def change
    add_index :registrations, :payment_code, unique: true
  end
end
