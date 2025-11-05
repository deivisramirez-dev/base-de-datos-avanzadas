// Navegación principal
class NavigationManager {
    constructor() {
        this.currentTab = 'inicio';
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.loadProgress();
    }

    setupEventListeners() {
        // Navegación a temas
        document.querySelectorAll('.topic-card').forEach(card => {
            card.addEventListener('click', () => {
                const topic = card.dataset.topic;
                this.navigateToTopic(topic);
            });
        });

        // Navegación suave a secciones
        document.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const target = document.querySelector(link.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    navigateToTopic(topicNumber) {
        // Redirigir a la página del tema o conceptos fundamentales
        if (topicNumber === 'fundamentos') {
            window.location.href = 'conceptos-fundamentales.html';
        } else {
            window.location.href = `Tema${topicNumber}/tema${topicNumber}.html`;
        }
    }

    loadProgress() {
        // Cargar progreso desde localStorage
        const progress = JSON.parse(localStorage.getItem('courseProgress') || '{}');
        this.updateProgressDisplay(progress);
    }

    updateProgressDisplay(progress) {
        // Actualizar barras de progreso de temas
        Object.keys(progress).forEach(topic => {
            const topicCard = document.querySelector(`[data-topic="${topic}"]`);
            if (topicCard) {
                const progressBar = topicCard.querySelector('.progress');
                const progressText = topicCard.querySelector('.topic-progress span');
                const percentage = progress[topic] || 0;
                
                if (progressBar) {
                    progressBar.style.width = `${percentage}%`;
                }
                if (progressText) {
                    progressText.textContent = `${percentage}%`;
                }
            }
        });

        // Actualizar estadísticas generales
        this.updateOverallStats(progress);
    }

    updateOverallStats(progress) {
        const topics = Object.keys(progress);
        const completedTopics = topics.filter(topic => progress[topic] === 100);
        const totalProgress = topics.length > 0 ? 
            topics.reduce((sum, topic) => sum + (progress[topic] || 0), 0) / topics.length : 0;

        // Actualizar círculo de progreso
        const progressRing = document.querySelector('.progress-ring-fill');
        if (progressRing) {
            const circumference = 2 * Math.PI * 54;
            const offset = circumference - (totalProgress / 100) * circumference;
            progressRing.style.strokeDashoffset = offset;
        }

        // Actualizar porcentaje
        const progressPercentage = document.querySelector('.progress-percentage');
        if (progressPercentage) {
            progressPercentage.textContent = `${Math.round(totalProgress)}%`;
        }

        // Actualizar estadísticas
        const statNumbers = document.querySelectorAll('.stat-number');
        if (statNumbers.length >= 3) {
            statNumbers[0].textContent = completedTopics.length;
            statNumbers[1].textContent = Math.round(totalProgress * 0.4); // Horas estimadas
            statNumbers[2].textContent = completedTopics.length * 4; // Actividades por tema
        }
    }
}

// Gestor de progreso
class ProgressManager {
    constructor() {
        this.progress = JSON.parse(localStorage.getItem('courseProgress') || '{}');
    }

    updateTopicProgress(topic, section, completed = true) {
        if (!this.progress[topic]) {
            this.progress[topic] = {
                conceptos: false,
                ejemplos: false,
                actividades: false,
                recursos: false
            };
        }

        this.progress[topic][section] = completed;
        
        // Calcular porcentaje del tema
        const sections = Object.values(this.progress[topic]);
        const completedSections = sections.filter(Boolean).length;
        const percentage = Math.round((completedSections / sections.length) * 100);
        
        this.progress[topic].percentage = percentage;
        
        // Guardar en localStorage
        localStorage.setItem('courseProgress', JSON.stringify(this.progress));
        
        // Actualizar display si estamos en la página principal
        if (window.location.pathname.endsWith('index.html') || window.location.pathname === '/') {
            const navManager = new NavigationManager();
            navManager.updateProgressDisplay(this.progress);
        }
    }

    getTopicProgress(topic) {
        return this.progress[topic] || {
            conceptos: false,
            ejemplos: false,
            actividades: false,
            recursos: false,
            percentage: 0
        };
    }
}

// Utilidades para páginas de tema
class TopicPageManager {
    constructor() {
        this.progressManager = new ProgressManager();
        this.currentTopic = this.getCurrentTopic();
        this.init();
    }

    getCurrentTopic() {
        const path = window.location.pathname;
        const match = path.match(/tema(\d+)\.html/);
        return match ? match[1] : null;
    }

    init() {
        if (this.currentTopic) {
            this.setupSectionTracking();
            this.updateProgressDisplay();
        }
    }

    setupSectionTracking() {
        // Tracking para secciones
        const sections = ['conceptos', 'ejemplos', 'actividades', 'recursos'];
        
        sections.forEach(section => {
            const sectionElement = document.getElementById(section);
            if (sectionElement) {
                // Crear observer para detectar cuando la sección es visible
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            this.progressManager.updateTopicProgress(this.currentTopic, section, true);
                            this.updateProgressDisplay();
                        }
                    });
                }, { threshold: 0.5 });

                observer.observe(sectionElement);
            }
        });
    }

    updateProgressDisplay() {
        const progress = this.progressManager.getTopicProgress(this.currentTopic);
        
        // Actualizar indicadores de sección
        Object.keys(progress).forEach(section => {
            if (section !== 'percentage') {
                const sectionElement = document.getElementById(section);
                if (sectionElement) {
                    const indicator = sectionElement.querySelector('.section-indicator');
                    if (indicator) {
                        indicator.classList.toggle('completed', progress[section]);
                    }
                }
            }
        });
    }
}

// Funciones de utilidad
class Utils {
    static formatTime(minutes) {
        if (minutes < 60) {
            return `${minutes} min`;
        } else {
            const hours = Math.floor(minutes / 60);
            const mins = minutes % 60;
            return `${hours}h ${mins}min`;
        }
    }

    static animateCounter(element, target, duration = 1000) {
        const start = 0;
        const increment = target / (duration / 16);
        let current = start;

        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            element.textContent = Math.floor(current);
        }, 16);
    }

    static showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;
        
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6'};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            z-index: 1000;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        `;

        document.body.appendChild(notification);

        // Animar entrada
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 100);

        // Remover después de 3 segundos
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 3000);
    }
}

// Inicialización
document.addEventListener('DOMContentLoaded', () => {
    // Inicializar navegación principal
    if (window.location.pathname.endsWith('index.html') || window.location.pathname === '/') {
        new NavigationManager();
    } else {
        // Inicializar gestor de página de tema
        new TopicPageManager();
    }

    // Agregar efectos de hover a las cards
    document.querySelectorAll('.topic-card, .feature-card').forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.style.transform = 'translateY(-3px)';
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'translateY(0)';
        });
    });

    // Smooth scroll para enlaces internos
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const target = document.querySelector(link.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// Exportar para uso global
window.NavigationManager = NavigationManager;
window.ProgressManager = ProgressManager;
window.TopicPageManager = TopicPageManager;
window.Utils = Utils;
