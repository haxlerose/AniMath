import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["answer", "form"]
  static values = {
    correctAnswer: Number
  }

  connect() {
    console.log("Answer controller connected")
  }

  select(event) {
    const selectedAnswer = parseInt(event.currentTarget.value)
    const answerElement = event.currentTarget.parentElement

    if (selectedAnswer === this.correctAnswerValue) {
      // Correct answer animation
      answerElement.classList.add("correct-answer")
    } else {
      // Incorrect answer animation
      answerElement.classList.add("incorrect-answer")
    }

    setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 3000)
  }
}
