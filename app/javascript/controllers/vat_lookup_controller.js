import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["vatNumber", "name", "city", "zipcode", "address"];

  lookup() {
    const vatNumber = this.vatNumberTarget.value;

    fetch(`/accounts/vat_lookup?vat_number=${vatNumber}`)
      .then((response) => response.json())
      .then((data) => {
        if (!data.error) {
          this.nameTarget.value = data.name;
          this.cityTarget.value = data.city;
          this.zipcodeTarget.value = data.zipcode;
          this.addressTarget.value = data.address;
        } else {
          alert("VAT lookup failed: " + data.error);
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("Error during VAT lookup.");
      });
  }
}
