class AddLine3ToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :line3, :text
  end
end
