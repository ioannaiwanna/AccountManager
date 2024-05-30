# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "controllers", to: "controllers.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "https://unpkg.com/stimulus-loading"
pin "./vat_lookup", to: "vat_lookup.js";
