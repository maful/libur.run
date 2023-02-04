// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import TurboReady from "turbo_ready"
TurboReady.initialize(Turbo.StreamActions)

import "./controllers"
import "./actions/streams_event"
import "flowbite/dist/flowbite.turbo.js"
import "@github/markdown-toolbar-element"
import { Turbo } from "@hotwired/turbo-rails"

Turbo.setConfirmMethod((message, element) => {
  const dialog = document.getElementById("turbo-confirm")
  const dialogTitle = element.getAttribute("data-turbo-title")
  if (dialogTitle != null) {
    dialog.querySelector("#title").textContent = dialogTitle
  }
  const buttonText = element.getAttribute("data-turbo-button-text")
  if (buttonText != null) {
    dialog.querySelector("button#button_yes").textContent = buttonText
  }
  dialog.querySelector("#supporting_text").textContent = message
  dialog.showModal()

  return new Promise((resolve, _reject) => {
    dialog.addEventListener(
      "close",
      () => {
        resolve(dialog.returnValue == "confirm")
      },
      { once: true }
    )
  })
})
