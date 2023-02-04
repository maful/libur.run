import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    const options = {
      placement: "center-center",
      backdropClasses: "modal__backdrop",
      backrop: "static",
      onShow: () => {
        // remove the default classes because the element being cut off
        this.element.classList.remove("flex", "justify-center", "items-center")
        // add display block to show the element
        this.element.classList.add("block")
      },
      onHide: () => {
        this.element.remove()
      },
    }

    this.modal = new Modal(this.element, options)
    this.open()
  }

  open() {
    if (!this._isOpened) {
      this.modal.show()
    }
  }

  close() {
    this.modal.hide()
  }

  get _isOpened() {
    const ariaHidden = this.element.getAttribute("aria-hidden")
    return ariaHidden === null
  }
}
