require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id": "evt_19xQ0dBojCadX4LxUDsJRQy0",
      "object": "event",
      "api_version": "2017-02-14",
      "created": 1489537739,
      "data": {
        "object": {
          "id": "ch_19xQ0dBojCadX4LxMYkMCJQZ",
          "object": "charge",
          "amount": 999,
          "amount_refunded": 0,
          "application": nil,
          "application_fee": nil,
          "balance_transaction": "txn_19xQ0dBojCadX4Lx5ogLd3xr",
          "captured": true,
          "created": 1489537739,
          "currency": "usd",
          "customer": "cus_AI00uT1SlXDSkn",
          "description": nil,
          "destination": nil,
          "dispute": nil,
          "failure_code": nil,
          "failure_message": nil,
          "fraud_details": {
          },
          "invoice": "in_19xQ0dBojCadX4LxDcKcba3f",
          "livemode": false,
          "metadata": {
          },
          "on_behalf_of": nil,
          "order": nil,
          "outcome": {
            "network_status": "approved_by_network",
            "reason": nil,
            "risk_level": "normal",
            "seller_message": "Payment complete.",
            "type": "authorized"
          },
          "paid": true,
          "receipt_email": nil,
          "receipt_number": nil,
          "refunded": false,
          "refunds": {
            "object": "list",
            "data": [

            ],
            "has_more": false,
            "total_count": 0,
            "url": "/v1/charges/ch_19xQ0dBojCadX4LxMYkMCJQZ/refunds"
          },
          "review": nil,
          "shipping": nil,
          "source": {
            "id": "card_19xQ0cBojCadX4LxFyMqVsw9",
            "object": "card",
            "address_city": nil,
            "address_country": nil,
            "address_line1": nil,
            "address_line1_check": nil,
            "address_line2": nil,
            "address_state": nil,
            "address_zip": nil,
            "address_zip_check": nil,
            "brand": "Visa",
            "country": "US",
            "customer": "cus_AI00uT1SlXDSkn",
            "cvc_check": "pass",
            "dynamic_last4": nil,
            "exp_month": 3,
            "exp_year": 2018,
            "fingerprint": "hdwdOAZx78iaeOEG",
            "funding": "credit",
            "last4": "4242",
            "metadata": {
            },
            "name": nil,
            "tokenization_method": nil
          },
          "source_transfer": nil,
          "statement_descriptor": nil,
          "status": "succeeded",
          "transfer_group": nil
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_AI004vztxnfR1m",
      "type": "charge.succeeded"
    }
  end

  it "creates a payment with the webhook", :vcr do
    post "/stripe_events", params: event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_AI00uT1SlXDSkn")
    post "/stripe_events", params: event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the ammount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_AI00uT1SlXDSkn")
    post "/stripe_events", params: event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_AI00uT1SlXDSkn")
    post "/stripe_events", params: event_data
    expect(Payment.first.reference_id).to eq("ch_19xQ0dBojCadX4LxMYkMCJQZ")
  end
end
