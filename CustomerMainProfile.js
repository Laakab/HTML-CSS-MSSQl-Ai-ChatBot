// document.addEventListener('DOMContentLoaded', async function() {
//     // Get the email from localStorage that was set during login
//     const userEmail = localStorage.getItem('userEmail');
    
//     if (userEmail) {
//         try {
//             // Get user details from database
//             const userData = await eel.get_user_by_email1(userEmail)();
            
//             if (userData) {
//                 // Display user name
//                 const userNameDisplay = document.getElementById('userNameDisplay');
//                 if (userNameDisplay) {
//                     userNameDisplay.textContent = userData.SIGN_UP_Name;
//                 }
                
//                 // Handle profile picture
//                 const userProfilePic = document.getElementById('userProfilePic');
//                 if (userProfilePic && userData.profilePic) {
//                     userProfilePic.src = userData.profilePic;
//                 }
//             }
//         } catch (error) {
//             console.error('Error fetching user data:', error);
//         }
//     }
    
//     // Add logout functionality
//     const logoutLink = document.getElementById('logoutLink');
//     if (logoutLink) {
//         logoutLink.addEventListener('click', function(e) {
//             e.preventDefault();
//             localStorage.removeItem('userEmail');
//             window.location.href = 'Main.html';
//         });
//     }
// }); 
document.addEventListener('DOMContentLoaded', async function() {
    console.log("DOMContentLoaded event fired"); // Debug log
    
    // Get the email from localStorage that was set during login
    const userEmail = localStorage.getItem('userEmail');
    console.log("Retrieved userEmail from localStorage:", userEmail); // Debug log
    
    if (localStorage.getItem('userEmail')) {
        try {
            console.log("Fetching user data for email:", userEmail); // Debug log
            // Get user details from database
            const userData = await eel.get_user_by_email1(userEmail)();
            console.log("Received userData from backend:", userData); // Debug log
            
            if (userData) {
                // Display user name
                const userNameDisplay = document.getElementById('userNameDisplay');
                if (userNameDisplay) {
                    userNameDisplay.textContent = userData.SIGN_UP_Name;
                    console.log("Set userNameDisplay to:", userData.SIGN_UP_Name); // Debug log
                } else {
                    console.error("userNameDisplay element not found"); // Debug log
                }
                
                // Handle profile picture
                const userProfilePic = document.getElementById('userProfilePic');
                if (userProfilePic) {
                    // Use default image if profilePic is not available
                    const defaultImage = './IMAGES/default-profile.jpg';
                    userProfilePic.src = userData.profilePic || defaultImage;
                    userProfilePic.alt = userData.SIGN_UP_Name + "'s profile picture";
                    userProfilePic.onerror = function() {
                        this.src = defaultImage;
                    };
                    console.log("Set profile picture src to:", userProfilePic.src); // Debug log
                } else {
                    console.error("userProfilePic element not found"); // Debug log
                }
            } else {
                console.error("No user data returned from backend"); // Debug log
            }
        } catch (error) {
            console.error('Error fetching user data:', error);
        }
    } else {
        console.error("No userEmail found in localStorage"); // Debug log
    }
    
    // Add logout functionality
    const logoutLink = document.getElementById('logoutLink');
    if (logoutLink) {
        logoutLink.addEventListener('click', function(e) {
            e.preventDefault();
            localStorage.removeItem('userEmail');
            window.location.href = 'Main.html';
        });
    } else {
        console.error("logoutLink element not found"); // Debug log
    }
});