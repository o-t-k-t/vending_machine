# frozen_string_literal: true

require 'currency.rb'

# VendingMachine dispenses beverages
class VendingMachine
  PRICES = {
    cola:  100,
    oolong_tea: 100,
    water: 100,
    redbull: 200
  }.freeze

  def initialize
    @payment = Money.new(0)
  end

  def insert(curr)
    if curr == Currency.new(100)
      @payment += curr
      false
    else
      curr
    end
  end

  def push_bottun(name)
    price = PRICES[name]
    raise 'Absent item' if price.nil?

    if Money.new(price) <= @payment
      name
    else
      false
    end
  end
end
