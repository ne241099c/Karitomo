// toggle_member_fields.js
// Handles the toggling of special member fields.
// Supports standard load, Turbolinks, and Turbo Drive events.

function initToggleFields() {
  const checkbox = document.getElementById("special_member_checkbox");
  const specialFields = document.getElementById("special_member_fields");

  if (checkbox && specialFields) {
    // Initial check
    toggleFields(checkbox, specialFields);

    // Remove existing event listener to avoid duplicates if re-initialized (though initToggleFields is usually safe)
    checkbox.removeEventListener("change", handleCheckboxChange);
    checkbox.addEventListener("change", handleCheckboxChange);
  }
}

function handleCheckboxChange(event) {
  const checkbox = event.target;
  // We need to find the specialFields element again or pass it.
  // For simplicity, finding it by ID is safe here since IDs are unique.
  const specialFields = document.getElementById("special_member_fields");
  if (specialFields) {
    toggleFields(checkbox, specialFields);
  }
}

function toggleFields(checkbox, fields) {
  if (checkbox.checked) {
    fields.classList.remove("hidden");
  } else {
    fields.classList.add("hidden");
  }
}

// Support for various Rails navigation events
document.addEventListener("DOMContentLoaded", initToggleFields);
document.addEventListener("turbo:load", initToggleFields);
document.addEventListener("turbolinks:load", initToggleFields);
