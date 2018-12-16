# frozen_string_literal: true

require 'item.rb'
require 'currency.rb'

require 'pry'

# VendingMachine dispenses beverages
class VendingMachine
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

  def push_bottun
    if @payment >= 100
      Item.new('cola')
    else
      false
    end
  end

  private

  def currency(price)
    Currency.new(price)
  end
end
