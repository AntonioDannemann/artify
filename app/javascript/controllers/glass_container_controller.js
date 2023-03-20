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
      // Glass container
      this.glassContainerTarget.style.height = '86%';
      this.glassContainerTarget.style.width = '100%';
      // Description container
      this.descriptionTarget.style.position = 'relative';
      this.descriptionTarget.style.bottom = '6%';
      this.descriptionTarget.style.overflow = 'scroll';
      this.descriptionTarget.style.height = '70%';
      // Button container
      this.seeMoreButtonTarget.style.position = 'relative';
      this.seeMoreButtonTarget.style.bottom = '6%';
      this.seeMoreButtonTarget.querySelector('p').textContent = 'See Less';
    } else {
      // Glass container
      this.glassContainerTarget.style.height = '38%';
      this.glassContainerTarget.style.width = '90%';
      // Description container
      this.descriptionTarget.style.position = 'relative';
      this.descriptionTarget.style.bottom = '15%';
      this.descriptionTarget.style.overflow = 'hidden';
      this.descriptionTarget.style.height = '30%';
      // Button container
      this.seeMoreButtonTarget.style.position = 'relative';
      this.seeMoreButtonTarget.style.bottom = '15%';
      this.seeMoreButtonTarget.querySelector('p').textContent = 'See More';
    }
    this.expanded = !this.expanded;
  }
}
