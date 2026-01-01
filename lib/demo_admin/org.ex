defmodule DemoAdmin.Org do
  use Ash.Domain,
    otp_app: :demo_admin,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource DemoAdmin.Org.Office
  end
end
