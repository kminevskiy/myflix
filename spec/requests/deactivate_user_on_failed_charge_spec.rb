require "spec_helper"

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id": "evt_19xdPvBojCadX4Lx7O3GbM5k",
      "object": "event",
      "api_version": "2017-02-14",
      "created": 1489589279,
      "data": {
        "object": {
          "id": "ch_19xdPvBojCadX4LxWpV2Ld5K",
          "object": "charge",
          "amount": 999,
          "amount_refunded": 0,
          "application": nil,
          "application_fee": nil,
          "balance_transaction": nil,
          "captured": false,
          "created": 1489589279,
          "currency": "usd",
          "customer": "cus_AI0aYbKt0PJAsL",
          "description": "Failed charge",
          "destination": nil,
          "dispute": nil,
          "failure_code": "card_declined",
          "failure_message": "Your card was declined.",
          "fraud_details": {},
          "invoice": nil,
          "livemode": false,
          "metadata": {},
          "on_behalf_of": nil,
          "order": nil,
          "outcome": {
            "network_status": "declined_by_network",
            "reason": "generic_decline",
            "risk_level": "normal",
            "seller_message": "The bank did not return any further details with this decline.",
            "type": "issuer_declined"
          },
          "paid": false,
          "receipt_email": nil,
          "receipt_number": nil,
          "refunded": false,
          "refunds": {
            "object": "list",
            "data": [],
            "has_more": false,
            "total_count": 0,
            "url": "/v1/charges/ch_19xdPvBojCadX4LxWpV2Ld5K/refunds"
          },
          "review": nil,
          "shipping": nil,
          "source": {
            "id": "card_19xdPIBojCadX4LxSoEgTUK8",
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
            "customer": "cus_AI0aYbKt0PJAsL",
            "cvc_check": "pass",
            "dynamic_last4": nil,
            "exp_month": 3,
            "exp_year": 2018,
            "fingerprint": "sJYvBA5AffbgI8oU",
            "funding": "credit",
            "last4": "0341",
            "metadata": {},
            "name": nil,
            "tokenization_method": nil
          },
          "source_transfer": nil,
          "statement_descriptor": nil,
          "status": "failed",
          "transfer_group": nil
        }
      },
      "livemode": false,
      "pending_webhooks": 1,
      "request": "req_AIDr0xs7H74vyT",
      "type": "charge.failed"
    }
  end

  it "deactivates a user with webhook data from stripe for failed charge", :vcr do
    alice = Fabricate(:user, customer_token: "cus_AI0aYbKt0PJAsL")
    post "/stripe_events", params: event_data
    expect(alice.reload).not_to be_active
  end
end
