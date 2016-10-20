Rails.configuration.stripe = {
  :publishable_key => ENV['stripe_publishable_key'],
  :secret_key      => ENV['stripe_api_key']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = ENV["stripe_publishable_key"]

StripeEvent.configure do |events|
  events.subscribe 'invoice_payment.failed' do |event|
    invoice = event.data.object # Invoice object
    customer = Stripe::Customer.retrieve(invoice.customer) # Customer associated with the invoice
    email = customer.email
    MeetMailer.payment_failure(email).deliver_now

  end
end
