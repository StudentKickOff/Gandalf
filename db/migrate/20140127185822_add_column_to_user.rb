# frozen_string_literal: true

class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
  end
end
