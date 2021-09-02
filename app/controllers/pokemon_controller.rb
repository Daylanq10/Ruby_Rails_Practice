class PokemonController < ApplicationController
  def index
  end

  def search
    @info = find_pokemon(params[:name])
    unless @info
      flash[:alert] = 'Pokemon not found'
      return render action: :index
    end
    @name = :name
    @description = @info["flavor_text_entries"][0]["flavor_text"]
    @pokedex_numbers = @info["pokedex_numbers"]
    @entry_number = @pokedex_numbers[0]["entry_number"]

    @details = find_information(@entry_number)
    @types = @details["types"]
    @types_list = type_check()
  end

  def type_check
    if @types.length == 1
      @types[0]["type"]["name"]
    else
      @types[0]["type"]["name"] + " + " + @types[1]["type"]["name"]
    end
  end

  private
  def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-PokeAPI-Host' => URI.parse(url).host,
      }
    )
    return nil if response.status != 200
    JSON.parse(response.body)
  end

  def find_pokemon(name)
    @pokemon_name = name
    request_api(
      "https://pokeapi.co/api/v2/pokemon-species/#{CGI.escape(name)}"
    )
  end

  def find_information(number)
    request_api(
      "https://pokeapi.co/api/v2/pokemon/#{CGI.escape(number.to_s)}"
    )
  end
end
