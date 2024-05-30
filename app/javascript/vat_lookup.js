document.addEventListener("DOMContentLoaded", function () {
  const vatInput = document.getElementById("account_vat");
  const vatLookupButton = document.getElementById("vat_lookup_button");

  if (vatLookupButton) {
    vatLookupButton.addEventListener("click", function () {
      console.log("click");
      const vatNumber = vatInput.value;
      if (vatNumber.match(/^EL\d{9}$/)) {
        fetch(`/vat_lookup?vat=${vatNumber}`)
          .then((response) => response.json())
          .then((data) => {
            if (data.error) {
              alert(data.error);
            } else {
              document.getElementById("account_name").value = data.name;
              document.getElementById("account_city").value = data.city;
              document.getElementById("account_zipcode").value = data.zipcode;
              document.getElementById("account_address").value = data.address;
            }
          })
          .catch((error) => {
            console.error("Error fetching VAT data:", error);
          });
      } else {
        alert(
          "Invalid VAT format. It should start with 'EL' followed by 9 digits."
        );
      }
    });
  }
});
