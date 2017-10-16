require 'nokogiri'
require 'open-uri'

class RecipeParsing
  def parse_recipe
    puts "What ingredient would you like a recipe for?\n"
    recipe_item = gets.chomp
    choose_recipe(display_recipe_list(recipe_list(recipe_item)))
  end

  private

  def recipe_list(recipe_item = "strawberry")
    # url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{recipe_item}"
    url = './lib/strawberry.html'
    recipes_names = scrape_recipe_names(url)
    recipes_description = scrape_recipe_descriptions(url)
    recipes_times = scrape_recipe_times(url)
    recipes = []
    recipes_names.each_with_index do |recipe, index|
      recipes << [recipe, recipes_description[index], recipes_times[index]]
    end
    recipes
  end

  def scrape_recipe_names(url)
    html_doc = Nokogiri::HTML(File.open(url).read, nil, 'utf-8')
    recipes_names = []
    html_doc.search('.m_titre_resultat a').each { |recipe| recipes_names << recipe.text }
    recipes_names
  end

  def scrape_recipe_descriptions(url)
    html_doc = Nokogiri::HTML(File.open(url).read, nil, 'utf-8')
    recipes_description = []
    html_doc.search('.m_detail_recette').each { |description| recipes_description << description.text.strip }
    recipes_description
  end

  def scrape_recipe_times(url)
    html_doc = Nokogiri::HTML(File.open(url).read, nil, 'utf-8')
    recipes_times = []
    html_doc.search('.m_detail_time').each do |time|
      time_string = time.text.strip.split(/[^\d]/)
      time_string.delete("")
      recipes_times << time_string.first
    end
    recipes_times
  end

  def choose_recipe(recipe_list)
    print "\n\nPlease type a number to choose which recipe to import.\n\n>> "
    recipe_number = gets.chomp.to_i
    if recipe_number.between?(1, recipe_list.length)
      print `clear`
      return recipe_list[recipe_number - 1]
    end
    print `clear`
    print "Sorry that number doesn't exist in the recipe page ya fool\!\n"
    return recipe_list
  end

  def display_recipe_list(recipe_list)
    recipe_list.each_with_index { |recipe, index| puts "Recipe #{index + 1}: #{recipe.first.capitalize}" }
  end
end
