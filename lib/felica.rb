# FelicaUnselectedState behaves as if no item selected
class FelicaUnselectedState
  def initialize(felica_client)
    @felica_client = felica_client
  end

  def touch
    "Your balance: #{@felica_client.balance} yen"
  end
end

# FelicaSelectedState behaves as if no item selected
class FelicaSelectedState
  def initialize(felica_client, name, price)
    @felica_client = felica_client
    @name = name
    @price = price
  end

  def touch
    if @felica_client.withdraw(@price)
      @name
    else
      false
    end
  end
end

# FelicaNullState behaves as if no item selected
class FelicaNullState
  def touch
    false
  end
end

# FelicaClient is dummy external library
class FelicaClient
  def balance
    1000
  end

  def withdraw
    true
  end
end
