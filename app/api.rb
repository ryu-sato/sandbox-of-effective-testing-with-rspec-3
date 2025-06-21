require 'sinatra/base'
require 'json'

class Ledger
  def record(_expense)
    ExpenseTracker::RecordResult.new
  end
end

module ExpenseTracker
    class API < Sinatra::Base
        def initialize(app = nil, ledger: Ledger.new)
            @ledger = ledger
            super(app)
        end

        post '/expenses' do
            JSON.generate('expense_id' => 42)
        end

        get '/expenses/:date' do
            JSON.generate([])
        end
    end
end