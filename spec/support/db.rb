RSpec.configure do |c|
    c.before(:suite) do
        Sequel.extension :migration
        Sequel::Migrator.run(ExpenseTracker::DB, 'db/migrations')
        DB[:expenses].truncate
    end
end
