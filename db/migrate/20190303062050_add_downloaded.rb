class AddDownloaded < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :default_allowed_download, :boolean, default: true
    add_column :videos, :allowed_download, :boolean, default: true
  end
end
