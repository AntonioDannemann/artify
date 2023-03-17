import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="window-events"
export default class extends Controller {
  static targets = ["navbar"]

  initialize() {
    this.#scrollToTopOnReload()
  }

  #scrollToTopOnReload() {
    if (history.scrollRestoration) {
      history.scrollRestoration = 'manual';
    } else {
        window.onbeforeunload = () => {
            window.scrollTo(0, 0);
        }
    }
  }
}
