const menuData = [
  {
    label: 'Contact',
    url: '/contact.html',
    externalUrl: false,
    mobileMenuFlag: true,
    logo: false,
    logoSrc: '',
    iconClass: 'fas fa-address-book',
    floatLeft: false,
    hasSubmenu: false,
  },
  {
    label: 'Media',
    url: '#',
    externalUrl: false,
    mobileMenuFlag: true,
    logo: false,
    logoSrc: '',
    iconClass: 'fas fa-film',
    floatLeft: false,
    hasSubmenu: true,
    submenu: [
      {
        label: 'Images',
        url: '/images.html',
        externalUrl: false,
        mobileMenuFlag: true,
        floatLeft: true,
        iconClass: 'fas fa-brain',
      },
      {
        label: 'Movies',
        url: '/movies.html',
        externalUrl: false,
        mobileMenuFlag: true,
        floatLeft: true,
        conClass: 'fas fa-brain',
      }
    ]
  },
  {
    label: 'About Us',
    url: '/aboutus.html',
    externalUrl: false,
    mobileMenuFlag: true,
    logo: false,
    logoSrc: '',
    iconClass: 'fas fa-guitar',
    floatLeft: false,
    hasSubmenu: false
  },
  {
    label: 'Blog',
    url: '/blog.html',
    externalUrl: false,
    mobileMenuFlag: true,
    logo: false,
    logoSrc: '',
    iconClass: 'fas fa-newspaper',
    floatLeft: false,
    hasSubmenu: false
  },
  {
    label: '',
    url: '/foggykitchen.html',
    externalUrl: false,
    mobileMenuFlag: false,
    logo: true,
    logoSrc: 'img/foggykitchen_logo.png',
    iconClass: 'logo-img',
    floatLeft: true,
    hasSubmenu: false,
  },
];

const topMenu = document.getElementById('top-menu');
const content = document.getElementById('content');

menuData.forEach(item => {
  const link = document.createElement('a');

  if (item.logo) {
    
    var logoDiv = document.createElement("div");
    logoDiv.classList.add("logo-div");
    
    var logoImg = document.createElement("img");
    logoImg.src = item.logoSrc;
    logoImg.classList.add(item.iconClass);
    logoImg.href = item.url;
    if (item.externalUrl) {
      logoLink = document.createElement('a');
      logoLink.classList.add("logo-link");
      logoLink.setAttribute('target', '_blank');
      logoLink.setAttribute('rel', 'noopener');
      logoLink.setAttribute('href', item.url);
      logoLink.appendChild(logoImg);
      logoDiv.appendChild(logoLink)
    } else {
      logoImg.addEventListener('click', event => {
          event.preventDefault();
          const url = event.target.href;
          redirectToAnotherPage(url);
      });
      logoDiv.appendChild(logoImg);
    }
    topMenu.appendChild(logoDiv);
  } else {
    if (item.externalUrl) {
      link.setAttribute('target', '_blank');
      link.setAttribute('rel', 'noopener');
      link.setAttribute('href', item.url);
    }
    link.textContent = item.label;
    link.href = item.url;
  }

  if (item.hasSubmenu) {
    link.setAttribute('data-submenu', '');
  }

  if (item.floatLeft) {
    link.classList.add("aleft")
  }

  let iconElement = document.createElement("i");
  iconElement.setAttribute("class", item.iconClass);
  // iconElement.classList.add("fas", "menu-icon");
  link.insertBefore(iconElement,link.firstChild);

  topMenu.appendChild(link);

  if (item.hasSubmenu) {
    link.setAttribute('data-submenu', '');
  }

  if (item.submenu) {
    const chevronDown = document.createElement('i');
    chevronDown.classList.add('fas', 'fa-chevron-down', 'chevron-down');
    link.appendChild(chevronDown);

    const submenu = document.createElement('ul');
    submenu.classList.add('top-menu');
    item.submenu.forEach(submenuItem => {
      const submenuLink = document.createElement('a');

      if (submenuItem.floatLeft) {
        submenuLink.classList.add("aleft")
      }

      submenuLink.textContent = submenuItem.label;
      submenuLink.href = submenuItem.url;

      const submenuItemElement = document.createElement('li');
      submenuItemElement.appendChild(submenuLink);
      submenu.appendChild(submenuItemElement);
    });

    link.appendChild(submenu);
  }
});

// Add event listeners to the top-level <a> elements to show and hide the submenus on hover:
const links = document.querySelectorAll('#top-menu > a[data-submenu]');
links.forEach(link => {
  link.addEventListener('mouseenter', showSubmenu);
  link.addEventListener('mouseleave', hideSubmenu);
});

// Show Submenu
function showSubmenu() {
  const submenu = this.querySelector('a[data-submenu] > ul');
  if (submenu) {
    submenu.style.display = 'block';
  }
}

// Hide Submenu
function hideSubmenu() {
  const submenu = this.querySelector('a[data-submenu] > ul');
  if (submenu) {
    submenu.style.display = 'none';
  }
}

