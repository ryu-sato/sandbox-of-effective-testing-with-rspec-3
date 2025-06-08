RSpec.describe 'An ideal sandwich' do
    it 'is delicious' do
        Sandwich = Struct.new(:taste, :toppings)
        sandwich = Sandwich.new('delicious', [])

        taste = sandwich.taste

        expect(taste).to eq('delicious')
    end
end
