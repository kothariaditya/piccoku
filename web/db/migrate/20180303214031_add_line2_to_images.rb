class AddLine2ToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :line2, :text
  end
end
