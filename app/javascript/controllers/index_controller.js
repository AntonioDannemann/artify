import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="index"
export default class extends Controller {
  static targets =  ["blinder", "index"];
  expanded = false;

  connect() {
    console.log("step 2");
    console.log(this);
    this.blinderTarget.addEventListener('click', () => this.toggle());
  }
  toggle() {
    if (!this.expanded) {
      this.indexTarget.style.position = 'fixed';
      this.indexTarget.style.bottom = '0%';
      this.indexTarget.style.overflow = 'scroll';
      this.indexTarget.style.height = '32%';

      this.blinderTarget.style.position = 'fixed';
      this.blinderTarget.style.bottom = '29%';

    } else {

      this.indexTarget.style.position = 'fixed';
      this.indexTarget.style.bottom = '0%';
      this.indexTarget.style.overflow = 'hidden';
      this.indexTarget.style.height = '0%';

      this.blinderTarget.style.position = 'fixed';
      this.blinderTarget.style.bottom = '0%';
    }
    this.expanded = !this.expanded;
  }
}
