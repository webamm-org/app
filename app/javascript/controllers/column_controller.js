import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['enumSelect', 'authorizationCheckbox']

  connect() {
    this.reRenderSelect2();
  }

  updateEnumField(event) {
    if(event.target.value === 'enum_column') {
      this.enumSelectTarget.classList.remove('hidden');
      this.authorizationCheckboxTarget.classList.remove('hidden');
      this.reRenderSelect2();
    } else {
      this.enumSelectTarget.classList.add('hidden');
      this.authorizationCheckboxTarget.classList.add('hidden');
    }
  }

  reRenderSelect2() {
    $('.select2-tags').select2({
      theme: 'classic',
      tags: true
    });
  }
}
