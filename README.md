# Lov
Copyright © 2019 - Liu Yu, Jon Hancock, doing business as Lov.is or their assigns.  All Rights Reserved.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`  ||
 cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development
  * Start Phoenix endpoint with `mix phx.server`
  * You can also run your app inside IEx (Interactive Elixir) as:
    $ iex -S mix phx.server

  * for prod https://hexdocs.pm/phoenix/deployment.html
    # Initial setup
      $ mix deps.get --only prod
      $ MIX_ENV=prod mix compile

      # Compile assets
      $ npm run deploy --prefix ./assets
      $ mix phx.digest

      # Custom tasks (like DB migrations)
      $ MIX_ENV=prod mix ecto.migrate

      # Finally run the server
      $ PORT=4001 MIX_ENV=prod mix phx.server

      # need to learn to run in prod with detached interactive shell

      # optimize asset deploy, study https://webpack.js.org/guides/code-splitting/

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
