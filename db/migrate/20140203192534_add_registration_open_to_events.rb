# frozen_string_literal: true

class AddRegistrationOpenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_open, :boolean, default: true
  end
end
