import Swiper from "swiper/bundle";

// import styles bundle
import "swiper/css/bundle";
import "./slideshow.css";

const autoplay = window.gon && window.gon.autoplay;
let progress = 0;
const progressBar = document.getElementById("determinate");
if (autoplay) {
  setInterval(() => {
    progressBar.style["width"] = `${progress * 100}%`;
  }, 300);
} else {
  progressBar.parentElement.remove();
}
let interval = null;
const options = {
  cssMode: true,
  // If we need pagination
  pagination: {
    el: ".swiper-pagination",
  },

  // Navigation arrows
  navigation: {
    nextEl: ".swiper-button-next",
    prevEl: ".swiper-button-prev",
  },

  // Disable preloading of all images
  preloadImages: false,
  // Enable lazy loading
  lazy: true,

  // https://codesandbox.io/s/jke0r?file=/index.html:2226-2277
  slidesPerView: window.gon.slidesPerView,
  spaceBetween: 30,

  autoplay,

  loop: true,
  on: {
    autoplay: () => {
      progress = 0;
    },
    autoplayStart: () => {
      const updateInterval = 100.0;
      interval = window.setInterval(() => {
        progress += updateInterval / autoplay.delay;
      }, updateInterval);
    },
    autoplayStop: () => {
      window.clearInterval(interval);
    },
  },
};

new Swiper(".swiper", options);
