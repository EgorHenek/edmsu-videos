# frozen_string_literal: true

class AddSlugColumnToChannel < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :slug, :string, null: false
  end
end
