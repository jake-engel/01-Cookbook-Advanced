class Recipe
  attr_reader :name, :description, :cook_time
  def initialize(name, description, cook_time)
    @name = name
    @description = description
    @cook_time = cook_time
  end
end
