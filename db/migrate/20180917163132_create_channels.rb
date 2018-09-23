# frozen_string_literal: true

class CreateChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.string :title, null: false, unique: true
      t.text :description
      t.string :avatar
      t.string :youtube_id, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
