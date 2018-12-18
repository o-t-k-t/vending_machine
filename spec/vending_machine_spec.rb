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
      10     | false
      50     | false
      100    | false
      500    | false
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
      0 | []
      1 | [:cola, Money.new(0)]
      2 | [:cola, Money.new(100)]
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
      1 | []
      2 | [:redbull, Money.new(0)]
      3 | [:redbull, Money.new(100)]
    end

    with_them do
      it 'dispenses a cola if payment is enough' do
        number_of_insertion.times { vm.insert(Currency.new(100)) }
        expect(vm.push(:redbull)).to eq dispensed
      end
    end
  end

  context 'when the push some bottuns' do
    where(:name, :dispensed) do
      :cola       | [:cola, Money.new(0)]
      :oolong_tea | [:oolong_tea, Money.new(0)]
      :water      | [:water, Money.new(0)]
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

  context 'when refund or else after coin insertion' do
    where(:refund?, :display) do
      false | '🔵 cola: 100 yen, 🔵 oolong_tea: 100 yen, 🔵 water: 100 yen, ⚫️ redbull: 200 yen'
      true  | '⚫️ cola: 100 yen, ⚫️ oolong_tea: 100 yen, ⚫️ water: 100 yen, ⚫️ redbull: 200 yen'
    end

    with_them do
      it 'lights down after refunding' do
        vm.insert(Currency.new(100))
        vm.refund if refund?
        expect(vm.show).to eq display
      end
    end
  end

  context 'when cola has bought with 100 yen' do
    before do
      vm.insert(Currency.new(100))
      vm.push(:cola)
    end

    it 'cannot sell more item without additional payment' do
      expect(vm.push(:oolong_tea)).to eq []
    end

    it 'can sell more item with additional payment' do
      vm.insert(Currency.new(100))
      expect(vm.push(:oolong_tea)).to eq [:oolong_tea, Money.new(0)]
    end
  end

  context 'when currencies has inserted' do
    before do
      vm.insert(Currency.new(100))
    end

    it 'refund payments if requested' do
      expect(vm.refund).to eq Money.new(100)
    end
  end

  describe '#touch' do
    context 'when no item selected' do
      it 'dispalays balance' do
        fc_mock = double('Feica Client')
        allow(fc_mock).to receive(:balance).and_return(1000)
        expect(fc_mock).to receive(:balance)

        allow(FelicaClient).to receive(:new).and_return(fc_mock)
        vm = VendingMachine.new

        expect(vm.touch).to eq 'Your balance: 1000 yen'
      end
    end

    context 'when a item selected' do
      it 'withdraw and dispenses a item' do
        fc_mock = double('Feica Client')
        allow(fc_mock).to receive(:withdraw).and_return(true)
        expect(fc_mock).to receive(:withdraw)

        allow(FelicaClient).to receive(:new).and_return(fc_mock)
        vm = VendingMachine.new

        vm.push(:cola)

        expect(vm.touch).to eq :cola
      end
    end
  end
end
