defmodule DemoAdmin.Accounts.User do
  use Ash.Resource,
    otp_app: :demo_admin,
    domain: DemoAdmin.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication, AshAdmin.Resource]

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end
    end

    tokens do
      enabled? true
      token_resource DemoAdmin.Accounts.Token
      signing_secret DemoAdmin.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end
  end

  postgres do
    table "users"
    repo DemoAdmin.Repo
  end

  actions do
    defaults [:read, :destroy]
    defaults [:read, :destroy]

    create :create do
      accept [:pin, :name]
      argument :enabled_offices, {:array, :map}, allow_nil?: true, default: []
      change manage_relationship(:enabled_offices, type: :append_and_remove)
    end

    update :update do
      accept [:pin, :name]
      require_atomic? false
      argument :enabled_offices, {:array, :map}, allow_nil?: true, default: []
      change manage_relationship(:enabled_offices, type: :append_and_remove)
    end

    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :pin, :string do
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? false
    end
  end

  relationships do
    has_many :membership_relationships, DemoAdmin.Accounts.Membership
    many_to_many :enabled_offices, DemoAdmin.Org.Office do
      join_relationship :membership_relationships
      destination_attribute_on_join_resource :office_id
    end
  end
end
