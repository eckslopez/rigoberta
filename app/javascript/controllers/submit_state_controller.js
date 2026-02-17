import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["button"]

    connect() {
        this.originalText = this.buttonTarget.value
    }

    submitting() {
        this.buttonTarget.disabled = true
        this.buttonTarget.value = "Saving..."
    }

    submitted() {
        this.buttonTarget.disabled = false
        this.buttonTarget.value = this.originalText
    }
    
}