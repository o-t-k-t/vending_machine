# frozen_string_literal: true

require 'observer'
require 'forwardable'

require_relative 'currency.rb'
require_relative 'button.rb'

# VendingMachine is a facade of this program
class VendingMachine
  extend Forwardable

  delegate %i[insert] => :@vending_machine
  delegate %i[show push] => :@bottun_list

  def initialize
    @vending_machine = VendingMachineCore.new
    @bottun_list = @vending_machine.bottun_list
  end
end

# VendingMachineCore dispenses beverages
class VendingMachineCore
  include Observable

  attr_reader :payment

  PRICES = {
    cola:  100,
    oolong_tea: 100,
    water: 100,
    redbull: 200
  }.freeze

  COINS = [10, 50, 100, 500].freeze

  def initialize
    @payment = Money.new(0)
  end

  def insert(curr)
    return curr unless COINS.map { |ac| Currency.new(ac) }.include?(curr)

    @payment += curr
    changed
    notify_observers(@payment)
    false
  end

  def bottun_list
    bl = ButtonList.new

    PRICES.map do |k, v|
      bottun = Button.new(k, Money.new(v), self)
      bl.append(bottun)
      bottun
    end

    bl
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
