require 'csv'

def insert_all(model_class, csv_path)
  if defined? model_class
    records = CSV.read(csv_path, headers: true).map(&:to_hash)
    records = records.map { |r| r.slice(*model_class.column_names) }
    model_class.insert_all(records)
  end
end

insert_all(User, "#{File.dirname(__FILE__)}/seeds/users.csv") if defined? User
insert_all(Recipe, "#{File.dirname(__FILE__)}/seeds/recipes.csv") if defined? Recipe
insert_all(Ingredient, "#{File.dirname(__FILE__)}/seeds/ingredients.csv") if defined? Ingredient
insert_all(Step, "#{File.dirname(__FILE__)}/seeds/steps.csv") if defined? Step
