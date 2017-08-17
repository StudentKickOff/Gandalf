# frozen_string_literal: true

class AddEventIdToRegistration < ActiveRecord::Migration
  def change
    add_reference :registrations, :event, index: true
  end
end
