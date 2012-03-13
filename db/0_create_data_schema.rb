require 'active_record'

class CreateDataSchema < ActiveRecord::Migration
  def up
    create_table :logged_files do |t|
      t.string :uuid
      t.string :ip_address
      t.string :file_name
      t.timestamps
    end
  end

  def down
    drop_table :logged_files
  end
end
