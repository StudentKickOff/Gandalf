# frozen_string_literal: true

class AddColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_ticket_count, :boolean, default: true
  end
end
