class AddLine1ToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :line1, :text
  end
end
