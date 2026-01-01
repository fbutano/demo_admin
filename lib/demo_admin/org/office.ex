defmodule DemoAdmin.Org.Office do
  use Ash.Resource, otp_app: :demo_admin, domain: DemoAdmin.Org, data_layer: AshPostgres.DataLayer,
  extensions: [AshAdmin.Resource]

  postgres do
    table "offices"
    repo DemoAdmin.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end


  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name]
  end

  admin do
    label_field :name
    relationship_select_max_items 10
  end
end
