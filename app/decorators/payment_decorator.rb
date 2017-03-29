class PaymentDecorator < Draper::Decorator
  delegate_all

  def parsed_amount
    "$#{object.amount / 100.0}"
  end
end
