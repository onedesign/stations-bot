Sequel.migration do
  transaction

  up do
    create_table(:teams) do
      primary_key :id
      String :team_id, null: false, index: true
      String :team_name
      String :access_token
      DateTime :updated_at
      Time :created_at, null: false
    end

    drop_column :users, :team_id
    drop_column :users, :team_domain
    add_column :users, :team_id, Integer, index: true
  end

  down do
    drop_table :teams
    add_column :users, :team_id, String
    add_column :users, :team_domain, String
  end
end
