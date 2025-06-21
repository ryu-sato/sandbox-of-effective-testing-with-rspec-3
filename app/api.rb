require 'sinatra/base'
require 'json'

module ExpenseTracker
    RecordResult = Struct.new(:success?, :expense_id, :error_message)

    class Ledger
        def record(expense)
        end
    end

    class API < Sinatra::Base
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
            JSON.generate([])
        end
    end
end