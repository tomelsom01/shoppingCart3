import { Controller } from "@hotwired/stimulus"


export default class extends Controller {


  connect() {
    console.log("Stripe Stimulus controller connected")
    this.initializeStripe()
  }


}
