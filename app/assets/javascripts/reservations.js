document.addEventListener("turbo:load", function() {
  const slots = document.querySelectorAll(".reservation-slot");
  const inputStartAt = document.getElementById("input-start-at");
  const displayStartAt = document.getElementById("display-start-at");
  const submitButton = document.getElementById("submit-button");

  if (slots.length > 0) {
    slots.forEach(slot => {
      slot.addEventListener("click", function(e) {
        e.preventDefault();

        slots.forEach(s => s.classList.remove("selected"));
        
        this.classList.add("selected");

        if (inputStartAt) inputStartAt.value = this.dataset.datetime;
        if (displayStartAt) displayStartAt.textContent = this.dataset.display;
        
        if (submitButton) submitButton.disabled = false;
      });
    });
  }
});