Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :user_id, null: false, unique: true
      String :team_id
      String :team_domain
      String :user_name
      Integer :num_requests, null: false, default: 0
      DateTime :updated_at
      Time :created_at, null: false
    end
  end
end
