import '@materializecss/materialize/dist/css/materialize.min.css'
import '@materializecss/materialize/dist/js/materialize.min.js'
document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.sidenav');
    window.M.Sidenav.init(elems, {});
});
