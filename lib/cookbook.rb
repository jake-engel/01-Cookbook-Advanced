require 'csv'
require_relative 'recipe'

class Cookbook
  CSV_OPTIONS = { col_sep: ',', force_quotes: false, quote_char: '"' }
  def initialize(csv_file_path)
    @cookbook = []
    CSV.foreach(csv_file_path) do |recipe|
      @cookbook << Recipe.new(recipe[0], recipe[1], recipe[2])
    end
    @csv_path = csv_file_path
  end

  def add_recipe(recipe)
    @cookbook << recipe
    CSV.open(@csv_path, 'ab', CSV_OPTIONS) do |csv|
      csv << [recipe.name, recipe.description, recipe.cook_time]
    end
  end

  def all
    @cookbook
  end

  def remove_recipe(index)
    @cookbook.delete_at(index)
    CSV.open(@csv_path, 'wb', CSV_OPTIONS) do |csv|
      @cookbook.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.cook_time]
      end
    end
  end
end
