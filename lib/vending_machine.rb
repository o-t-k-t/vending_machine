# frozen_string_literal: true

require 'item.rb'
require 'currency.rb'

require 'pry'

# VendingMachine dispenses beverages
class VendingMachine
  ITEMS = [Item.new('cola'), Item.new('oolong_tea'), Item.new('water')].freeze

  def initialize
    @payment = 0
  end

  def insert(curr)
    if curr.price == 100
      @payment += curr.price
      false
    else
      curr
    end
  end

  def push_bottun(name)
    item = Item.new(name)
    raise 'Absent item' unless ITEMS.include?(item)

    if @payment >= 100
      item
    else
      false
    end
  end

  private

  def currency(price)
    Currency.new(price)
  end
end
