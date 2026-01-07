function setupMemberForm() {
  const checkbox = document.getElementById("special_member_checkbox");
  const specialFields = document.getElementById("special_member_fields");

  if (checkbox && specialFields) {
    const hiddenClass = specialFields.dataset.hiddenClass || "hidden";

    const toggleFields = () => {
      if (checkbox.checked) {
        specialFields.classList.remove(hiddenClass);
        specialFields.style.display = "block";
      } else {
        specialFields.classList.add(hiddenClass);
        specialFields.style.display = "none";
      }
    };
    
    toggleFields();
    
    checkbox.removeEventListener("change", toggleFields);
    checkbox.addEventListener("change", toggleFields);
  }

  const table = document.querySelector(".schedule-table");
  if (table) {
    
    let isDragging = false;
    let shouldCheck = false;

    table.onmousedown = function(e) {
      const td = e.target.closest("td");
      if (!td) return;
      const targetCheckbox = td.querySelector("input[type='checkbox']");
      if (!targetCheckbox) return;

      if (e.target === targetCheckbox) {
        isDragging = true;
        shouldCheck = !targetCheckbox.checked;
        return; 
      }
      isDragging = true;
      shouldCheck = !targetCheckbox.checked;
      targetCheckbox.checked = shouldCheck;
    };

    table.onmouseover = function(e) {
      if (!isDragging) return;
      const td = e.target.closest("td");
      if (!td) return;
      const targetCheckbox = td.querySelector("input[type='checkbox']");
      if (targetCheckbox) {
        targetCheckbox.checked = shouldCheck;
      }
    };

    document.onmouseup = function() {
      isDragging = false;
    };
  }
}

document.addEventListener("DOMContentLoaded", setupMemberForm);
document.addEventListener("turbo:load", setupMemberForm);
document.addEventListener("turbolinks:load", setupMemberForm);