import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.stripe = Stripe(document.querySelector("meta[name='stripe-publishable-key']").content)
    this.elements = this.stripe.elements()
    this.card = this.elements.create('card')
    this.card.mount('#card-element')

    this.form = document.getElementById('payment-form');
    this.form.addEventListener('submit', this.handleSubmit);
  }

  disconnect() {
    this.form.removeEventListener('submit', this.handleSubmit);
    this.card.destroy();
  }

  handleSubmit = async (event) => {
    event.preventDefault();

    const { token, error } = await this.stripe.createToken(this.card);

    if (error) {
      console.error(error);
    } else {
      // Send the token to your server
      const hiddenInput = document.createElement('input');
      hiddenInput.setAttribute('type', 'hidden');
      hiddenInput.setAttribute('name', 'stripeToken');
      hiddenInput.setAttribute('value', token.id);
      this.form.appendChild(hiddenInput);

      this.form.submit();
    }
  }
}
