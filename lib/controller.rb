require_relative 'cookbook'
require_relative 'parsing'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @parsing = RecipeParsing.new
  end

  def list
    return print "Sorry you don't currently have any recipes\!\n\n" if @cookbook.all.empty?
    recipe_list = ""
    @cookbook.all.each_with_index do |recipe, index|
      recipe_list << "Recipe \##{index + 1}:\n\tName: #{recipe.name}\n\t"
      recipe_list << "Description: #{recipe.description}\n\tCook Time: #{recipe.cook_time}\n"
      recipe_list << "----------------------\n"
    end
    print recipe_list
  end

  def create
    puts "What is the name of the recipe you would like to create?"
    recipe_name = gets.chomp
    puts "Please describe #{recipe_name}:"
    recipe_description = gets.chomp
    puts "How long will it take to cook?"
    recipe_cook_time = gets.chomp
    new_recipe = Recipe.new(recipe_name, recipe_description, recipe_cook_time)
    @cookbook.add_recipe(new_recipe)
    print `clear`
  end

  def destroy
    list
    puts "At what position in the recipe list would you like to remove?"
    recipe_index = gets.chomp.to_i - 1
    @cookbook.remove_recipe(recipe_index)
    print `clear`
  end

  def parse_recipe
    parsed_recipe_array = @parsing.parse_recipe
    parsed_recipe = Recipe.new(parsed_recipe_array.first, parsed_recipe_array[1], parsed_recipe_array.last)
    @cookbook.add_recipe(parsed_recipe)
  end
end
