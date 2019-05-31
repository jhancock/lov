defmodule Kite.Address do
    alias __MODULE__
    @derive {Jason.Encoder, only: [:recipient_name, :address_line_1, :address_line_2, :city, :county_state, :postcode, :country_code]}
    defstruct   recipient_name: "",
                address_line_1: "",
                address_line_2: "",
                city: "",
                county_state: "",
                postcode: "",
                country_code: ""

    @type t() :: %Address{
        recipient_name: String.t(),
        address_line_1: String.t(),
        address_line_2: String.t(),
        city: String.t(),
        county_state: String.t(),
        postcode: String.t(),
        country_code: String.t()
        }

    def example() do
        %Address{
            recipient_name: "Jon Hancock",
            address_line_1: "157 Breaker Bay Rd",
            address_line_2: "Breaker Bay",
            city: "Wellington",
            county_state: "Wellington",
            postcode: "6022",
            country_code: "NZL"
        }
    end

    def example_mom() do
        %Address{
            recipient_name: "Kathleen Kaye",
            address_line_1: "P.O. Box 4062",
            city: "Dublin",
            postcode: "31040",
            country_code: "USA"
        }
    end

end