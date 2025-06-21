Sequel.migration do
    change do
        create_table :expenses do
            primary_key :id
            Stirng :peyee
            Float :amount
            Date :date
        end
    end
end