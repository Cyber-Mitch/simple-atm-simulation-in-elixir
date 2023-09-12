# Define a struct to represent an ATM
ExUnit.start()
defmodule ATM do

  @type t :: %__MODULE__{balance: non_neg_integer(), pin: String.t()}
  defstruct balance: 0, pin: "1234"

  @pin "1234"

 @spec withdraw(t(), non_neg_integer(), String.t()) :: {:ok, t(), non_neg_integer()} | {:error, String.t()}

  def withdraw(%__MODULE__{balance: balance, pin: @pin}, amount, @pin)
  when amount > 0 and amount <= balance do
  new_balance = balance - amount
  new_atm = %__MODULE__{balance: new_balance, pin: @pin}
  {:ok, new_atm, amount}
  end

  def withdraw(%__MODULE__{balance: balance, pin: _}, amount, @pin) when amount > balance do
    {:error, "Insufficient balance"}
  end

  def withdraw(%__MODULE__{pin: _}, _, _) do
  {:error, "Incorrect Pin"}
  end

@spec deposit(t(), non_neg_integer(), String.t()) :: {:ok, t()} | {:error, String.t()}
  def deposit(%__MODULE__{balance: balance, pin: @pin}, amount, @pin) when amount > 0 do
    new_atm = %__MODULE__{balance: balance + amount, pin: @pin}
    {:ok, new_atm}
  end

  def deposit(%__MODULE__{}, amount, _) when amount <= 0 do
    {:error, "Invalid amount"}
  end

  def deposit(%__MODULE__{}, _, _) do
    {:error, "Wrong pin"}
  end
end

# Define test cases within the same file
defmodule ATMTest do
  use ExUnit.Case

  # Test the withdraw function
  test "insufficient balance during withdrawal" do
    atm = %ATM{balance: 10000}
    {:error, message} = ATM.withdraw(atm, 20000, "1234")
    assert message == "Insufficient balance"
  end

  test "wrong pin during withdrawal" do
    atm = %ATM{balance: 1000}
    {:error, message} = ATM.withdraw(atm, 100, "4321")
    assert message == "Incorrect Pin"
  end

  test "successful withdrawal" do
    atm = %ATM{balance: 100000000000}
    {:ok, new_atm, cash} = ATM.withdraw(atm, 60000, "1234")
    assert cash == 60000
    assert new_atm.balance == 100000000000 - cash
  end


end
