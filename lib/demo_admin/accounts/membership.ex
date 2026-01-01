defmodule DemoAdmin.Accounts.Membership do
  use Ash.Resource,
    otp_app: :demo_admin,
    domain: DemoAdmin.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "memberships"
    repo DemoAdmin.Repo
    references do
      reference :user, on_delete: :delete, index?: true
      reference :office, on_delete: :delete
    end
  end

  actions do
    defaults [:read]
  end

  policies do
    policy access_type(:read) do
      authorize_if always()
    end
  end



  relationships do
    belongs_to :user, DemoAdmin.Accounts.User do
      primary_key? true
      allow_nil? false
    end

    belongs_to :office, DemoAdmin.Org.Office do
      primary_key? true
      allow_nil? false
    end
  end

end
