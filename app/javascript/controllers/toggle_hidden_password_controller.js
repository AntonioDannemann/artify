import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "input"];

  password() {
    // console.log(`${this.value.textContent}`);
   //  console.log(`${this.input.type}`);
    console.log("hello from toggle")

    if (this.value.textContent === "button") {
      this.value.textContent = "hide";
      this.input.type = "text";
    } else {
      this.value.textContent = "button";
      this.input.type = "password";
    }
  }

  get value() {
    return this.buttonTarget;
  }
  get input() {
    return this.inputTarget;
  }
}
