# frozen_string_literal: true

require 'vending_machine'

require 'bundler/setup'
require 'rspec-parameterized'
require 'pry'

describe VendingMachine do
  using RSpec::Parameterized::TableSyntax

  let(:vm) { VendingMachine.new }

  context 'when inserting varius currencys' do
    where(:inserted, :refund?) do
      1      | true
      5      | true
      10     | true
      50     | true
      100    | false
      500    | true
      1000   | true
      5000   | true
      10_000 | true
    end

    with_them do
      it 'rejects currencys other than 100 yen' do
        curr = Currency.new(inserted)
        refund = refund? ? curr : false
        expect(vm.insert(Currency.new(inserted))).to eq refund
      end
    end
  end

  context 'when the push the bottun after some-times-currencies insertion' do
    where(:number_of_insertion, :dispensed) do
      0 | false
      1 | Item.new('cola')
      2 | Item.new('cola')
    end

    with_them do
      it 'dispenses a cola if payment is enough' do
        number_of_insertion.times { vm.insert(Currency.new(100)) }
        expect(vm.push_bottun).to eq dispensed
      end
    end
  end
end
