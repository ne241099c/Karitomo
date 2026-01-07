document.addEventListener("DOMContentLoaded", function() {
  const slots = document.querySelectorAll(".reservation-slot");
  const inputStartAt = document.getElementById("input-start-at");
  const displayStartAt = document.getElementById("display-start-at");
  const submitButton = document.getElementById("submit-button");
  const hoursSelect = document.getElementById("reservation-hours");

  if (slots.length > 0) {
    slots.forEach(slot => {
      slot.addEventListener("click", function(e) {
        e.preventDefault();

        slots.forEach(s => {
          s.style.color = "";
          s.style.fontWeight = "";
        });
        this.style.color = "red";
        this.style.fontWeight = "bold";

        if (inputStartAt) inputStartAt.value = this.dataset.datetime;
        if (displayStartAt) displayStartAt.textContent = this.dataset.display;
        if (submitButton) submitButton.disabled = false;

        if (hoursSelect) {
            const currentTd = this.closest('td');
            const currentTr = currentTd.closest('tr');
            const table = currentTr.closest('table');
            
            const cellIndex = currentTd.cellIndex;
            const rows = Array.from(table.querySelectorAll('tbody tr'));
            const startRowIndex = rows.indexOf(currentTr);

            let consecutiveHours = 0;

            for (let i = startRowIndex; i < rows.length; i++) {
                const row = rows[i];
                const cell = row.children[cellIndex];
                
                if (cell && cell.classList.contains('reservable')) {
                    consecutiveHours++;
                } else {
                    break;
                }
            }

            hoursSelect.innerHTML = '';

            const limit = Math.min(consecutiveHours, 12);
            
            if (limit > 0) {
                for (let h = 1; h <= limit; h++) {
                    const option = document.createElement('option');
                    option.value = h;
                    option.text = h + ' 時間';
                    hoursSelect.appendChild(option);
                }
            } else {
                const option = document.createElement('option');
                option.text = '予約不可';
                hoursSelect.appendChild(option);
                if (submitButton) submitButton.disabled = true;
            }
        }
      });
    });
  }
});