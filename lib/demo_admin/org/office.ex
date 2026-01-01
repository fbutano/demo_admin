defmodule DemoAdmin.Org.Office do
  use Ash.Resource,
    otp_app: :demo_admin,
    domain: DemoAdmin.Org,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAdmin.Resource]

  admin do
    label_field :name
    relationship_select_max_items 10
  end

  postgres do
    table "offices"
    repo DemoAdmin.Repo
  end

  actions do
    defaults [:read, :destroy, :create, :update]
    default_accept [:name]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :membership_relationships, DemoAdmin.Accounts.Membership
    many_to_many :members, DemoAdmin.Accounts.User do
      join_relationship :membership_relationships
      destination_attribute_on_join_resource :user_id
    end
  end

end
