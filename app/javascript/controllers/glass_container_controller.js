import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="glass-container"
export default class extends Controller {
  static targets = [ "seeMoreButton", "glassContainer", "description", "image" ];
  expanded = false;

  connect() {
    this.seeMoreButtonTarget.addEventListener('click', () => this.toggle());
  }

  toggle() {
    if (!this.expanded) {
      // Glass container
      this.glassContainerTarget.style.height = '90%';
      this.glassContainerTarget.style.width = '100%';
      // Description container
      this.descriptionTarget.style.position = 'relative';
      this.descriptionTarget.style.bottom = '-6%';
      this.descriptionTarget.style.overflow = 'scroll';
      this.descriptionTarget.style.height = '66%';
      // Button container
      this.seeMoreButtonTarget.style.position = 'relative';
      this.seeMoreButtonTarget.style.bottom = '-5%';
      this.seeMoreButtonTarget.querySelector('p').textContent = 'See Less';
      // Show the image
      this.imageTarget.style.display = 'block';
    } else {
      // Glass container
      this.glassContainerTarget.style.height = '35%';
      this.glassContainerTarget.style.width = '90%';
      // Description container
      this.descriptionTarget.style.position = 'relative';
      this.descriptionTarget.style.bottom = '13%';
      this.descriptionTarget.style.overflow = 'hidden';
      this.descriptionTarget.style.height = '30%';
      // Button container
      this.seeMoreButtonTarget.style.position = 'relative';
      this.seeMoreButtonTarget.style.bottom = '11%';
      this.seeMoreButtonTarget.querySelector('p').textContent = 'See More';
      // Hide the image
      this.imageTarget.style.display = 'none';
    }
    this.expanded = !this.expanded;
  }
}
