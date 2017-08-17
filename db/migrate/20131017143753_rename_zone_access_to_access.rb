# frozen_string_literal: true

class RenameZoneAccessToAccess < ActiveRecord::Migration
  def change
    rename_table :zone_accesses, :accesses
  end
end
