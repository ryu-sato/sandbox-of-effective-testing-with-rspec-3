require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
    RSpec.describe API do
        include Rack::Test::Methods

        def app
            API.create(ledger: ledger)
        end

        let(:ledger) { instance_double('ExpenseTracker::Ledger') }

        describe 'POST /expenses' do
            context 'when the expense is successfully recorded' do
                let(:expense) { { 'some' => 'data' } }

                before do
                    allow(ledger).to receive(:record)
                        .with(expense)
                        .and_return(RecordResult.new(true, 417, nil))
                end

                it 'returns the expense id' do
                    post '/expenses', JSON.generate(expense)
                    parsed = JSON.parse(last_response.body)
                    expect(parsed).to include('expense_id' => 417)
                end

                it 'responds with a 200 (OK)' do
                    post '/expenses', JSON.generate(expense)
                    expect(last_response.status).to eq(200)
                end
            end

            context 'when the expense fails validation' do
                let(:expense) { { 'some' => 'data' } }

                before do
                    allow(ledger).to receive(:record)
                        .with(expense)
                        .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
                end

                it 'returns an error message' do
                    post '/expenses', JSON.generate(expense)

                    parsed = JSON.parse(last_response.body)
                    expect(parsed).to include('error' => 'Expense incomplete')
                end

                it 'returns a 422 (Unprocessable Entity)' do
                    post '/expenses', JSON.generate(expense)
                    expect(last_response.status).to eq(422)
                end
            end
        end

        describe 'GET /expenses/:date' do
            context 'when expenses exist on the given date' do
                let(:date) { '2017-06-10' }

                before do
                    allow(ledger).to receive(:expenses_on)
                        .with(date)
                        .and_return([{ 'id' => 417}])
                end

                it 'returns the expense records as JSON' do
                    get "/expenses/#{date}"
                    parsed = JSON.parse(last_response.body)
                    expect(parsed).to be_a(Array)
                    expect(parsed).to all(include('id' => 417))
                end
                it 'responds with a 200 (OK)' do
                    get "/expenses/#{date}"
                    expect(last_response.status).to eq(200)
                end
            end
            context 'when there are no expenses on the given date' do
                let(:date_not_found) { '2017-06-11' }

                before do
                    allow(ledger).to receive(:expenses_on)
                        .with(date_not_found)
                        .and_return([])
                end

                it 'returns an empty array as JSON' do
                    get "/expenses/#{date_not_found}"
                    parsed = JSON.parse(last_response.body)
                    expect(parsed).to eq([])
                end
                it 'responds with a 200 (OK)' do
                    get "/expenses/#{date_not_found}"
                    expect(last_response.status).to eq(200)
                end
            end
        end
    end
end
