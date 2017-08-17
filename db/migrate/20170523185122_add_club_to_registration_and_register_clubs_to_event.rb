# frozen_string_literal: true

class AddClubToRegistrationAndRegisterClubsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :can_add_club, :boolean
    add_reference :registrations, :club
  end
end
