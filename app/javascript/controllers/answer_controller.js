import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["answer", "form", "animalCard"]
  static values = {
    correctAnswer: Number,
    guess: Number
  }

  connect() {}

  select(event) {
    const selectedAnswer = parseInt(event.currentTarget.value)
    const answerElement = event.currentTarget.parentElement

    if (selectedAnswer === this.correctAnswerValue) {
      // Correct answer animation
      answerElement.classList.add("correct-answer")

      // Add card collection animation after a short delay
      setTimeout(() => {
        if (this.hasAnimalCardTarget) {
          this.animalCardTarget.classList.add("card-collected")
          // Create overlay for dimming effect
          const overlay = document.createElement("div")
          overlay.classList.add("collection-overlay")
          document.body.appendChild(overlay)

          // Remove overlay after animation completes
          setTimeout(() => {
            overlay.remove()
          }, 2500)
        }
      }, 1000) // Start card animation after 1s (during the answer animation)

      setTimeout(() => {
        this.formTarget.requestSubmit()
      }, 3000)
    } else {
      // Incorrect answer animation
      answerElement.classList.add("incorrect-answer")

      if (this.guessValue === 2) {
        this.answerTargets.forEach((answer) => {
          if (parseInt(answer.value) === this.correctAnswerValue) {
            answer.disabled = true
          }
        })

        setTimeout(() => {
          this.formTarget.requestSubmit()
        }, 3000)
      } else {
        this.guessValue += 1
      }
    }
  }
}
