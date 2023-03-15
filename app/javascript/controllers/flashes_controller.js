import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flahes"
export default class extends Controller {
  static targets = [ "element" ];

  connect() {
    this.elementTarget.classList.add("hidden");
    this.slideAlert();
  }

  slideAlert() {
    if (this.elementTarget.classList.contains("hidden")) {
      this.elementTarget.classList.remove("hidden");
    }

    setTimeout(() => {
      this.elementTarget.classList.add("hidden");
    }, 5000);


  }
}
