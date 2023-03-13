import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "input"];

  toggleHiddenPassword() {
    this.inputTarget.type = this.buttonTarget.classList.contains("fa-eye") ? "text" : "password"

    this.buttonTarget.classList.toggle("fa-eye")
    this.buttonTarget.classList.toggle("fa-eye-slash")
  }
}
