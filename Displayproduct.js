function loadProducts() {
    eel.get_products()(function (products) {
      const productList = document.getElementById('productsGrid11');
      productList.innerHTML = '';
      products.forEach(product => {
        disc=product.productDiscount/100;
        dis=product.productPrice*disc;
        discount=product.productPrice-dis;
        const card = document.createElement('div');
        card.className = 'product-card';
        card.innerHTML = `
        <img src="${product.productImage}" alt="${product.name}" class="product-image">
                  <h3>Title : ${product.name}</h3>
                  <p> Discription : ${product.productDescription}</p>
                   <p class="dress-card-para">Category: ${product.category}</p>
                              <p class="dress-card-para" style="text-decoration: line-through;">Price: ${product.productPrice}</p>
                              <p class="dress-card-para">DisCount Price: ${discount}</p>
                              <button onclick="showProductDetails('${product.name}')" class="update-btn">Show Product Details</button>
                  `;
        productList.appendChild(card);
      });
    });
  }

  // function BuYNoW(Name) {
  //   // Redirect to edit page or open modal with product data
  //   // You'll need to create an edit page or modal
  //   window.location.href = `BuyNow.html?id=${Name}`;
  // }
