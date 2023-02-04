import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="leaves--form"
export default class extends Controller {
  static targets = ["halfDay"]
  static outlets = ["daterangepicker"]

  connect() {
    setTimeout(() => {
      this.leaveDatesController = this.daterangepickerOutlet
      this.leaveDatesElement = this.daterangepickerOutletElement
      this.populateDatepickerInputs()
    }, 0)
  }

  disconnect() {
    this.datepickerInputElements.forEach((elm) => {
      elm.removeEventListener(
        "changeDate",
        this.handleDatepickerEvent.bind(this)
      )
    })
  }

  populateDatepickerInputs() {
    this.datepickerInputElements = this.leaveDatesElement.querySelectorAll(
      "input.datepicker-input"
    )
    this.datepickerInputElements.forEach((elm) => {
      elm.addEventListener("changeDate", this.handleDatepickerEvent.bind(this))
    })
  }

  handleDatepickerEvent(e) {
    const dates = this.leaveDatesController.dates
    const someUndefined = (v) => v === undefined
    if (dates.some(someUndefined)) {
      this.halfDayTarget.classList.toggle("input-group--hidden")
    } else {
      const startDate = new Date(dates[0])
      const endDate = new Date(dates[1])
      const totalDays = this.leaveDatesController.daysBetweenDates(
        startDate,
        endDate
      )
      // if the dates are the same
      if (totalDays === 1) {
        this.halfDayTarget.classList.remove("input-group--hidden")
      } else {
        this.halfDayTarget.classList.add("input-group--hidden")
      }
    }
  }
}
