class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.timestamp :email_verified_at, default: nil
      t.string :password_digest
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
