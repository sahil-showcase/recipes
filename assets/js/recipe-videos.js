/* Typed video references and older YouTube links share the same renderer. */
(() => {
  function videoSource(value) {
    let url;
    try { url = new URL(value, document.baseURI); } catch { return null; }
    if (!['http:', 'https:'].includes(url.protocol)) return null;
    const host = url.hostname.toLowerCase().replace(/^www\./, '');
    let id;
    if (host === 'youtu.be') id = url.pathname.slice(1).split('/')[0];
    else if (['youtube.com', 'm.youtube.com', 'youtube-nocookie.com'].includes(host)) {
      id = url.searchParams.get('v');
      if (!id && /^\/(shorts|embed)\//.test(url.pathname)) id = url.pathname.split('/')[2];
    }
    if (id && /^[\w-]{11}$/.test(id)) {
      return { type: 'youtube', key: id, src: `https://www.youtube-nocookie.com/embed/${id}` };
    }
    if (/\.(mp4|webm|ogg)$/i.test(url.pathname)) return { type: 'file', key: url.href, src: url.href };
    return null;
  }
  function player(source, title) {
    const media = document.createElement(source.type === 'youtube' ? 'iframe' : 'video');
    media.src = source.src;
    if (source.type === 'youtube') {
      media.title = title;
      media.loading = 'lazy';
      media.allow = 'accelerometer; encrypted-media; gyroscope; picture-in-picture; fullscreen';
      media.allowFullscreen = true;
      media.referrerPolicy = 'strict-origin-when-cross-origin';
    } else {
      media.controls = true;
      media.preload = 'none';
      media.setAttribute('aria-label', title);
    }
    return media;
  }
  const seen = new Set();
  document.querySelectorAll('[data-video-url]').forEach(slot => {
    const source = videoSource(slot.dataset.videoUrl);
    if (!source) return; // The server-rendered source link remains usable.
    slot.append(player(source, slot.dataset.videoTitle || 'Recipe video reference'));
    seen.add(source.key);
  });
  const notes = document.querySelector('.recipe-notes');
  const container = document.querySelector('#recipe-videos');
  if (!notes || !container) return;
  const candidates = [...(notes.textContent.match(/https?:\/\/[^\s<>"']+/g) || []),
    ...Array.from(notes.querySelectorAll('a[href]'), a => a.href)];
  let count = 0;
  for (const candidate of candidates) {
    const source = videoSource(candidate.replace(/[.,;)]+$/, ''));
    if (!source || source.type !== 'youtube' || seen.has(source.key)) continue;
    seen.add(source.key);
    if (count++ === 0) {
      const heading = document.createElement('h3');
      heading.textContent = 'Video references';
      container.append(heading);
    }
    const figure = document.createElement('figure');
    figure.className = 'video-reference';
    const title = document.querySelector('h1').textContent.trim();
    const caption = document.createElement('figcaption');
    const link = document.createElement('a');
    link.href = `https://www.youtube.com/watch?v=${source.key}`;
    link.textContent = 'Watch on YouTube';
    caption.append(link, ' if the video is unavailable here.');
    figure.append(player(source, `Video reference ${count} for ${title}`), caption);
    container.append(figure);
  }
})();
