import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleOption(event) {
    event.preventDefault();

    const tabId = '#' + event.params.tab;

    $(tabId).toggleClass('hidden');
  }

  selectTab(event) {
    event.preventDefault();

    const formId = '#' + event.params.form;

    $('.resource-form-option').addClass('hidden');
    $('.tab-button').removeClass('border-b-blue-600');
    $('.tab-button').removeClass('text-gray-900');
    $(event.target).addClass('border-b-blue-600');
    $(event.target).addClass('text-gray-900');
    $(formId).removeClass('hidden');
  }
}
