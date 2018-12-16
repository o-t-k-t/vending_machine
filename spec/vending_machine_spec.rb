# frozen_string_literal: true

require 'vending_machine'

describe VendingMachine do
  let(:vending_machine) { VendingMachine.new }
  context 'when the bottun is pressed' do
    it 'dispenses a can of cola' do
      expect(vending_machine.push_bottun.name).to eq 'Cola'
    end
  end
end
