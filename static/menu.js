// Closes the hamburger menu on Escape, on a click outside it and when a link in it is followed.
// Without JavaScript the <details> element still opens and closes by itself.
(function () {
  var menu = document.querySelector('nav.sitenav details.menu');
  if (!menu) return;
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && menu.open) { menu.open = false; menu.querySelector('summary').focus(); }
  });
  document.addEventListener('click', function (e) {
    if (menu.open && !menu.contains(e.target)) menu.open = false;
  });
  menu.addEventListener('click', function (e) {
    if (e.target.closest('a')) menu.open = false;
  });
})();
