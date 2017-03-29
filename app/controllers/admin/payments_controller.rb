class Admin::PaymentsController < AdminsController
  def index
    @payments = PaymentDecorator.decorate_collection(Payment.all)
  end
end
