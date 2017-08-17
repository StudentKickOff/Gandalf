# frozen_string_literal: true

class AddBarcodeDataToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :barcode_data, :string
  end
end
