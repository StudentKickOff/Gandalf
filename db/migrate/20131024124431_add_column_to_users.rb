# frozen_string_literal: true

class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :club, :string
  end
end
