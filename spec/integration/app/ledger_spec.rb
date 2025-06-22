require_relative '../../../app/api'
require_relative '../../../config/sequel'
require_relative '../../support/db'

module ExpenseTracker
    RSpec.describe Ledger, :aggregate_failures do
        let(:ledger) { Ledger.new }
        let(:expense) do
            {
                'payee' => 'Starbucks',
                'amount' => 5.75,
                'date' => '2017-06-10'
            }
        end

        describe '#record' do
            context 'with a valid expense' do
                it 'successfully saves the expense in the DB' do
                    result = ledger.record(expense)

                    expect(result).to be_success
                    expect(DB[:expenses].all).to match [a_hash_including(
                        id: result.expense_id,
                        payee: 'Starbucks',
                        amount: 5.75,
                        date: Date.parse('2017-06-10')
                    )]
                end
            end
        end
    end
end
