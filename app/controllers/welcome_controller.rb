# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    event = Event.find_by_id(5)
    redirect_to event_path(event) unless event.nil?
  end
end
