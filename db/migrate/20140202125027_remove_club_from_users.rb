# frozen_string_literal: true

class RemoveClubFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :club
  end
end
