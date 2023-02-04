import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import Calendar, { TZDate } from "@toast-ui/calendar"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["container", "title"]

  async connect() {
    this.calendar = new Calendar(this.containerTarget, this._calendarOptions)
    await this.createEvents()
    this.setCalenderTitle()
  }

  setCalenderTitle() {
    const baseDate = this.calendar.getDate()
    const dateYear = baseDate.toDate().toLocaleString("default", {
      month: "long",
      year: "numeric",
    })
    this.titleTarget.textContent = dateYear
  }

  async nextMonth() {
    this.calendar.next()
    await this.createEvents()
    this.setCalenderTitle()
  }

  async prevMonth() {
    this.calendar.prev()
    await this.createEvents()
    this.setCalenderTitle()
  }

  async createEvents() {
    const events = await this._getEvents()
    this.calendar.clear()
    this.calendar.createEvents(events)
  }

  async _getEvents() {
    const response = await get("/calendar", {
      query: {
        "calendar[start_date]": this._startDate,
        "calendar[end_date]": this._endDate,
        "calendar[base_date]": this._baseDate,
      },
      responseKind: "json",
    })

    if (response.ok) {
      const body = await response.json

      const leaves = body["leaves"].map((leave) => {
        return {
          id: leave["public_id"],
          calendarId: "leave",
          title: leave["user"]["name"],
          isAllday: true,
          start: new TZDate(leave["start_date"]),
          end: new TZDate(leave["end_date"]),
          category: "allday",
          isReadOnly: true,
          raw: leave,
        }
      })

      const birthdays = body["birthdays"].map((birthday) => {
        const year = new Date().getFullYear()
        const date = new Date(birthday["birthday"])
        const birthdayDate = new TZDate(year, date.getMonth(), date.getDate())
        return {
          id: birthday["id"],
          calendarId: "birthday",
          title: birthday["name"],
          isAllday: true,
          start: birthdayDate,
          end: birthdayDate,
          category: "allday",
          isReadOnly: true,
        }
      })

      return [...leaves, ...birthdays]
    } else {
      return []
    }
  }

  get _calendarOptions() {
    return {
      usageStatistics: false,
      defaultView: "month",
      useDetailPopup: true,
      isReadOnly: true,
      calendars: [
        {
          id: "leave",
          name: "Leaves Calendar",
          color: "#FFFFFF",
          backgroundColor: "#2970FF",
          borderColor: "#00359E",
        },
        {
          id: "birthday",
          name: "Birthday Calendar",
          color: "#FFFFFF",
          backgroundColor: "#039855",
          borderColor: "#054F31",
        },
        {
          id: "holiday",
          name: "Public Holiday Calendar",
          backgroundColor: "#D92D20",
        },
      ],
      theme: {
        common: {
          today: {
            color: "#FFFFFF",
          },
          border: "1px solid #D0D5DD",
          dayName: { color: "#101828" },
          holiday: { color: "#101828" },
          saturday: { color: "#101828" },
        },
        month: {
          dayExceptThisMonth: { color: "#98A2B3" },
          holidayExceptThisMonth: { color: "#98A2B3" },
          weekend: { backgroundColor: "white" },
        },
      },
      template: {
        popupDetailDate({ start, end }) {
          const options = { year: "numeric", month: "short", day: "numeric" }
          const startDate = new Date(start).toLocaleString("en-GB", options)
          const endDate = new Date(end).toLocaleString("en-GB", options)
          return `${startDate} - ${endDate}`
        },
        popupDetailState({ calendarId, raw }) {
          if (calendarId === "leave") {
            const leaveTypeName = raw["leave_type"]["name"]
            if (raw["half_day"]) {
              return `${leaveTypeName} (${raw["half_day_time"]})`
            } else {
              return leaveTypeName
            }
          } else if (calendarId === "birthday") {
            return "Happy Birthday"
          } else {
            return "Busy"
          }
        },
      },
    }
  }

  get _startDate() {
    const dateStart = this.calendar.getDateRangeStart()
    return `${dateStart.getFullYear()}-${
      dateStart.getMonth() + 1
    }-${dateStart.getDate()}`
  }

  get _endDate() {
    const dateEnd = this.calendar.getDateRangeEnd()
    return `${dateEnd.getFullYear()}-${
      dateEnd.getMonth() + 1
    }-${dateEnd.getDate()}`
  }

  get _baseDate() {
    const baseDate = this.calendar.getDate()
    return `${baseDate.getFullYear()}-${
      baseDate.getMonth() + 1
    }-${baseDate.getDate()}`
  }
}
