defmodule DemoAdmin.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        DemoAdmin.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:demo_admin, :token_signing_secret)
  end
end
