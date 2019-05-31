defmodule Kite.ApiKeys do
    alias __MODULE__
    defstruct   public: "",
                secret: ""

    @type t() :: %ApiKeys{
        public: String.t(),
        secret: String.t()
    }

    def get(api_mode) do
        case api_mode do
            :test -> %ApiKeys{public: Application.fetch_env!(:lov, :kite_test_public_key), secret: Application.fetch_env!(:lov, :kite_test_secret_key)}
            :live -> %ApiKeys{public: Application.fetch_env!(:lov, :kite_live_public_key), secret: Application.fetch_env!(:lov, :kite_live_secret_key)}
            _     -> {:error, "need to choose :test or :live"}
        end        
    end
end