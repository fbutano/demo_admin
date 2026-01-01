defmodule DemoAdmin.Accounts.User do
  use Ash.Resource,
    otp_app: :demo_admin,
    domain: DemoAdmin.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication]

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
    defaults [:read, :update, :create, :destroy]
    default_accept [:pin, :name]

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
end
