# Pin npm packages by running ./bin/importmap

pin "application", to: "application.js", preload: true
# pin "controllers/application.js", to: "javascript/controllers/application.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "vat_lookup", to: "vat_lookup.js", preload: true;
