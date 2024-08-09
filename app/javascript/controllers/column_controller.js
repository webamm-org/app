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


// connect() {
//   $(document).ready(function() {
//     $('.select2').select2({
//       theme: 'classic'
//     });
//   });

//   $(document).ready(function() {
//     $('.select2-tags').select2({
//       theme: 'classic',
//       tags: true
//     });
//   });

//   const currentSelection = $('#database_schema_column_column_value').val();

//   if(currentSelection === 'enum') {
//     $('#enum-values-select').removeClass('invisible');
//     $('#enum-authorization').removeClass('invisible');
//   }

//   $('.select2').on('select2:select', function (e) {
//     const eventField = e.currentTarget.name;

//     if(eventField === 'database_schema_column[column_value]') {
//       const fieldValue = e.currentTarget.value;

//       if(fieldValue === 'enum') {
//         $('#enum-values-select').removeClass('invisible');
//         $('#enum-authorization').removeClass('invisible');
//       } else {
//         $('#enum-values-select').addClass('invisible');
//         $('#enum-authorization').addClass('invisible');
//       }
//     }
//   });
// }
