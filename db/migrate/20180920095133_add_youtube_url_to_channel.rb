# frozen_string_literal: true

class AddYoutubeUrlToChannel < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :youtube_url, :string, null: false, unique: true
  end
end
