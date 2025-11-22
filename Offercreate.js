document.addEventListener('DOMContentLoaded', function() {
    // Image preview functionality
    const offerImageInput = document.getElementById('offerImage');
    const offerImagePreview = document.getElementById('offerImagePreview');
    
    offerImageInput.addEventListener('change', function() {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                offerImagePreview.innerHTML = `<img src="${e.target.result}" alt="Offer Preview">`;
            }
            
            reader.readAsDataURL(file);
        } else {
            offerImagePreview.innerHTML = '';
        }
    });
    
    // Load products for dropdown
    function loadProducts() {
        eel.get_products()(function(products) {
            const productSelect = document.getElementById('offerProduct');
            
            products.forEach(product => {
                const option = document.createElement('option');
                option.value = product.ID;
                option.textContent = product.name;
                productSelect.appendChild(option);
            });
        });
    }
    
    // Save offer button click handler
    document.getElementById('saveOfferBtn').addEventListener('click', function() {
        const offerTitle = document.getElementById('offerTitle').value;
        const offerProduct = document.getElementById('offerProduct').value;
        const offerDescription = document.getElementById('offerDescription').value;
        const offerDiscount = document.getElementById('offerDiscount').value;
        const offerImage = document.getElementById('offerImage').files[0];
        const offerStartDate = document.getElementById('offerStartDate').value;
        const offerEndDate = document.getElementById('offerEndDate').value;
        const offerStatus = document.getElementById('offerStatus').value;
        
        if (!offerTitle || !offerProduct || !offerDiscount || !offerImage || !offerStartDate || !offerEndDate) {
            alert('Please fill all required fields');
            return;
        }
        
        // Convert image to base64
        const reader = new FileReader();
        reader.onload = function(e) {
            const imageBase64 = e.target.result.split(',')[1]; // Remove the data URL prefix
            
            // Call Python function to save offer
            eel.save_offer(
                offerTitle,
                parseInt(offerProduct),
                offerDescription,
                parseInt(offerDiscount),
                imageBase64,
                offerStartDate,
                offerEndDate,
                offerStatus
            )(function(response) {
                if (response.success) {
                    alert('Offer saved successfully!');
                    loadOffers();
                    resetForm();
                } else {
                    alert('Error saving offer: ' + response.error);
                }
            });
        };
        reader.readAsDataURL(offerImage);
    });
    
    // Load existing offers
    function loadOffers() {
        eel.get_offers()(function(offers) {
            const tableBody = document.getElementById('offersTableBody');
            tableBody.innerHTML = '';
            
            if (offers.length === 0) {
                tableBody.innerHTML = '<tr><td colspan="6" style="text-align: center;">No offers found</td></tr>';
                return;
            }
            
            // Get product names for display
            eel.get_products()(function(products) {
                const productMap = {};
                products.forEach(product => {
                    productMap[product.ID] = product.name;
                });
                
                offers.forEach(offer => {
                    const row = document.createElement('tr');
                    
                    // Format dates
                    const startDate = new Date(offer.start_date).toLocaleDateString();
                    const endDate = new Date(offer.end_date).toLocaleDateString();
                    
                    row.innerHTML = `
                        <td>${offer.title}</td>
                        <td>${productMap[offer.product_id] || 'Unknown Product'}</td>
                        <td><span class="discount-badge">${offer.discount}% OFF</span></td>
                        <td>${startDate} - ${endDate}</td>
                        <td class="status-${offer.status}">${offer.status.charAt(0).toUpperCase() + offer.status.slice(1)}</td>
                        <td>
                            <button class="action-btn edit-btn" data-id="${offer.id}">Edit</button>
                            <button class="action-btn delete-btn" data-id="${offer.id}">Delete</button>
                        </td>
                    `;
                    
                    tableBody.appendChild(row);
                });
                
                // Add event listeners to action buttons
                document.querySelectorAll('.edit-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const offerId = this.getAttribute('data-id');
                        editOffer(offerId);
                    });
                });
                
                document.querySelectorAll('.delete-btn').forEach(btn => {
                    btn.addEventListener('click', function() {
                        const offerId = this.getAttribute('data-id');
                        if (confirm('Are you sure you want to delete this offer?')) {
                            deleteOffer(offerId);
                        }
                    });
                });
            });
        });
    }
    
    // Edit offer
    function editOffer(offerId) {
        eel.get_offer_by_id(offerId)(function(offer) {
            if (offer) {
                document.getElementById('offerTitle').value = offer.title;
                document.getElementById('offerProduct').value = offer.product_id;
                document.getElementById('offerDescription').value = offer.description;
                document.getElementById('offerDiscount').value = offer.discount;
                document.getElementById('offerStartDate').value = offer.start_date.split('T')[0];
                document.getElementById('offerEndDate').value = offer.end_date.split('T')[0];
                document.getElementById('offerStatus').value = offer.status;
                
                // Show image preview
                if (offer.image) {
                    document.getElementById('offerImagePreview').innerHTML = 
                        `<img src="data:image/jpeg;base64,${offer.image}" alt="Offer Preview">`;
                }
                
                // Change save button to update
                const saveBtn = document.getElementById('saveOfferBtn');
                saveBtn.textContent = 'Update Offer';
                saveBtn.setAttribute('data-offer-id', offerId);
            }
        });
    }
    
    // Delete offer
    function deleteOffer(offerId) {
        eel.delete_offer(offerId)(function(response) {
            if (response.success) {
                alert('Offer deleted successfully');
                loadOffers();
            } else {
                alert('Error deleting offer: ' + response.error);
            }
        });
    }
    
    // Reset form
    function resetForm() {
        document.getElementById('offerTitle').value = '';
        document.getElementById('offerProduct').value = '';
        document.getElementById('offerDescription').value = '';
        document.getElementById('offerDiscount').value = '';
        document.getElementById('offerImage').value = '';
        document.getElementById('offerImagePreview').innerHTML = '';
        document.getElementById('offerStartDate').value = '';
        document.getElementById('offerEndDate').value = '';
        document.getElementById('offerStatus').value = 'active';
        
        const saveBtn = document.getElementById('saveOfferBtn');
        saveBtn.textContent = 'Save Offer';
        saveBtn.removeAttribute('data-offer-id');
    }
    
    // Initialize date inputs with today's date
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('offerStartDate').value = today;
    
    // Load products and offers when page loads
    loadProducts();
    loadOffers();
});