class UserSignup
  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, referer)
    if @user.valid?
      customer = StripeWrapper::Customer.create(user: @user, card: stripe_token)
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        UserMailer.delay.welcome_email(@user)
        Relationship.create(leader: referer, follower: @user) if referer
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Please check your input and try again."
      self
    end
  end

  def successful?
    @status == :success
  end
end
