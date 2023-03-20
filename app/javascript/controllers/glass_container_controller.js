import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="glass-container"
export default class extends Controller {
  static targets = [ "seeMoreButton", "glassContainer", "description" ];
  expanded = false;

  connect() {
    this.seeMoreButtonTarget.addEventListener('click', () => this.toggle());
  }

  toggle() {
    if (!this.expanded) {
      this.glassContainerTarget.style.height = '86%';
      this.glassContainerTarget.style.width = '100%';
      this.descriptionTarget.style.overflow = 'scroll';
      this.descriptionTarget.style.height = '480px';
      this.seeMoreButtonTarget.querySelector('p').textContent = 'See Less';
    } else {
      this.glassContainerTarget.style.height = '350px';
      this.glassContainerTarget.style.width = '90%';
      this.descriptionTarget.style.overflow = 'hidden';
      this.descriptionTarget.style.height = '86px';
      this.seeMoreButtonTarget.querySelector('p').textContent = 'See More';
    }
    this.expanded = !this.expanded;
  }
}
