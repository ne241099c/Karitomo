document.addEventListener("DOMContentLoaded", function() {
  const checkbox = document.getElementById("special_member_checkbox");
  const specialFields = document.getElementById("special_member_fields");

  if (checkbox && specialFields) {
    const toggleFields = () => {
      if (checkbox.checked) {
        specialFields.style.display = "block";
      } else {
        specialFields.style.display = "none";
      }
    };
    
    toggleFields();
    
    checkbox.addEventListener("change", toggleFields);
  }

  const table = document.querySelector(".schedule-table");
  
  if (table) {
    let isDragging = false;
    let shouldCheck = false;

    table.addEventListener("mousedown", function(e) {
      const td = e.target.closest("td");
      if (!td) return;

      const targetCheckbox = td.querySelector("input[type='checkbox']");
      if (!targetCheckbox) return;

      isDragging = true;
      
      shouldCheck = !targetCheckbox.checked;
      targetCheckbox.checked = shouldCheck;

      e.preventDefault();
    });

    table.addEventListener("mouseover", function(e) {
      if (!isDragging) return;

      const td = e.target.closest("td");
      if (!td) return;

      const targetCheckbox = td.querySelector("input[type='checkbox']");
      if (targetCheckbox) {
        targetCheckbox.checked = shouldCheck;
      }
    });

    document.addEventListener("mouseup", function() {
      isDragging = false;
    });
  }
});