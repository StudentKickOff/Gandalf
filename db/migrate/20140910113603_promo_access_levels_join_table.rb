# frozen_string_literal: true

class PromoAccessLevelsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :promos, :access_levels
  end
end
