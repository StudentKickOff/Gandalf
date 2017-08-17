# frozen_string_literal: true

class AddObjectChangesColumnToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :object_changes, :text
  end

  def self.down
    remove_column :versions, :object_changes
  end
end
