require 'sinatra/base'
require 'json'

module ExpenseTracker
    RecordResult = Struct.new(:success?, :expense_id, :error_message)

    class Ledger
        def record(expense)
            unless expense.key?('payee')
                message = 'Invalid expense: `payee` is required'
                return RecordResult.new(false, nil, message)
            end
            
            DB[:expenses].insert(expense)
            id = DB[:expenses].max(:id)
            RecordResult.new(true, id, nil)
        end

        def expenses_on(date)
            DB[:expenses].where(date: date).all
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
            expenses = settings.ledger.expenses_on(params['date'])
            JSON.generate(expenses)
        end
    end
end