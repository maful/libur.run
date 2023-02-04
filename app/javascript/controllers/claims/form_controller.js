import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"

// Connects to data-controller="claims--form"
export default class extends Controller {
  static targets = ["result", "targetForm", "template", "newClaim", "table"]

  connect() {
    this._insertNewForm()
  }

  async add(e) {
    e.preventDefault()

    if (this.hasNewClaimTarget) {
      this.objectId = this.newClaimTarget.dataset.objectId

      // form
      const dateInputId = `claim_group_claims_attributes_${this.objectId}_issue_date`
      this.dateInput = this.newClaimTarget.querySelector(
        `input[id=${dateInputId}]`
      )

      const typeSelectId = `claim_group_claims_attributes_${this.objectId}_claim_type_id`
      this.typeSelect = this.newClaimTarget.querySelector(
        `select[id=${typeSelectId}]`
      )
      this.typeSelectOption = this.typeSelect.selectedOptions[0]

      const amountInputId = `claim_group_claims_attributes_${this.objectId}_amount`
      this.amountInput = this.newClaimTarget.querySelector(
        `input[id=${amountInputId}]`
      )

      const noteInputId = `claim_group_claims_attributes_${this.objectId}_note`
      this.noteInput = this.newClaimTarget.querySelector(
        `textarea[id=${noteInputId}]`
      )

      const validateForm = await this._validateNewClaim()
      if (validateForm) {
        this._createRow()
        this._insertNewForm()
      }
    } else {
      this._insertNewForm()
    }
  }

  remove(e) {
    const buttonElm = e.currentTarget
    const buttonId = buttonElm.id.split("_")[2]
    // find the row
    const claimRow = this.tableTarget.querySelector(`tr[id="row_${buttonId}"]`)
    if (claimRow) {
      claimRow.remove()
    }
    const claimForm = this.resultTarget.querySelector(
      `div[data-object-id="${buttonId}"]`
    )
    if (claimForm) {
      claimForm.remove()
    }
  }

  _insertNewForm() {
    const content = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      new Date().getTime().toString()
    )
    this.targetFormTarget.insertAdjacentHTML("afterbegin", content)
  }

  async _validateNewClaim() {
    const body = {
      claim: {
        note: this.noteInput.value,
        issue_date: this.dateInput.value,
        amount: this.amountInput.value,
        claim_type_id: this.typeSelectOption.value,
      },
    }
    const response = await post("/claims/validate_claim", {
      body,
      responseKind: "json",
    })

    if (response.ok) {
      return true
    } else {
      const json = await response.json
      const fields = [
        { name: "issue_date", label: "Issue date", elm: this.dateInput },
        { name: "note", label: "Note", elm: this.noteInput },
        { name: "amount", label: "Amount", elm: this.amountInput },
        { name: "claim_type", label: "Claim type", elm: this.typeSelect },
      ]
      for (let field of fields) {
        if (json[field.name]) {
          let errElm = this._hasErrorElement(
            field.elm.parentElement,
            "p.input-group__error-message"
          )
          const errorMessage = `${field.label} ${json[field.name]}`
          if (errElm) {
            errElm.textContent = errorMessage
          } else {
            errElm = document.createElement("p")
            errElm.classList.add("input-group__error-message")
            errElm.textContent = errorMessage
            field.elm.insertAdjacentElement("afterend", errElm)
          }
        } else {
          const errMessageElm = this._hasErrorElement(
            field.elm.parentElement,
            "p.input-group__error-message"
          )
          if (errMessageElm) {
            errMessageElm.remove()
          }
        }
      }

      return false
    }
  }

  _hasErrorElement(element, selector) {
    return element.querySelector(selector)
  }

  _createRow() {
    // add the form to the table
    const tr = document.createElement("tr")
    tr.id = `row_${this.objectId}`

    const columnNo = document.createElement("td")
    const buttonRemoveClaim = document.createElement("button")
    buttonRemoveClaim.type = "button"
    buttonRemoveClaim.id = `button_claim_${this.objectId}`
    buttonRemoveClaim.dataset.action = "claims--form#remove"
    buttonRemoveClaim.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5"><path stroke-linecap="round" stroke-linejoin="round" d="m9.75 9.75 4.5 4.5m0-4.5-4.5 4.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/></svg>`
    columnNo.appendChild(buttonRemoveClaim)
    tr.appendChild(columnNo)

    const columnDate = document.createElement("td")
    columnDate.textContent = this.dateInput.value
    tr.appendChild(columnDate)

    const columnType = document.createElement("td")
    columnType.textContent = this.typeSelectOption.label
    tr.appendChild(columnType)

    const columnAmount = document.createElement("td")
    columnAmount.style.textAlign = "right"
    columnAmount.textContent = this.amountInput.value
    tr.appendChild(columnAmount)

    this.tableTarget.insertAdjacentElement("beforeend", tr)

    // move the previous form to the result target
    this.resultTarget.insertAdjacentElement("beforeend", this.newClaimTarget)
  }
}