// Hide all submenus when the mouse leaves the top menu
topMenu.addEventListener('mouseleave', function() {
  const submenus = topMenu.querySelectorAll('.submenu');
  submenus.forEach(submenu => {
    submenu.style.display = 'none';
  });
});

/* When the user scrolls down, hide the navbar. When the user scrolls up, show the navbar */
var prevScrollpos = window.pageYOffset;
window.onscroll = function() {
  var currentScrollPos = window.pageYOffset;
  if (prevScrollpos > currentScrollPos) {
    document.getElementById("top-menu").style.top = "0";
  } else {
    document.getElementById("top-menu").style.top = "-60px";
  }
  prevScrollpos = currentScrollPos;
}

// Make top menu stick when scrolling
window.addEventListener('scroll', function() {
  if (window.scrollY > 0) {
    topMenu.classList.add('sticky');
  } else {
    topMenu.classList.remove('sticky');
  }
});

// Handle click events on the top menu
topMenu.addEventListener('click', event => {
  /*event.preventDefault();*/
  const url = event.target.href;
  if (url.indexOf('facebook') !== -1) {
    // The URL contains 'facebook', so we skip redirectToAnotherPage
    return;
  }
  if (url) {
    redirectToAnotherPage(url);
  }
  console.log('Clicked element name:', event.target.name);
});

// Redirect to another page
function redirectToAnotherPage(url) {
  topMenu.classList.add('top-menu');

  fetch(url)
    .then(response => {
      // Update the page title based on the response URL
      document.title = response.url;

      return response.text();
    })
    .then(data => {
      // Navigate to the new page by updating the window location
      window.location.href = url;
    })
    .catch(error => {
      console.error(error);
      content.innerHTML = 'Error loading content';
    });
}


// mobileMenu triggered by hamburgerButton
const mobileMenu = document.querySelector('.mobile-menu');
const mobileNavMenu = document.querySelector('.mobile-nav');
const hamburgerButton = document.querySelector('.hamburger-button');
const hamburgerIcon = document.querySelector('.hamburger-icon');
const mobileLogo = document.querySelector('.mobile-logo');
const fbMobileLogo = document.querySelector('.fb-mobile-logo');

// add event listener for mobile loggo to reload to home page
mobileLogo.addEventListener('click', function() {
  window.location = '/';
});

// add event listener to hamburger button
hamburgerButton.addEventListener('click', function() {
  // check if screen size is smaller than 1200px
  if (window.innerWidth < 1200) {
    const icon = this.querySelector('i');
    if (icon.classList.contains('fa-times')) {
        console.log('HambuergerMenu clicked for closing mobile menu.');
        mobileNavMenu.innerHTML = ''; 
        icon.classList.replace('fa-times', 'fa-bars');
        mobileNavMenu.classList.replace('slide-in','slide-out');
    } else {
        console.log('HambuergerMenu clicked for opening mobile menu.');
        icon.classList.replace('fa-bars', 'fa-times');
        mobileNavMenu.classList.replace('slide-out','slide-in');
        // render mobile menu
        mobileNavMenu.innerHTML = ''; // clear existing content
        menuData.forEach((menuItem) => {
        
        if (menuItem.mobileMenuFlag) {
            const link = document.createElement('a');
            link.textContent = menuItem.label;
            link.href = menuItem.url;
            let iconElement = document.createElement("i");
            iconElement.setAttribute("class", menuItem.iconClass);
            link.insertBefore(iconElement,link.firstChild);

            if (menuItem.hasSubmenu) {
                link.setAttribute('data-submenu', '');
                const chevronDown = document.createElement('i');
                chevronDown.classList.add('fas', 'fa-chevron-down', 'chevron-down');
                link.appendChild(chevronDown);
                const submenu = document.createElement('ul');
                submenu.classList.add('mobile-submenu');
                menuItem.submenu.forEach((submenuItem) => {
                    const submenuLink = document.createElement('a');
                    submenuLink.textContent = submenuItem.label;
                    submenuLink.href = submenuItem.url;
                    submenu.appendChild(submenuLink);
                    submenu.style.display='none';
                });
                link.appendChild(submenu);
                link.addEventListener('click', function() {
                  const chevronElement = this.querySelector('.fa-chevron-down, .fa-chevron-up');
                  const submenuElement = this.querySelector('ul');
                  chevronElement.classList.toggle('chevron-down');
                  chevronElement.classList.toggle('chevron-up');
                  submenuElement.style.display = chevronElement.classList.contains('chevron-down') ? 'none' : 'block';
                  
                  // Check if the chevron class is now 'chevron-up'
                  if (chevronElement.classList.contains('chevron-up')) {
                    // If so, replace the class with 'fa-chevron-up'
                    chevronElement.classList.replace('fa-chevron-down', 'fa-chevron-up');
                  } else {
                    // Otherwise, replace the class with 'fa-chevron-down'
                    chevronElement.classList.replace('fa-chevron-up', 'fa-chevron-down');
                  }
                }); 
            }
            mobileNavMenu.insertBefore(link, mobileNavMenu.firstChild);
          }
        });
    }  
    mobileNavMenu.style.display = 'block';
/*    mobileNavMenu.style.animation = 'slide-in 0.5s forwards';*/
  }
});
