require 'sinatra/base'
require 'json'

class Ledger
  def record(_expense)
    ExpenseTracker::RecordResult.new
  end
end

module ExpenseTracker
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