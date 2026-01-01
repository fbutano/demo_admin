defmodule DemoAdmin.Accounts do
  use Ash.Domain,
    otp_app: :demo_admin,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource DemoAdmin.Accounts.Token
    resource DemoAdmin.Accounts.User
  end
end
