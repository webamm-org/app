import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["connectionTypeSelect", "optionalCheckbox"]

  connect() {
    console.log("Association controller connected")
  }

  selectType(event) {
    console.log("selectType", event.target.value)

    switch (event.target.value) {
      case "has_one_assoc":
        this.connectionTypeSelectTarget.classList.remove("hidden")
        this.optionalCheckboxTarget.classList.remove("hidden")
        break;
      case "has_many_assoc":
        this.connectionTypeSelectTarget.classList.remove("hidden")
        this.optionalCheckboxTarget.classList.remove("hidden")
        break;
      case "has_many_and_belongs_to_many_assoc":
        this.connectionTypeSelectTarget.classList.remove("hidden")
        this.optionalCheckboxTarget.classList.add("hidden")
        break;
      case "parent_children_assoc":
        this.connectionTypeSelectTarget.classList.add("hidden")
        this.optionalCheckboxTarget.classList.add("hidden")
        break;
      default:
        this.connectionTypeSelectTarget.classList.add("hidden")
        this.optionalCheckboxTarget.classList.add("hidden")
        break;
    }
  }
}
