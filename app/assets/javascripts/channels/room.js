document.addEventListener("DOMContentLoaded", function() {
  const chatMessages = document.getElementById("chat-messages");
  
  if (!chatMessages) return;

  const reservationId = chatMessages.dataset.reservationId;
  const currentUserId = parseInt(chatMessages.dataset.currentUserId);

  App.cable.subscriptions.create({ channel: "RoomChannel", reservation_id: reservationId }, {
    connected: function() {
      console.log("Connected to Chat Room " + reservationId);
    },

    disconnected: function() {
    },

    received: function(data) {
      
      const isMyMessage = (data.member_id === currentUserId);
      const alignStyle = isMyMessage ? 'right' : 'left';
      const bgStyle = isMyMessage ? '#dcf8c6' : '#f1f0f0';

      const html = `
        <div style="margin-bottom: 5px; text-align: ${alignStyle};">
          <small>${data.member_name} (${data.created_at})</small><br>
          <span style="display: inline-block; padding: 5px 10px; border-radius: 10px; background-color: ${bgStyle};">
            ${data.message}
          </span>
        </div>
      `;

      chatMessages.insertAdjacentHTML('beforeend', html);
      
      chatMessages.scrollTop = chatMessages.scrollHeight;
    }
  });

  const chatForm = document.getElementById("chat-form");
  const messageInput = document.getElementById("chat-input");

  if (chatForm) {
    chatForm.addEventListener("submit", function() {
      setTimeout(() => {
        messageInput.value = "";
      }, 100);
    });
  }
});