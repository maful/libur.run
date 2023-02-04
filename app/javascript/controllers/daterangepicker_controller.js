import { Controller } from "@hotwired/stimulus"
import DateRangePicker from "flowbite-datepicker/DateRangePicker"

// Connects to data-controller="daterangepicker"
export default class extends Controller {
  static values = {
    format: { type: String, default: "yyyy-mm-dd" },
    minDate: { type: String, default: "" },
    autohide: { type: Boolean, default: true },
    todayBtn: { type: Boolean, default: false },
    disableWeekend: { type: Boolean, default: false },
  }

  connect() {
    let daysDisabled = []
    if (this.disableWeekendValue) {
      daysDisabled = [0, 6]
    }

    this.datepickers = new DateRangePicker(this.element, {
      autohide: this.autohideValue,
      format: this.formatValue,
      todayBtn: this.todayBtnValue,
      daysOfWeekDisabled: daysDisabled,
      minDate: this.minDateValue,
    })
  }

  disconnect() {
    this.datepickers.destroy()
  }

  get dates() {
    return this.datepickers.getDates("yyyy-mm-dd")
  }

  daysBetweenDates(startDate, endDate) {
    if (startDate.getTime() === endDate.getTime()) {
      if (startDate.getDay() === 0 || startDate.getDay() === 6) {
        return 0
      } else {
        return 1
      }
    }
    let count = 0
    let currentDate = new Date(startDate)
    while (currentDate <= endDate) {
      if (currentDate.getDay() !== 0 && currentDate.getDay() !== 6) {
        count++
      }
      currentDate.setDate(currentDate.getDate() + 1)
    }
    if (count === 0) {
      return 0
    }
    return count
  }
}
