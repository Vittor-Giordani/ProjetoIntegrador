// app/javascript/search.js

class SidebarSearch {
  constructor() {
    this.searchDesktop = document.getElementById('sidebarSearch');
    this.searchMobile = document.getElementById('sidebarSearchMobile');
    this.clearBtn = document.getElementById('clearSearch');
    this.searchBtn = document.getElementById('btnNavbarSearch');
    this.menuItems = document.querySelectorAll('.nav-link');
    this.menuHeadings = document.querySelectorAll('.sb-sidenav-menu-heading');
    
    this.init();
  }

  init() {
    if (this.searchDesktop) {
      // Eventos para busca desktop
      this.searchDesktop.addEventListener('input', () => this.filterMenu());
      this.searchDesktop.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
          e.preventDefault();
          this.highlightResults();
        }
      });

      // Evento para botão de busca
      if (this.searchBtn) {
        this.searchBtn.addEventListener('click', () => this.highlightResults());
      }

      // Evento para limpar busca
      if (this.clearBtn) {
        this.clearBtn.addEventListener('click', () => this.clearSearch());
      }
    }

    // Sincroniza com busca mobile
    if (this.searchMobile) {
      this.searchMobile.addEventListener('input', () => {
        if (this.searchDesktop) {
          this.searchDesktop.value = this.searchMobile.value;
          this.filterMenu();
        }
      });
    }

    // Sincroniza desktop -> mobile
    if (this.searchDesktop && this.searchMobile) {
      this.searchDesktop.addEventListener('input', () => {
        this.searchMobile.value = this.searchDesktop.value;
      });
    }
  }

  filterMenu() {
    const searchTerm = this.searchDesktop ? this.searchDesktop.value.toLowerCase().trim() : '';
    
    // Mostra/Esconde itens baseado na busca
    this.menuItems.forEach(item => {
      const text = item.textContent.toLowerCase();
      const href = item.getAttribute('href') || '';
      const searchData = item.getAttribute('data-search') || '';
      
      if (searchTerm === '' || 
          text.includes(searchTerm) || 
          href.includes(searchTerm) ||
          searchData.includes(searchTerm)) {
        item.style.display = 'flex';
        item.classList.remove('hidden-search-item');
      } else {
        item.style.display = 'none';
        item.classList.add('hidden-search-item');
      }
    });

    // Mostra/Esconde headings
    this.menuHeadings.forEach(heading => {
      heading.style.display = searchTerm === '' ? 'block' : 'none';
    });

    // Gerencia mensagem "sem resultados"
    this.handleNoResults(searchTerm);
  }

  highlightResults() {
    const searchTerm = this.searchDesktop ? this.searchDesktop.value.toLowerCase().trim() : '';
    
    if (!searchTerm) return;

    // Remove destaque anterior
    this.menuItems.forEach(item => item.classList.remove('highlight'));

    // Destaca itens correspondentes
    let hasResults = false;
    this.menuItems.forEach(item => {
      const text = item.textContent.toLowerCase();
      const searchData = item.getAttribute('data-search') || '';
      
      if (text.includes(searchTerm) || searchData.includes(searchTerm)) {
        item.classList.add('highlight');
        hasResults = true;
        
        // Rolagem suave para o primeiro resultado
        if (!document.querySelector('.highlight-scrolled')) {
          item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
          item.classList.add('highlight-scrolled');
          setTimeout(() => item.classList.remove('highlight-scrolled'), 1000);
        }
      }
    });

    // Mostra notificação se não houver resultados
    if (!hasResults) {
      this.showNotification('Nenhum item encontrado', 'warning');
    }
  }

  clearSearch() {
    if (this.searchDesktop) {
      this.searchDesktop.value = '';
      this.filterMenu();
      this.searchDesktop.focus();
    }
    
    if (this.searchMobile) {
      this.searchMobile.value = '';
    }
    
    // Remove todos os destaques
    this.menuItems.forEach(item => item.classList.remove('highlight'));
  }

  handleNoResults(searchTerm) {
    const noResultsElement = document.getElementById('noSearchResults');
    
    if (searchTerm === '') {
      if (noResultsElement) noResultsElement.remove();
      return;
    }

    const visibleItems = Array.from(this.menuItems).filter(item => 
      item.style.display !== 'none'
    );

    if (visibleItems.length === 0) {
      if (!noResultsElement) {
        const noResultsMsg = document.createElement('div');
        noResultsMsg.id = 'noSearchResults';
        noResultsMsg.className = 'text-center text-muted p-3';
        noResultsMsg.innerHTML = '<i class="fas fa-search me-2"></i>Nenhum item encontrado';
        
        const menuContainer = document.querySelector('.sb-sidenav-menu');
        if (menuContainer) {
          menuContainer.appendChild(noResultsMsg);
        }
      }
    } else if (noResultsElement) {
      noResultsElement.remove();
    }
  }

  showNotification(message, type = 'info') {
    // Remove notificação anterior
    const existingNotification = document.querySelector('.search-notification');
    if (existingNotification) existingNotification.remove();

    // Cria nova notificação
    const notification = document.createElement('div');
    notification.className = `search-notification alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 80px; right: 20px; z-index: 1060; max-width: 300px;';
    notification.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    document.body.appendChild(notification);

    // Remove automaticamente após 3 segundos
    setTimeout(() => {
      if (notification.parentNode) {
        notification.remove();
      }
    }, 3000);
  }
}

// Inicializa quando o DOM estiver carregado
document.addEventListener('DOMContentLoaded', () => {
  new SidebarSearch();
});

// Exporta a classe se estiver usando módulos
if (typeof module !== 'undefined' && module.exports) {
  module.exports = SidebarSearch;
}