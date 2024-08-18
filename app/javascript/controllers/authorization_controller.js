import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  selectAuthentication(event) {
    event.preventDefault();

    let frame = document.querySelector('turbo-frame#' + event.params.frame);
    const urlObj = new URL(frame.src);
    const params = urlObj.searchParams;
    params.set('model_ids', $(event.target).val().join(','));
    urlObj.search = params.toString();
    const updatedUrl = urlObj.toString();

    frame.src = updatedUrl;
    frame.reload()
  }
}
