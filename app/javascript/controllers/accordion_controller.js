import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleTag(event) {
    event.preventDefault()

    $('#' + event.params.tab).toggleClass('hidden')
  }
}
