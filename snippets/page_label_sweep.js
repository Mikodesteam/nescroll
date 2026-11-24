// Excerpt from Nescroll (app/NoReels/Resources/page.js). Shown for illustration only.
// The full source code is available at https://store.mikodes.com/p/nescroll/
//
// Hiding a feed item by its label (for example "Suggested for you"). The script only hides
// an element that looks like a post: not too tall, and never one that holds navigation,
// a header or an input field, so a wrong match cannot hide the page chrome.

(() => {
  // …
  // Hidden by label: a feed item showing one of these exact texts goes.
  const labels = new Set(config.labels);
  const isSafeToHide = (el) =>
    el && el !== document.body && el !== document.documentElement &&
    el.offsetHeight < innerHeight * 1.5 &&
    !el.querySelector('[role="navigation"], nav, header, input, textarea, [contenteditable="true"]');
  const feedItem = (el) => {
    if (config.itemSelector) {
      const item = el.closest(config.itemSelector);
      if (item) return item;
    }
    // No markup to go by: climb to the first ancestor tall enough to be a post.
    let node = el;
    while (node.parentElement && node.parentElement !== document.body && node.offsetHeight < 240) node = node.parentElement;
    return node;
  };
  const sweep = () => {
    if (!labels.size || !document.body) return;
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    for (let text = walker.nextNode(); text; text = walker.nextNode()) {
      const value = text.nodeValue;
      if (value.length > 40 || !labels.has(value.trim())) continue;
      const parent = text.parentElement;
      if (!parent || parent.closest('[data-nr-hidden]')) continue;
      const item = feedItem(parent);
      if (!isSafeToHide(item)) continue;
      item.setAttribute('data-nr-hidden', '');
      item.style.setProperty('display', 'none', 'important');
      post({ hidden: 1 });
    }
  };
  // …
})();
