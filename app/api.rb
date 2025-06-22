require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
    class API < Sinatra::Base
        set :ledger, Ledger.new

        def self.create(ledger: Ledger.new)
            set :ledger, ledger
            new
        end

        private

        post '/expenses' do
            expense = JSON.parse(request.body.read)
            result = settings.ledger.record(expense)

            if result.success?
                JSON.generate('expense_id' => result.expense_id)
            else
                status 422
                JSON.generate('error' => result.error_message || 'Expense incomplete')
            end
        end

        get '/expenses/:date' do
            expenses = settings.ledger.expenses_on(params['date'])
            JSON.generate(expenses)
        end
    end
end