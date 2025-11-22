// DOM elements
const chatIcon = document.getElementById('chatIcon');
const chatContainer = document.getElementById('chatContainer');
const closeChat = document.getElementById('closeChat');
const chatMessages = document.getElementById('chatMessages');
const messageInput = document.getElementById('messageInput');
const sendBtn = document.getElementById('sendBtn');
const unreadCount = document.getElementById('unreadCount');
const adminDropdown = document.getElementById('adminDropdown');

// State
let currentUser = null;
let selectedAdminID = null;
let chatOpen = false;
let pollInterval = null;
let unreadMessages = 0;
let currentMessages = []; // Store current messages for reference

// Initialize chat when page loads
document.addEventListener('DOMContentLoaded', async () => {
    // Load admins first
    await loadAdmins();
    
    // Enable admin selection
    adminDropdown.addEventListener('change', async (e) => {
        selectedAdminID = e.target.value;
        if (selectedAdminID) {
            messageInput.disabled = false;
            sendBtn.disabled = false;
            await loadMessages();
        } else {
            messageInput.disabled = true;
            sendBtn.disabled = true;
            chatMessages.innerHTML = '';
        }
    });
});

async function loadAdmins() {
    try {
        adminDropdown.innerHTML = '<option value="">Select an admin to chat with</option>';
        
        // Get all admins from database
        const admins = await eel.get_all_admins()();
        
        if (!admins || admins.length === 0) {
            adminDropdown.innerHTML = '<option value="">No admins available</option>';
            return;
        }
        
        // Populate dropdown with admin options
        admins.forEach(admin => {
            const option = document.createElement('option');
            option.value = admin.SUserID;
            option.textContent = admin.SIGN_UP_Name;
            adminDropdown.appendChild(option);
        });
    } catch (error) {
        console.error("Error loading admins:", error);
        alert("Failed to load admin list. Please try again later.");
    }
}

// Toggle chat window
function toggleChat() {
    chatOpen = !chatOpen;
    chatContainer.style.display = chatOpen ? 'flex' : 'none';
    
    if (chatOpen) {
        // Mark messages as read when opening chat
        unreadMessages = 0;
        updateUnreadCount();
        loadMessages();
    }
}

// Load messages from server
async function loadMessages() {
    if (!selectedAdminID) return;
    
    try {
        // Get current user ID from session or local storage
        const userEmail = localStorage.getItem('userEmail');
        if (!userEmail) {
            console.error("User not logged in");
            return;
        }
        
        // Get user details from database
        const user = await eel.get_user_by_email(userEmail)();
        if (!user) return;
        currentUser = user;
        
        const messages = await eel.get_messages(user.SUserID, selectedAdminID)();
        currentMessages = messages; // Store messages for reference
        renderMessages(messages);
        
        // Check for unread messages
        const counts = await eel.get_unread_counts(user.SUserID)();
        unreadMessages = counts[selectedAdminID] || 0;
        updateUnreadCount();
    } catch (error) {
        console.error('Error loading messages:', error);
    }
}

// Render messages to the chat window
function renderMessages(messages) {
    chatMessages.innerHTML = '';
    
    if (messages.length === 0) {
        chatMessages.innerHTML = '<div class="no-messages">No messages yet. Start the conversation!</div>';
        return;
    }
    
    messages.forEach(msg => {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message');
        messageDiv.classList.add(msg.sender_id === currentUser?.SUserID ? 'user-message' : 'admin-message');
        
        // Add data attribute for message ID
        messageDiv.dataset.messageId = msg.id;
        
        // Only show edit/delete options for user's own messages
        const actionButtons = msg.sender_id === currentUser?.SUserID ? `
            <div class="message-actions">
                <button class="edit-message" data-message-id="${msg.id}">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="delete-message" data-message-id="${msg.id}">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        ` : '';
        
        messageDiv.innerHTML = `
            <div class="message-info">
                <span class="sender-name">${msg.sender_name}</span>
                <span class="message-time">${formatTime(msg.timestamp)}</span>
            </div>
            <div class="message-text">${msg.text}</div>
            ${actionButtons}
        `;
        
        chatMessages.appendChild(messageDiv);
    });
    
    // Add event listeners for edit and delete buttons
    document.querySelectorAll('.edit-message').forEach(btn => {
        btn.addEventListener('click', handleEditMessage);
    });
    
    document.querySelectorAll('.delete-message').forEach(btn => {
        btn.addEventListener('click', handleDeleteMessage);
    });
    
    // Scroll to bottom
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

// Format time for display
function formatTime(timestamp) {
    const date = new Date(timestamp);
    return date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
}

async function sendMessage() {
    const message = messageInput.value.trim();
    
    if (!message || !selectedAdminID) {
        alert("Please select an admin and enter a message");
        return;
    }
    
    if (message.length > 1000) {
        alert("Message is too long (max 1000 characters)");
        return;
    }
    
    try {
        // Get current user ID from session or local storage
        const userEmail = localStorage.getItem('userEmail');
        if (!userEmail) {
            console.error("User not logged in");
            return;
        }
        
        // Get user details from database
        const user = await eel.get_user_by_email(userEmail)();
        if (!user) return;
        
        // Send message to database
        const success = await eel.send_message(user.SUserID, selectedAdminID, message)();
        
        if (success) {
            // Clear input and refresh messages
            messageInput.value = '';
            await loadMessages();
        } else {
            alert("Failed to send message. You may only message admins.");
        }
    } catch (error) {
        console.error("Error sending message:", error);
        alert("Failed to send message. Please try again.");
    }
}

// Handle message deletion
async function handleDeleteMessage(e) {
    const messageId = e.target.closest('button').dataset.messageId;
    const confirmDelete = confirm("Are you sure you want to delete this message?");
    
    if (confirmDelete) {
        try {
            const success = await eel.delete_message(messageId)();
            if (success) {
                await loadMessages(); // Refresh messages
            } else {
                alert("Failed to delete message");
            }
        } catch (error) {
            console.error("Error deleting message:", error);
            alert("Failed to delete message. Please try again.");
        }
    }
}

// Handle message editing
async function handleEditMessage(e) {
    const messageId = e.target.closest('button').dataset.messageId;
    const message = currentMessages.find(m => m.id == messageId);
    
    if (!message) return;
    
    const newText = prompt("Edit your message:", message.text);
    if (newText && newText.trim() !== message.text) {
        try {
            const success = await eel.update_message(messageId, newText.trim())();
            if (success) {
                await loadMessages(); // Refresh messages
            } else {
                alert("Failed to update message");
            }
        } catch (error) {
            console.error("Error updating message:", error);
            alert("Failed to update message. Please try again.");
        }
    }
}

// Update unread message count display
function updateUnreadCount() {
    if (unreadMessages > 0 && !chatOpen) {
        unreadCount.textContent = unreadMessages;
        unreadCount.style.display = 'flex';
    } else {
        unreadCount.style.display = 'none';
    }
}

// Event listeners
chatIcon.addEventListener('click', toggleChat);
closeChat.addEventListener('click', toggleChat);
sendBtn.addEventListener('click', sendMessage);
messageInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') sendMessage();
});