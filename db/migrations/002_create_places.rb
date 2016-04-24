Sequel.migration do
  change do
    create_table(:places) do
      primary_key :id
      foreign_key :user_id, :users
      String :name, null: false, index: true
      String :query, null: false
      Float :latitude, null: false
      Float :longitude, null: false
      Integer :num_requests, null: false, default: 0
      DateTime :updated_at
      Time :created_at, null: false
    end
  end
end
