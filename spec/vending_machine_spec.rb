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

  context 'when the push a cola bottun after some-times-currencies insertion' do
    where(:number_of_insertion, :dispensed) do
      0 | false
      1 | :cola
      2 | :cola
    end

    with_them do
      it 'dispenses a cola if payment is enough' do
        number_of_insertion.times { vm.insert(Currency.new(100)) }
        expect(vm.push(:cola)).to eq dispensed
      end
    end
  end

  context 'when the push a redbull bottun after some-times-currencies insertion' do
    where(:number_of_insertion, :dispensed) do
      1 | :cola
      2 | :cola
      3 | :cola
    end

    with_them do
      it 'dispenses a cola if payment is enough' do
        number_of_insertion.times { vm.insert(Currency.new(100)) }
        expect(vm.push(:cola)).to eq dispensed
      end
    end
  end

  context 'when the push some bottuns' do
    where(:name, :dispensed) do
      :cola       | :cola
      :oolong_tea | :oolong_tea
      :water      | :water
    end

    with_them do
      it 'dispenses supported item' do
        vm.insert(Currency.new(100))
        expect(vm.push(name)).to eq dispensed
      end
    end
  end

  context 'when viewing bottuns after some-times-currencies insertion' do
    where(:number_of_insertion, :display) do
      0 | '⚫️ cola: 100 yen, ⚫️ oolong_tea: 100 yen, ⚫️ water: 100 yen, ⚫️ redbull: 200 yen'
      1 | '🔵 cola: 100 yen, 🔵 oolong_tea: 100 yen, 🔵 water: 100 yen, ⚫️ redbull: 200 yen'
      2 | '🔵 cola: 100 yen, 🔵 oolong_tea: 100 yen, 🔵 water: 100 yen, 🔵 redbull: 200 yen'
      3 | '🔵 cola: 100 yen, 🔵 oolong_tea: 100 yen, 🔵 water: 100 yen, 🔵 redbull: 200 yen'
    end

    with_them do
      it 'dispenses a cola if payment is enough' do
        number_of_insertion.times { vm.insert(Currency.new(100)) }
        expect(vm.show).to eq display
      end
    end
  end
end
