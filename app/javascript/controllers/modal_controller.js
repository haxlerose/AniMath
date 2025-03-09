import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "overlay"];

  show() {
    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none");
    this.overlayTarget.classList.add("opacity-100");
    this.contentTarget.classList.remove("scale-95");
    this.contentTarget.classList.add("scale-100");
  }

  hide() {
    this.overlayTarget.classList.remove("opacity-100");
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none");
    this.contentTarget.classList.remove("scale-100");
    this.contentTarget.classList.add("scale-95");
  }
}
