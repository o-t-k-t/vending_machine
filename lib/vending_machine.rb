# frozen_string_literal: true

require 'observer'
require 'forwardable'

require_relative 'currency.rb'
require_relative 'button.rb'
require_relative 'felica.rb'

# VendingMachine is a facade of this program
class VendingMachine
  extend Forwardable

  delegate %i[insert refund touch] => :@vending_machine
  delegate %i[show push] => :@bottun_list

  def initialize
    @vending_machine = VendingMachineCore.new(felica_client)
    @bottun_list = @vending_machine.bottun_list
  end

  private

  def felica_client
    FelicaClient.new
  end
end

# VendingMachineCore dispenses beverages
class VendingMachineCore
  include Observable
  extend Forwardable

  delegate %i[touch] => :@felica_state

  attr_reader :payment

  PRICES = {
    cola:  100,
    oolong_tea: 100,
    water: 100,
    redbull: 200
  }.freeze

  COINS = [10, 50, 100, 500].freeze

  def initialize(felica_client)
    @payment = Money.new(0)
    @felica_client = felica_client
    @felica_state = FelicaUnselectedState.new(@felica_client)
  end

  def insert(curr)
    return curr unless COINS.find { |c| Currency.new(c) == curr }

    @payment += curr
    changed and notify_observers(@payment)

    false
  end

  def bottun_list
    BottunList.new do |bl|
      PRICES.each do |k, v|
        bl.append(Button.new(k, Money.new(v), self))
      end
    end
  end

  def buy(name)
    raise 'Absent item' if PRICES[name].nil?

    price = Money.new(PRICES[name])

    if price > @payment
      puts "#{price} #{@payment}"
      @felica_state = FelicaSelectedState.new(@felica_client, name, price)
      return []
    end

    @payment -= price

    rtn = [name, @payment.clone]
    @payment = Money.new(0)

    changed and notify_observers(@payment)

    rtn
  end

  def refund
    rtn = @payment.clone
    @payment = Money.new(0)
    changed and notify_observers(@payment)
    rtn
  end
end
