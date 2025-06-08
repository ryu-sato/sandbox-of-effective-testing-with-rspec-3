class Sandwich
    attr_reader :taste, :ingredients

    def initialize(taste, ingredients)
        @taste = taste
        @ingredients = ingredients
    end

    def add_ingredient(ingredient)
        @ingredients << ingredient
    end
end

RSpec.describe 'An ideal sandwich' do
    it 'is delicious' do
        sandwich = Sandwich.new('delicious', [])

        taste = sandwich.taste

        expect(taste).to eq('delicious')
    end
end
