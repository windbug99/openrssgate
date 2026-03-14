-- Generated from OPML sources on 2026-03-14.
-- Imported rows: 224
-- Failed rows: 15
-- FAILED https://www.vincirufus.com/rss.xml (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://behavioralscientist.org/feed (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://www.codeintegrity.ai/rss.xml (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://venturedesktop.substack.com/feed (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://libidosciendi.substack.com/feed (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://www.maginative.com/rss (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://www.flarup.email/feed (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://www.workingtheorys.com/feed (feedly-744ba8b1-3a15-4b25-a356-f4529871a961-2026-02-18.opml): feed_fetch_failed
-- FAILED https://engineering.getsimpl.com/rss (subscriptions.opml): feed_fetch_failed
-- FAILED https://www.morningbrew.com/feed.xml (subscriptions.opml): feed_fetch_failed
-- FAILED https://proandroiddev.com/feed (subscriptions.opml): feed_fetch_failed
-- FAILED https://blog.samaltman.com/application/atom+xml (subscriptions.opml): feed_fetch_failed
-- FAILED https://shomik.substack.com/feed (subscriptions.opml): feed_fetch_failed
-- FAILED https://regexe.substack.com/feed (subscriptions.opml): feed_fetch_failed
-- FAILED https://snjnpark.kr/ko/rss.xml (subscriptions.opml): feed_fetch_failed

BEGIN;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '4db16de2-ba7a-5f4c-86b2-fec906f3d874', 'https://blog.howardjohn.info/index.xml', 'https://blog.howardjohn.info/', 'howardjohn''s blog',
  'Recent content on howardjohn''s blog', 'https://blog.howardjohn.info/favicon.ico', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:21.069703Z', '2026-03-05T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6d65f9a3-9a6b-5a39-9c68-6ab90533e0a3', 'https://rss.beehiiv.com/feeds/IDFzfYwUH1.xml', 'https://westenberg.beehiiv.com/', 'Westenberg.',
  'Where Builders Come to Think.', 'https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/publication/logo/6460bda5-5b4c-413e-8b9f-ff01bf1ab3fe/thumb_Untitled_design.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:21.794786Z', '2025-12-02T09:33:35Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c3e7cedf-596a-5bb8-b056-be91dd14c834', 'https://shinyorke.hatenablog.com/feed', 'https://shinyorke.hatenablog.com/', 'Lean Baseball',
  'No Engineering, No Baseball.', 'https://shinyorke.hatenablog.com/icon/favicon', 'ja', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:19.959571Z', '2026-03-14T10:40:48Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,sports'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2f4746fa-e629-563a-bc09-e4bcd32db7a7', 'https://www.hackshackers.com/rss', 'https://www.hackshackers.com/', 'Hacks/Hackers',
  'Advancing media innovation to foster public trust', 'https://www.hackshackers.com/content/images/size/w256h256/2024/05/hackshackers_logomark.png', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:21.595385Z', '2026-03-12T20:34:40Z',
  0, 'opml_import', 'auto_approved', 'blog', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '91203779-5dce-5825-99cd-3925007efd37', 'https://ashvardanian.com/index.xml', 'https://ashvardanian.com/', 'Ash''s Blog',
  'Recent content on Ash''s Blog', 'https://ashvardanian.com/favicon/favicon.ico', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:20.364741Z', '2025-12-15T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'research', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'eb8aaa19-fd68-5068-8755-b2c435f5e4a2', 'https://people.csail.mit.edu/rachit/post/atom.xml', 'https://people.csail.mit.edu/rachit/post', '- Rachit''s Blog',
  NULL, 'https://people.csail.mit.edu/rachit/flower.svg', 'en', 'tech', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:23.450230Z', '2025-12-30T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'research', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '0684df9b-8b5e-526f-bf1d-e19de180292a', 'https://blog.rchase.com/rss', 'https://blog.rchase.com/', 'blog.rchase.com',
  'This is where I write things that are too long for X', 'https://blog.rchase.com/content/images/size/w256h256/2020/01/linkedin-128.png', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:21.853592Z', '2026-02-27T19:25:27Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5b31ecd5-2fe3-548a-adb7-5e5b7d586dc6', 'https://timo.space/blog/rss', 'https://timo.space/', 'Timo Dechau',
  '<header class="border-b border-border bg-background sticky top-0 z-50"> <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8"> <div class="flex justify-between items-center h-16 relative">  <div class="hidden md:flex md:space-x-8"> <a class="font-medium uppercase tracking-wide transition-colors text-muted-foreground hover:text-foreground" href="/blog" style="font-family: fragmentMono, monospace; font-size: 14px;"> Blog </a><a class="font-medium uppercase tracking-wide transition-colors text-muted-foreground hover:text-foreground" href="/library" style="font-family: fragmentMono, monospace; font-size: 14px;"> Library </a><a class="font-medium uppercase tracking-wide transition-colors text-muted-foreground hover:text-foreground" href="/books/analytics-workbook" style="font-family: fragmentMono, monospace; font-size: 14px;"> Book </a><a class="font-medium uppercase tracking-wide transition-colors text-muted-foreground hover:text-foreground" href="/work-with-me" style="font-family: fragmentMono, monospace; font-size: 14px;"> Work with me </a> </div>  <a class="absolute left-1/2 -translate-x-1/2 font-bold text-foreground hover:text-primary transition-colors" href="/" style="font-family: fragmentMono, monospace; font-size: 14px;">
timo dechau
</a>  <div class="flex items-center gap-4">  <div class="hidden md:block"> &gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&amp;&amp;&amp;&amp;&amp;&amp;&amp;&amp;&amp;&amp;&gt;&gt;&gt;&amp;&amp;&amp;&amp;&amp;&amp;&gt;&gt;&gt;&gt;<button class="px-6 py-2 bg-primary text-primary-foreground rounded-full hover:bg-primary/90 transition-colors font-medium">Subscribe</button> </div>  <div class="md:hidden"> <button class="px-6 py-2 bg-primary text-primary-foreground rounded-full hover:bg-primary/90 transition-colors font-medium">Subscribe</button> </div>  <div class="md:hidden"> <button class="text-muted-foreground hover:text-primary transition-colors" id="mobile-menu-button" type="button">    </button> </div> </div> </div>  <div class="md:hidden hidden py-4 space-y-2 border-t border-border" id="mobile-menu"> <a class="block font-medium uppercase tracking-wide transition-colors py-2 text-muted-foreground hover:text-foreground" href="/blog" style="font-family: fragmentMono, monospace; font-size: 14px;"> Blog </a><a class="block font-medium uppercase tracking-wide transition-colors py-2 text-muted-foreground hover:text-foreground" href="/library" style="font-family: fragmentMono, monospace; font-size: 14px;"> Library </a><a class="block font-medium uppercase tracking-wide transition-colors py-2 text-muted-foreground hover:text-foreground" href="/books/analytics-workbook" style="font-family: fragmentMono, monospace; font-size: 14px;"> Book </a><a class="block font-medium uppercase tracking-wide transition-colors py-2 text-muted-foreground hover:text-foreground" href="/work-with-me" style="font-family: fragmentMono, monospace; font-size: 14px;"> Work with me </a> </div> </nav> </header> &amp;&amp;&amp;&amp;&gt;   <section class="py-12 md:py-16"> <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">  <div class="md:hidden flex flex-col gap-8"> <div class="flex justify-center"> <img alt="Timo Dechau" class="w-64 h-64 rounded-full object-cover border-2 border-border" src="/timo-profile.jpg" /> </div> <div class="text-center"> <h1 class="text-h1 font-bold font-serif text-foreground mb-4">
Hey, I am Timo! Great to meet you.
</h1> <p class="text-body-lg text-muted-foreground mb-4">
I am the founder of Deepskydata and usually spend my days thinking about better growth
          data setups.
</p> <p class="text-body-lg text-muted-foreground">
These thoughts eventually end up in products, playbooks, workshops, blogs and videos. If I don''t do this, I enjoy my time with my family in the
          beautiful surroundings of North Jutland in Denmark.
</p> </div> </div>  <div class="hidden md:grid md:grid-cols-2 gap-12 items-center">  <div> <h1 class="text-h1 font-bold font-serif text-foreground mb-4">
Hey, I am Timo! Great to meet you.
</h1> <p class="text-body-lg text-muted-foreground mb-4">
I am the founder of Deepskydata and usually spend my days thinking about better growth
          data setups.
</p> <p class="text-body-lg text-muted-foreground">
These thoughts eventually end up in products, playbooks, workshops, blogs and videos. If I don''t do this, I enjoy my time with my family in the
          beautiful surroundings of North Jutland in Denmark.
</p> </div>  <div class="flex justify-center"> <img alt="Timo Dechau" class="w-80 h-80 rounded-full object-cover border-2 border-border" src="/timo-profile.jpg" /> </div> </div> </div> </section>  <section class="py-16"> <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8"> <h2 class="text-h1 font-bold font-serif text-foreground mb-8">Products</h2> <div class="grid grid-cols-1 md:grid-cols-2 gap-8">  <div class="border border-border rounded-xl p-6 bg-card flex flex-col"> <h3 class="text-h2 font-semibold font-serif text-foreground mb-3">
Basesignal
</h3> <p class="text-body text-muted-foreground flex-1 mb-6">
Strategic product analytics that helps teams shift from tracking interactions to measuring meaningful outcomes.
</p> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 border border-input bg-background shadow-sm hover:bg-primary hover:text-primary-foreground hover:border-primary h-9 px-4 py-2" href="https://basesignal.net/" rel="noopener noreferrer" target="_blank">
Try Basesignal
</a> </div>  <div class="border border-border rounded-xl p-6 bg-card flex flex-col"> <h3 class="text-h2 font-semibold font-serif text-foreground mb-3">
FixMyTracking
</h3> <p class="text-body text-muted-foreground flex-1 mb-6">
Expert audit service that verifies your conversion tracking across Google Ads, Meta, and other platforms.
</p> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 border border-input bg-background shadow-sm hover:bg-primary hover:text-primary-foreground hover:border-primary h-9 px-4 py-2" href="https://fixmytracking.com/" rel="noopener noreferrer" target="_blank">
Get an audit
</a> </div> </div> </div> </section>  <section class="py-16 bg-muted/50"> <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8"> <h2 class="text-h1 font-bold font-serif text-foreground mb-8">Highlights</h2> <div class="grid grid-cols-1 md:grid-cols-2 gap-8">  <div class="border border-border rounded-xl p-6 bg-card flex flex-col">  <p class="text-body text-muted-foreground flex-1 mb-6">
Free workshops on analytics implementation, event data modeling, and growth measurement. Sign up for the newsletter to get notified about upcoming sessions.
</p> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 border border-input bg-background shadow-sm hover:bg-primary hover:text-primary-foreground hover:border-primary h-9 px-4 py-2" href="/library">
Watch past workshops
</a>  </div>  <div class="border border-border rounded-xl p-6 bg-card flex flex-col"> <span class="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
Work with me
</span> <h3 class="text-h2 font-semibold font-serif text-foreground mb-3">
Product Analytics &amp; Growth Intelligence Advisory
</h3> <p class="text-body text-muted-foreground flex-1 mb-6">
I help data teams turn good analysis into insights leadership actually acts on. 2-3 month engagements focused on Product Analytics &amp; Growth Intelligence.
</p> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 border border-input bg-background shadow-sm hover:bg-primary hover:text-primary-foreground hover:border-primary h-9 px-4 py-2" href="/work-with-me">
Learn more
</a> </div> </div> </div> </section>  <section class="py-16"> <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8"> <h2 class="text-h1 font-bold font-serif text-foreground mb-8">Learn</h2> <div class="grid grid-cols-1 md:grid-cols-2 gap-8">  <div class="border border-border rounded-xl p-6 bg-card flex flex-col"> <h3 class="text-h2 font-semibold font-serif text-foreground mb-3">
Analytics Implementation Workbook
</h3> <p class="text-body text-muted-foreground flex-1 mb-6">
The essentials you need to know to create impactful analytics setups.
</p> <div class="flex flex-wrap gap-3"> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 bg-primary text-primary-foreground hover:bg-primary/90 hover:shadow-primary active:scale-[0.98] active:bg-primary/95 h-9 px-4 py-2" href="/book">
Buy PDF
</a> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 border border-input bg-background shadow-sm hover:bg-primary hover:text-primary-foreground hover:border-primary h-9 px-4 py-2" href="/books/analytics-workbook">
Read free web version
</a> </div> </div>  <div class="border border-border rounded-xl p-6 bg-card flex flex-col"> <h3 class="text-h2 font-semibold font-serif text-foreground mb-3">
Library
</h3> <p class="text-body text-muted-foreground flex-1 mb-6">
Curated resources on product analytics, event data, and growth measurement.
</p> <a class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 border border-input bg-background shadow-sm hover:bg-primary hover:text-primary-foreground hover:border-primary h-9 px-4 py-2" href="/library">
Browse library
</a> </div> </div> </div> </section>  <section class="py-16 bg-muted/50"> <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8"> <h2 class="text-h1 font-bold font-serif text-foreground mb-8">Latest</h2> <div class="grid grid-cols-1 md:grid-cols-2 gap-8">  <a class="group border border-border rounded-xl bg-card overflow-hidden flex flex-col hover:shadow-md transition-shadow" href="https://www.youtube.com/watch?v=5ulhDZ_3qeg" rel="noopener noreferrer" target="_blank"> <div class="relative w-full aspect-video overflow-hidden bg-muted"> <img alt="Answering data modeling question for attribution with Google Analytics 4" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" src="https://i.ytimg.com/vi/5ulhDZ_3qeg/hqdefault.jpg" /> </div> <div class="p-6 flex flex-col flex-1"> <span class="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
Latest Video
</span> <h3 class="text-h3 font-semibold text-foreground group-hover:text-primary transition-colors line-clamp-2"> Answering data modeling question for attribution with Google Analytics 4 </h3> </div> </a>  <a class="group border border-border rounded-xl bg-card overflow-hidden flex flex-col hover:shadow-md transition-shadow" href="/blog/its-about-the-strategy-stupid"> <div class="relative w-full aspect-video overflow-hidden bg-muted"> <img alt="It''s about the strategy, stupid" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" src="https://hipster-data-show.ghost.io/content/images/2026/02/8cd25d14-3455-4bff-96bb-b33e204e9d47.jpeg" /> </div> <div class="p-6 flex flex-col flex-1"> <span class="text-xs font-medium text-muted-foreground uppercase tracking-wide mb-2">
Latest Post
</span> <h3 class="text-h3 font-semibold text-foreground group-hover:text-primary transition-colors line-clamp-2"> It''s about the strategy, stupid </h3> <p class="text-body text-muted-foreground mt-2 line-clamp-2"> &quot;What can you see in the data?&quot;

The client asked me this while I was scanning through their analytics setup. Ten curious eyes were looking at me, waiting.

I was actually looking for something completely different. I wasn''t hunting for insights. I was just checking the shape of the data - what kind of events they''re collecting, how things are structured. My usual &quot;let me get an overview&quot; check that I do at the start of every project.

But the group sitting around me was expecting something else </p> </div> </a> </div> </div> </section>  <section class="py-16"> <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 text-center"> <h2 class="text-h1 font-bold font-serif text-foreground mb-4">
Join the Newsletter
</h2> <p class="text-body-lg text-muted-foreground mb-8">
Get bi-weekly insights on analytics, event data, and metric frameworks delivered to your inbox.
</p> <div class="max-w-md mx-auto"> <div class="space-y-3"><form class="space-y-3"><div class="space-y-2"><label class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 sr-only" for="_r8R_5_-form-item">Email address</label><input class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:shadow-primary disabled:cursor-not-allowed disabled:opacity-50" id="_r8R_5_-form-item" name="email" type="email" value="" /></div><button class="inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&amp;_svg]:pointer-events-none [&amp;_svg]:size-4 [&amp;_svg]:shrink-0 bg-primary text-primary-foreground hover:bg-primary/90 hover:shadow-primary active:scale-[0.98] active:bg-primary/95 h-9 px-4 py-2" type="submit">Subscribe</button></form></div> </div> </div> </section>  <section class="py-8 md:py-12"> <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">  <div class="md:hidden space-y-6"> <div class="bg-white dark:bg-slate-950 rounded-lg border border-border"><button class="w-full py-3 px-4 flex items-center justify-between hover:bg-muted/20 transition-colors md:hidden"><span class="text-body-sm font-semibold text-foreground" id="stats-button">Your Stats</span><span class="transition-transform">▼</span></button></div> <div class="space-y-6">  <div class="pb-4 border-b border-border/50"> <p class="font-medium uppercase tracking-wide text-muted-foreground" style="font-family: fragmentMono, monospace; font-size: 12px;">
Properties
</p> </div>  <div class="pb-6 border-b border-border"> <h2 class="text-h2 font-bold text-foreground mb-1"> Timo Dechau </h2> <p class="text-body-sm text-muted-foreground mb-2"> Aalborg, Denmark </p> <a class="text-body-sm text-primary hover:text-primary/80 transition-colors" href="/cdn-cgi/l/email-protection#c5b1aca8aa85a1a0a0b5b6aebca1a4b1a4eba6aaa8"> <span class="__cf_email__">[email protected]</span> </a> </div>  <div class="space-y-4"> <div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> posts_published </span> <span class="text-h3 font-semibold text-foreground"> 57 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> words_written </span> <span class="text-h3 font-semibold text-foreground"> 114,600 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> days_since_last_post_published </span> <span class="text-h3 font-semibold text-foreground"> 18 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> yt_videos_published </span> <span class="text-h3 font-semibold text-foreground"> 147 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> minutes_recorded </span> <span class="text-h3 font-semibold text-foreground"> 1,764 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> days_since_last_video_published </span> <span class="text-h3 font-semibold text-foreground"> 0 </span> </div> </div> </div>  <div class="bg-white dark:bg-slate-950 rounded-lg border border-border p-6"> <div class="space-y-4">  <div class="pb-4 border-b border-border/50"> <p class="font-medium uppercase tracking-wide text-muted-foreground" style="font-family: fragmentMono, monospace; font-size: 12px;">
Events
</p> </div>  <div class="flex gap-3 py-3 border-b border-border/30 last:border-b-0 opacity-100">  <div class="flex-shrink-0 pt-1"> <span class="inline-block w-2 h-2 rounded-full mt-1.5 bg-primary"></span> </div> <span class="sr-only"> Past:  </span>  <div class="flex-1 min-w-0"> <p class="text-body-sm text-foreground"> YouTube Video published </p> <p class="text-body-xs text-muted-foreground mt-1"> 13/03/2026, 20.44 </p> </div> </div><div class="flex gap-3 py-3 border-b border-border/30 last:border-b-0 opacity-100">  <div class="flex-shrink-0 pt-1"> <span class="inline-block w-2 h-2 rounded-full mt-1.5 bg-primary"></span> </div> <span class="sr-only"> Past:  </span>  <div class="flex-1 min-w-0"> <p class="text-body-sm text-foreground"> LinkedIn post published </p> <p class="text-body-xs text-muted-foreground mt-1"> 12/03/2026, 07.30 </p> </div> </div><div class="flex gap-3 py-3 border-b border-border/30 last:border-b-0 opacity-100">  <div class="flex-shrink-0 pt-1"> <span class="inline-block w-2 h-2 rounded-full mt-1.5 bg-primary"></span> </div> <span class="sr-only"> Past:  </span>  <div class="flex-1 min-w-0"> <p class="text-body-sm text-foreground"> Blog post published </p> <p class="text-body-xs text-muted-foreground mt-1"> 23/02/2026, 13.05 </p> </div> </div> </div> </div> </div>  <div class="hidden md:grid md:grid-cols-3 gap-8 items-start">  <div class="bg-white dark:bg-slate-950 rounded-lg border border-border p-6"> <div class="space-y-6">  <div class="pb-4 border-b border-border/50"> <p class="font-medium uppercase tracking-wide text-muted-foreground" style="font-family: fragmentMono, monospace; font-size: 12px;">
Properties
</p> </div>  <div class="pb-6 border-b border-border"> <h2 class="text-h2 font-bold text-foreground mb-1"> Timo Dechau </h2> <p class="text-body-sm text-muted-foreground mb-2"> Aalborg, Denmark </p> <a class="text-body-sm text-primary hover:text-primary/80 transition-colors" href="/cdn-cgi/l/email-protection#f88c919597b89c9d9d888b93819c998c99d69b9795"> <span class="__cf_email__">[email protected]</span> </a> </div>  <div class="space-y-4"> <div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> posts_published </span> <span class="text-h3 font-semibold text-foreground"> 57 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> words_written </span> <span class="text-h3 font-semibold text-foreground"> 114,600 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> days_since_last_post_published </span> <span class="text-h3 font-semibold text-foreground"> 18 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> yt_videos_published </span> <span class="text-h3 font-semibold text-foreground"> 147 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> minutes_recorded </span> <span class="text-h3 font-semibold text-foreground"> 1,764 </span> </div><div class="flex items-baseline justify-between py-2"> <span class="text-body-sm text-muted-foreground"> days_since_last_video_published </span> <span class="text-h3 font-semibold text-foreground"> 0 </span> </div> </div> </div> </div>  <div class="col-span-2 bg-white dark:bg-slate-950 rounded-lg border border-border p-6"> <div class="space-y-4">  <div class="pb-4 border-b border-border/50"> <p class="font-medium uppercase tracking-wide text-muted-foreground" style="font-family: fragmentMono, monospace; font-size: 12px;">
Events
</p> </div>  <div class="flex gap-3 py-3 border-b border-border/30 last:border-b-0 opacity-100">  <div class="flex-shrink-0 pt-1"> <span class="inline-block w-2 h-2 rounded-full mt-1.5 bg-primary"></span> </div> <span class="sr-only"> Past:  </span>  <div class="flex-1 min-w-0"> <p class="text-body-sm text-foreground"> YouTube Video published </p> <p class="text-body-xs text-muted-foreground mt-1"> 13/03/2026, 20.44 </p> </div> </div><div class="flex gap-3 py-3 border-b border-border/30 last:border-b-0 opacity-100">  <div class="flex-shrink-0 pt-1"> <span class="inline-block w-2 h-2 rounded-full mt-1.5 bg-primary"></span> </div> <span class="sr-only"> Past:  </span>  <div class="flex-1 min-w-0"> <p class="text-body-sm text-foreground"> LinkedIn post published </p> <p class="text-body-xs text-muted-foreground mt-1"> 12/03/2026, 07.30 </p> </div> </div><div class="flex gap-3 py-3 border-b border-border/30 last:border-b-0 opacity-100">  <div class="flex-shrink-0 pt-1"> <span class="inline-block w-2 h-2 rounded-full mt-1.5 bg-primary"></span> </div> <span class="sr-only"> Past:  </span>  <div class="flex-1 min-w-0"> <p class="text-body-sm text-foreground"> Blog post published </p> <p class="text-body-xs text-muted-foreground mt-1"> 23/02/2026, 13.05 </p> </div> </div> </div> </div> </div>  <div class="mt-8 text-center"> <a class="inline-block px-6 py-2 bg-primary text-primary-foreground rounded-full hover:bg-primary/90 transition-colors font-medium text-body-sm" href="/updates">
View more updates →
</a> </div> </div> </section>   <footer class="bg-muted border-t border-border mt-auto"> <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12"> <div class="grid grid-cols-1 md:grid-cols-3 gap-8">  <div> <h3 class="text-h3 font-semibold text-foreground mb-4">About</h3> <p class="text-body-sm text-muted-foreground">
Deep dives on Product Analytics, Event data, Metric Trees and operational nerdiness.
</p> </div>  <div> <h3 class="text-h3 font-semibold text-foreground mb-4">Quick Links</h3> <ul class="space-y-2"> <li><a class="text-body-sm text-muted-foreground hover:text-primary transition-colors" href="/blog">Blog</a></li> <li><a class="text-body-sm text-muted-foreground hover:text-primary transition-colors" href="/courses">Courses</a></li> <li><a class="text-body-sm text-muted-foreground hover:text-primary transition-colors" href="/books/analytics-workbook">Book</a></li> <li><a class="text-body-sm text-muted-foreground hover:text-primary transition-colors" href="/privacy">Privacy Policy</a></li> </ul> </div>  <div> <h3 class="text-h3 font-semibold text-foreground mb-4">Connect</h3> <div class="flex space-x-4"> <a class="text-muted-foreground hover:text-primary transition-colors" href="https://www.linkedin.com/in/timo-dechau/" rel="noopener noreferrer" target="_blank"> LinkedIn </a><a class="text-muted-foreground hover:text-primary transition-colors" href="https://www.youtube.com/@timodechau" rel="noopener noreferrer" target="_blank"> YouTube </a> </div> </div> </div> <div class="mt-8 pt-8 border-t border-border text-center space-y-2"> <p class="text-body-sm text-muted-foreground">
© 2026 Timo Dechau. All rights reserved.
</p> <p class="text-body-sm text-muted-foreground">
Deepskydata ApS, Helenavej 31, 9210 Aalborg, Denmark, CVR: 41813180
</p> </div> </div> </footer>      &gt;&gt;&gt;&gt;&amp;&amp;&gt;', 'https://timo.space/favicon.svg', 'en', 'tech', 'opensource,startup,mobile',
  'rejected', 'unknown', 60, '2026-03-14T11:40:21.195257Z', NULL,
  0, 'opml_import', 'no_feed_entries', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'bc7990f7-6e72-55e8-b46a-a3e23687a26a', 'https://fly.io/blog/feed.xml', 'https://fly.io/blog', 'The Fly Blog',
  'News, tips, and tricks from the team at Fly', 'https://fly.io/static/images/favicon/favicon.ico', 'en', 'other', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:22.132054Z', '2026-03-10T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '76c58ce6-288c-5400-9289-d00d9da25caa', 'https://feed.priority.vision/rss', 'https://feed.priority.vision/', 'Feed',
  'A fast-paced, social media-style theme designed for tech news, startup updates, and digital innovation coverage.', 'https://feed.priority.vision/content/images/size/w256h256/2025/07/site-icon-2.png', 'en', 'tech', 'startup',
  'rejected', 'rss20', 60, '2026-03-14T11:40:20.833648Z', '2025-07-23T04:03:00Z',
  0, 'opml_import', 'generic_or_invalid_title', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2d1ad861-1d50-5f8d-a1a4-d0f949341546', 'https://www.fabricatedknowledge.com/feed', 'https://www.fabricatedknowledge.com/', 'Fabricated Knowledge',
  'Let''s learn more about the world''s most important manufactured product. Meaningful insight, timely analysis, and an occasional investment idea.', 'https://substackcdn.com/image/fetch/$s_!hLkx!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F0a321451-9d55-4042-9d3b-7ab4980aa2d0%2Ffavicon.ico', 'en', 'finance', 'investing,product,analysis',
  'active', 'rss20', 60, '2026-03-14T11:40:21.187447Z', '2026-02-16T17:13:23Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'finance,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b362c0ca-ed62-5991-9670-de8601107511', 'https://ounapuu.ee/index.xml', 'https://ounapuu.ee/', './techtipsy',
  'Recent content on ./techtipsy, a blog written by Herman Õunapuu.', 'https://ounapuu.ee/apple-touch-icon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:23.636740Z', '2026-03-11T04:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '4af7bf95-330c-5436-ba57-e8e7d7fc3926', 'https://blog.sigplan.org/feed', 'https://blog.sigplan.org/', 'SIGPLAN Blog',
  'The Blog of the ACM Special Interest Group on Programming Languages', 'https://blog.sigplan.org/favicon.ico', 'en', 'tech', 'programming',
  'hidden', 'rss20', 60, '2026-03-14T11:40:21.799318Z', '2025-09-16T13:09:36Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '88cc00a7-3f00-5df0-a043-fbf660a68ac1', 'https://resobscura.substack.com/feed', 'https://resobscura.substack.com/', 'Res Obscura',
  'Notes on the history of technology, medicine, science, art, drugs, and empire. Also: AI in research and teaching.', 'https://substackcdn.com/image/fetch/$s_!Kiyx!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd9583a0a-25ef-4908-8c18-900128cf7ea6%2Ffavicon.ico', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:22.689186Z', '2026-02-24T14:12:37Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ff204903-3980-5192-9bcc-4a0a9d63591e', 'https://joinreboot.org/feed', 'https://joinreboot.org/', 'Reboot',
  'A publication by and for technologists.', 'https://substackcdn.com/image/fetch/$s_!vFNc!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fad3a7a26-f4b3-43e6-9fde-abbcf7956cef%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:22.635592Z', '2026-03-12T16:17:36Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1272eb47-d609-5805-ae1e-e90ed76d1906', 'https://snarky.ca/rss', 'https://snarky.ca/', 'Tall, Snarky Canadian',
  'Python core developer. Tall, snarky Canadian.', 'https://snarky.ca/content/images/size/w256h256/2021/04/Profile-2017-cropped-min.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:23.309764Z', '2026-03-02T19:28:41Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6766a930-c37f-54cf-8c2a-943fc773a745', 'https://hunterwalk.com/feed', 'https://hunterwalk.com/', 'Hunter Walk',
  'Self-Aware Self-Promotion', 'https://s0.wp.com/i/webclip.png', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:22.021421Z', '2026-03-12T23:01:46Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '824a4d5d-6f12-5833-8539-832ea08eccc1', 'https://blog.fal.ai/rss', 'https://blog.fal.ai/', 'fal.ai Blog | Generative AI Model Releases & Tutorials',
  'Latest generative AI  model releases and tutorials. FLUX updates, video AI breakthroughs, developer guides, and industry insights from fal.ai.', 'https://blog.fal.ai/content/images/size/w256h256/2024/09/Fal-Branding-2024--1-.png', 'en', 'tech', 'ai,ux,tutorial',
  'active', 'rss20', 60, '2026-03-14T11:40:23.896325Z', '2026-03-02T21:04:48Z',
  0, 'opml_import', 'auto_approved', 'video', 'tech,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '722991f4-86b1-58d5-8b02-51d9e3b03607', 'https://sigwait.org/~alex/blog/rss.xml', 'https://sigwait.org/~alex/blog', 'Alexander Gromnitsky''s Blog',
  'Пограмування, ойті, витяги, цитати', 'https://sigwait.org/~alex/favicon.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:23.435463Z', '2025-12-07T14:19:47Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ad9a3202-174f-55ff-91c4-a1164950025a', 'https://www.tomorrowsbriefing.news/rss', 'https://www.tomorrowsbriefing.news/', 'Tomorrow''s Briefing',
  'A guide to AI’s impact on Business & Finance, Tech, Entertainment, Beauty, Fashion, Health, Food & Beverage, Sports, Gaming, Travel, Politics, and Legal. With insights and updates to keep you ahead!', 'https://www.tomorrowsbriefing.news/content/images/size/w256h256/2025/04/TB-s-LOGO.png', 'en', 'tech', 'tutorial',
  'active', 'rss20', 60, '2026-03-14T11:40:23.889247Z', '2026-03-13T13:00:14Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'a3f5e4d4-a42e-570c-8843-36e49c9316f7', 'https://www.forethought.org/feed', 'https://www.forethought.org/', 'Forethought',
  'Forethought', 'https://www.forethought.org/favicon-96x96.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:22.697505Z', '2026-03-13T05:02:00Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f594d5f4-e4bd-5c46-9926-0b336be83f49', 'https://brajeshwar.com/feed.xml', 'https://brajeshwar.com/', 'Brajeshwar',
  'I’m on an adventure to create beautiful, meaningful products that improve the world for my daughters and their friends.', 'https://brajeshwar.com/favicon.ico', 'en', 'finance', 'startup,product',
  'active', 'atom10', 60, '2026-03-14T11:40:22.701874Z', '2026-03-03T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'finance'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e7efd748-b685-5ebd-85c4-d29909f63369', 'https://www.agwa.name/blog/feed', 'https://www.agwa.name/blog', 'Andrew Ayer - Blog',
  NULL, 'https://www.agwa.name/favicon.png', 'en', 'other', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:24.204969Z', '2026-02-19T12:25:21Z',
  0, 'opml_import', 'missing_description', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '93226eb2-27f6-5792-a067-eea8d20b0b8d', 'https://hyperdev.matsuoka.com/feed', 'https://hyperdev.matsuoka.com/', 'Hyperdev',
  'HyperDev is a technical publication exploring practical agentic AI development and AI-powered coding tools. As a veteran technology executive with 25+ years of experience, I provide honest, hands-on reviews and strategic insights about which AI coding too', 'https://substackcdn.com/image/fetch/$s_!yy-C!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa531e34b-eca3-4f38-9a17-d604bf24ac79%2Ffavicon.ico', 'en', 'tech', 'ai,programming,product',
  'active', 'rss20', 60, '2026-03-14T11:40:24.442695Z', '2026-03-12T11:32:09Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c9f4ecc0-4e36-5895-90fe-5a6b3e52d1db', 'https://www.aitidbits.ai/feed', 'https://www.aitidbits.ai/', 'AI Tidbits',
  'Stay ahead on the latest in AI through weekly summaries and editorial deep dives providing unique perspectives on recent developments', 'https://substackcdn.com/image/fetch/$s_!dv3p!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F93617903-d317-4b92-99f0-601c4accc2bc%2Ffavicon.ico', 'en', 'tech', 'ai,product,weekly',
  'hidden', 'rss20', 60, '2026-03-14T11:40:23.673720Z', '2025-12-03T15:31:22Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '319eaf35-d796-58d6-b54d-b34ed82cf479', 'https://kk.org/thetechnium/feed', 'https://kk.org/thetechnium', 'The Technium',
  'Making the Inevitable Obvious', 'https://kk.org/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:24.530225Z', '2026-03-02T11:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '99f3fa75-af91-588f-8f89-a92380db360d', 'https://thechipletter.substack.com/feed', 'https://thechipletter.substack.com/', 'The Chip Letter',
  'Computer history and architecture', 'https://substackcdn.com/image/fetch/$s_!hu-M!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fadc34161-9aa4-4560-a614-812bc2c80621%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:23.887423Z', '2026-03-11T01:01:15Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '91f4db3a-eebd-55b9-8642-be4c4627fb39', 'https://george.mand.is/feed.xml', 'https://george.mand.is/', 'George Mandis',
  'This is my blog where I write about web development and travel.', 'https://george.mand.is/apple-touch-icon.png', 'en', 'tech', 'webdev,product',
  'hidden', 'rss20', 60, '2026-03-14T11:40:25.280123Z', '2025-09-21T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,travel'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1e4214a5-421b-5d4c-b8bd-a78191018c68', 'https://feeds.feedburner.com/LarsLofgren', 'https://larslofgren.com/', 'Lars Lofgren',
  'Building Online Businesses', 'https://larslofgren.com/wp-content/uploads/2024/06/Lars-Lofgren_Favicon_Black.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:27.439314Z', '2026-01-22T16:57:10Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '0d3cccb4-4856-50c3-8a16-1b847d7d1a9a', 'https://2ndbreakfast.audreywatters.com/rss', 'https://2ndbreakfast.audreywatters.com/', 'Second Breakfast',
  'Ed-Tech Criticism. AI Refusal.', 'https://2ndbreakfast.audreywatters.com/content/images/2024/12/favicon.ico', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:26.251164Z', '2026-03-09T09:00:42Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '16b6c247-eaa0-5b48-af76-d6190b8dfeee', 'https://www.chitika.com/rss', 'https://www.chitika.com/', 'Chitika: Explore Retrieval Augmented Generation Trends',
  'Discover the latest in Retrieval Augmented Generation. Our RAG magazine covers everything from research updates to real-world applications.', 'https://www.chitika.com/content/images/size/w256h256/2025/01/Untitled-design--48-.png', 'en', 'science', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:26.179017Z', '2025-04-22T20:12:48Z',
  0, 'opml_import', 'stale_feed', 'research', 'science,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '3c7cf017-fd5c-59b0-800d-e847b9727663', 'https://yehudakatz.com/rss', 'https://yehudakatz.com/', 'Katz Got Your Tongue',
  'Long-form writing by Yehuda Katz, co-creator of Ember.js and serial Open Sourcerer.', 'https://yehudakatz.com/content/images/2024/08/yehuda-square.png', 'en', 'other', 'opensource',
  'hidden', 'rss20', 60, '2026-03-14T11:40:24.571504Z', '2024-10-28T22:57:29Z',
  0, 'opml_import', 'stale_feed', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '51cd68f7-66d9-5041-b9e2-3bedd2fd8e47', 'https://labnotes.org/rss', 'https://labnotes.org/', 'Labnotes (by Assaf Arkin)',
  '🔥 All about software design, development, and culture. A mix of insightful and funny. Goes great with coffee. ☕', 'https://labnotes.org/content/images/size/w256h256/2025/03/Cartoon-2.png', 'en', 'tech', 'product',
  'active', 'rss20', 60, '2026-03-14T11:40:24.525890Z', '2026-03-08T16:49:04Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e070f18d-d20e-5573-b3a0-a1c8b4ea3629', 'https://ftw.pi.tv/rss', 'https://ftw.pi.tv/', 'Fashion Tech Weekly',
  'A handpicked roundup of the week’s top fashion tech stories.', 'https://ftw.pi.tv/content/images/size/w256h256/format/jpeg/2025/08/PI-Favicon-FashionTechWeekly.jpg', 'en', 'tech', 'curation,weekly',
  'active', 'rss20', 60, '2026-03-14T11:40:26.071701Z', '2026-03-09T13:30:36Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,entertainment'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '88a2b1dd-ac3f-5ba9-812f-0c370c0ed661', 'https://www.jvandemo.com/rss', 'https://www.jvandemo.com/', 'Jvandemo.com',
  'Hi, I''m Jurgen Van de Moere | Front-end Architect | Specializing in JavaScript & Angular | Developer Expert @Google | Principal Engineer @Showpad', 'https://www.jvandemo.com/favicon.ico', 'en', 'tech', 'webdev,frontend',
  'hidden', 'rss20', 60, '2026-03-14T11:40:25.881617Z', '2026-01-03T17:29:19Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'bb09724c-735d-5a17-881e-39bcd0710b5f', 'https://tigerbeetle.com/blog/atom.xml', 'https://tigerbeetle.com/blog', 'TigerBeetle Blog',
  'Insights, updates, and technical deep dives on building a high-performance financial transactions database.', 'https://tigerbeetle.com/blog/img/icon.png', 'en', 'tech', 'data,advanced',
  'active', 'atom10', 60, '2026-03-14T11:40:25.282350Z', '2026-02-16T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f4cb4598-37fe-5944-9b35-93a0772a16f1', 'https://www.kevinrichard.ch/rss', 'https://www.kevinrichard.ch/', 'Kevin Richard – Island of thoughts',
  'Curious exploration. Design & Critical thinking.', 'https://www.kevinrichard.ch/content/images/size/w256h256/2020/09/rawpixel-656748-unsplash-square-1.png', 'en', 'design', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:25.877064Z', '2025-09-07T19:23:02Z',
  0, 'opml_import', 'stale_feed', 'blog', 'design,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5ce56897-7983-5be2-ab78-9bb6d0e37e1d', 'https://manuelmoreale.com/feed/rss', 'https://manuelmoreale.com/interview/patrick-rhone', 'Manuel Moreale — Everything Feed',
  'Thoughts, Pictures, Interviews, and everything else I publish on my blog', 'https://manuelmoreale.com/favicon.ico', 'en', 'automotive', 'interview',
  'active', 'rss20', 60, '2026-03-14T11:40:28.205178Z', '2026-03-13T12:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8b62c979-70bb-5346-a27a-2e6fbc69472a', 'https://aspiringforintelligence.substack.com/feed', 'https://aspiringforintelligence.substack.com/', 'Aspiring for Intelligence',
  'The latest themes, trends, and news in the world of intelligent applications', 'https://substackcdn.com/image/fetch/$s_!el8U!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F35cf2385-f90b-4277-9e1f-b4fe40b1b725%2Ffavicon.ico', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:26.056808Z', '2026-03-13T15:30:44Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5163723c-86ec-5c9c-9465-bc252ccf88c0', 'https://www.a16z.news/feed', 'https://www.a16z.news/', 'a16z',
  'It''s time to build.', 'https://substackcdn.com/image/fetch/$s_!ynep!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F39a4e8ca-baad-4811-b30a-c3144e770475%2Ffavicon.ico', 'en', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:25.304143Z', '2026-03-13T14:03:19Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'design,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2af274cb-3803-5dcb-ae9f-cec779a38c39', 'https://moq.dev/rss.xml', 'https://moq.dev/', 'moq.dev | Blog',
  'Latest posts about Media over QUIC and real-time media streaming', 'https://moq.dev/layout/favicon.svg', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:24.903076Z', '2026-02-26T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '99bf1d33-b848-54ec-ab0f-afbdb74efede', 'https://sigh.dev/posts/rss.xml', 'https://sigh.dev/', 'sigh.dev - Scott Cooper''s dev blog - Posts',
  'sigh.dev is Scott Cooper''s dev blog about TypeScript, React, San Francisco, and the web. - Blog posts', 'https://sigh.dev/icon.svg', 'en', 'automotive', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:25.626672Z', '2026-01-25T08:00:00Z',
  0, 'opml_import', 'stale_feed', 'news', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2254a44e-53b3-53fd-b78d-40fda9c34f94', 'https://www.kenst.com/rss', 'https://www.kenst.com/', 'Shattered Illusions',
  'Shattering the illusions around how things work', 'https://www.kenst.com/content/images/size/w256h256/2022/09/circle-cropped-1.png', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:27.695369Z', '2026-02-02T22:38:03Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f3304998-3224-59a3-bff6-0691299e1678', 'https://onelayerdeeper.substack.com/feed', 'https://onelayerdeeper.substack.com/', 'One Layer Deeper',
  'Cutting through the AI noise with deep dives, sharp takes, and the occasional wild bet on the future.
Every week, I unpack one core AI topic from a technical angle — exploring the edge cases no one else talks about.', 'https://substackcdn.com/image/fetch/$s_!ZLce!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F36af29e4-5c57-4e41-b706-6fa632ca9927%2Ffavicon.ico', 'en', 'tech', 'ai,advanced',
  'hidden', 'rss20', 60, '2026-03-14T11:40:26.625280Z', '2026-01-16T09:01:53Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '24c7cfa1-55ce-514e-8f04-f7cb37400336', 'https://review.firstround.com/articles/rss', 'https://review.firstround.com/', 'First Round',
  'The most actionable, tactical company building advice around for founders and startup leaders.', 'https://review.firstround.com/content/images/size/w256h256/format/png/2024/03/First-Round-icon-blk.svg', 'en', 'business', 'startup',
  'active', 'rss20', 60, '2026-03-14T11:40:26.540662Z', '2026-03-10T14:27:16Z',
  0, 'opml_import', 'auto_approved', 'magazine', 'business,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '058f78b3-f0a5-5873-90fc-d2f71b1b3411', 'https://blog.codinghorror.com/rss', 'https://blog.codinghorror.com/', 'Coding Horror',
  'programming and human factors', 'https://blog.codinghorror.com/content/images/size/w256h256/2020/06/3cffc4b347c3587f19fe222caaac69f63b9a5e73.png', 'en', 'tech', 'programming',
  'active', 'rss20', 60, '2026-03-14T11:40:26.374165Z', '2026-02-04T07:43:56Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6036a429-6d35-548f-b51f-e33bb741d2ce', 'https://jxnl.co/feed_rss_created.xml', 'https://jxnl.co/', 'Jason Liu',
  'Applied AI, RAG, and personal notes.', 'https://jxnl.co/assets/images/favicon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:26.542615Z', '2026-02-02T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '99120d26-1071-5a0e-9fbd-4148e9123a4f', 'https://wickstrom.tech/feed.xml', 'https://wickstrom.tech/', 'Oskar Wickström',
  'Software design, testing, functional programming, and other delightful things.', 'https://wickstrom.tech/assets/icon.png', NULL, 'tech', 'programming',
  'hidden', 'atom10', 60, '2026-03-14T11:40:28.956227Z', '2026-01-27T23:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '9e14f420-122b-5caf-b294-c4b9888a1b73', 'https://gabrielweinberg.com/feed', 'https://gabrielweinberg.com/', 'Gabriel Weinberg',
  'Founder of DuckDuckGo and co-author of Traction and Super Thinking. Here I mainly write about progress, AI, and DuckDuckGo.', 'https://substackcdn.com/image/fetch/$s_!wemc!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F409752e4-3fd1-45fd-963b-dcab2e4e369f%2Ffavicon.ico', 'en', 'tech', 'startup',
  'active', 'rss20', 60, '2026-03-14T11:40:29.257501Z', '2026-02-28T14:02:36Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '46404673-a648-55ad-a186-336ad2e724d7', 'https://denodell.com/rss.xml', 'https://denodell.com/', 'Den Odell’s Journal',
  'Thoughts on building fast, accessible, and resilient web apps — drawn from years of real-world experience, a couple of books, and a lot of hard lessons. Expect deep dives, practical tips, a bit of history, and the occasional opinionated take on where the web is going.', 'https://denodell.com/images/icons/favicon.png', 'en', 'design', 'opinion,advanced',
  'active', 'rss20', 60, '2026-03-14T11:40:26.322489Z', '2026-02-23T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6d8b72a8-0829-56b6-b0b8-c2c73df213a0', 'https://www.noahpinion.blog/feed', 'https://www.noahpinion.blog/', 'Noahpinion',
  'Economics and other interesting stuff', 'https://substackcdn.com/image/fetch/$s_!gj67!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Fa242bd04-28e0-4418-8968-e96e069a8358%2Ffavicon.ico', 'en', 'media', 'economy',
  'active', 'rss20', 60, '2026-03-14T11:40:26.570714Z', '2026-03-12T19:41:06Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c3f04c4f-cf6f-5644-ae11-75cdf300a425', 'https://bcho.tistory.com/rss', 'https://bcho.tistory.com/', '조대협의 블로그',
  '실리콘밸리에서 살고 있는 평범한 엔지니어 입니다
이메일-bwcho75골뱅이지메일 닷컴.
아키텍처 디자인, 머신러닝 시스템, 빅데이터 설계, DEVOPS/SRE, 애자일 방법론,쿠버네티스,마이크로서비스, ChatGPT 생성형 AI , CTO 등에 대한 기술 멘토링과 강의 진행합니다.

Linkedin : https://www.linkedin.com/in/terrycho75/', 'https://t1.daumcdn.net/tistory_admin/favicon/tistory_favicon_32x32.ico', 'ko', 'tech', 'ai,devops',
  'active', 'rss20', 60, '2026-03-14T11:40:27.649662Z', '2026-03-14T06:51:03Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5c153a22-fe14-58aa-88b9-7ba49d2a8a92', 'https://news.smol.ai/rss.xml', 'https://news.smol.ai/', 'AINews',
  'Weekday recaps of top News for AI Engineers', 'https://news.smol.ai/favicon.ico', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:27.660570Z', '2026-03-03T05:44:39Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '135d8e26-464e-5ca2-80e1-426e85776456', 'https://steveblank.com/feed', 'https://steveblank.com/', 'Steve Blank',
  'Innovation and Entrepreneurship', 'https://s0.wp.com/i/webclip.png', 'en', 'automotive', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:27.725239Z', '2026-02-24T14:00:57Z',
  0, 'opml_import', 'auto_approved', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '47f0d3e8-3967-5e94-b3d4-2fc7d0a0e359', 'https://www.maximum-progress.com/feed', 'https://www.maximum-progress.com/', 'Maximum Progress',
  'Maximum Progress is a blog by Max Tabarrok on economics, science, philosophy, and progress.', 'https://substackcdn.com/image/fetch/$s_!szj2!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F3d0ffaf8-6f88-43cb-8838-2c6f8719ceb2%2Ffavicon.ico', 'en', 'science', 'economy',
  'hidden', 'rss20', 60, '2026-03-14T11:40:28.588096Z', '2026-01-16T14:10:21Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'science,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b988209f-ed19-5015-a550-accf91eebcd2', 'https://tomtunguz.com/index.xml', 'https://tomtunguz.com/', 'Tomasz Tunguz',
  'Recent content on Tomasz Tunguz', 'https://tomtunguz.com/favicon.ico', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:28.710872Z', '2026-03-13T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'eed12ae9-c72b-53d7-9cc3-0445d255f548', 'https://medium.com/feed/data-science-in-your-pocket', 'https://medium.com/data-science-in-your-pocket?source=rss----60130df77e02---4', 'Data Science in Your Pocket - Medium',
  'YouTube : https://www.youtube.com/@datascienceinyourpocket - Medium', 'https://medium.com/favicon.ico', NULL, 'science', 'data',
  'active', 'rss20', 60, '2026-03-14T11:40:28.209735Z', '2026-03-14T07:28:49Z',
  0, 'opml_import', 'auto_approved', 'video', 'science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '84a7f8b1-58bb-5ebc-b5ae-8938234def18', 'https://matduggan.com/rss', 'https://matduggan.com/', 'matduggan.com',
  'It''s JSON all the way down', 'https://matduggan.com/content/images/2024/01/favicon.ico', 'en', 'fashion', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:30.996864Z', '2026-03-10T09:26:47Z',
  0, 'opml_import', 'auto_approved', 'blog', 'fashion'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '670cc27e-60ca-5a20-8d12-fcbe56eed50e', 'https://john.onolan.org/rss', 'https://john.onolan.org/', 'John O''Nolan',
  'Founder/CEO @ Ghost.org — Geographically restless. Publishing, open source, and independent business around the world.', 'https://john.onolan.org/assets/icon.svg?v=17cb94f893', 'en', 'business', 'opensource,startup',
  'active', 'rss20', 60, '2026-03-14T11:40:28.621535Z', '2026-02-26T17:28:52Z',
  0, 'opml_import', 'auto_approved', 'blog', 'business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f643a322-c02b-5606-86df-51ab67e6af10', 'https://medium.com/feed/@julsimon', 'https://medium.com/@julsimon?source=rss-4ffe14103b7a------2', 'Stories by Julien Simon on Medium',
  'Stories by Julien Simon on Medium', 'https://medium.com/favicon.ico', NULL, 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:28.966671Z', '2026-03-13T17:56:51Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '040a8a35-fc99-517b-bd25-bb9dc2551956', 'https://99percentinvisible.org/feed', 'https://99percentinvisible.org/', '99% Invisible',
  'A Tiny Radio Show About Design with Roman Mars', 'https://99percentinvisible.org/wp-content/uploads/2016/06/cropped-favicon_512-32x32.png', 'en', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:28.724396Z', '2026-03-10T17:15:08Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2cbf241c-c8ef-5004-a4a5-d6f20f7252d6', 'https://blog.crewai.com/rss', 'https://blog.crewai.com/', 'CrewAI',
  'Explore the Future of AI Agents with Us', 'https://blog.crewai.com/content/images/size/w256h256/format/png/2024/10/favicon.svg', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:28.716093Z', '2026-03-05T18:28:17Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '9d28139f-4c75-513c-ae52-8dc7d5b873ab', 'https://www.wreflection.com/feed', 'https://www.wreflection.com/', 'Wreflection',
  'Business, Tech, and the Business of Tech.', 'https://substackcdn.com/image/fetch/$s_!A2Pa!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F77cbfd09-2ccf-42fc-85f1-47e8ef325e72%2Ffavicon.ico', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:28.503515Z', '2025-12-24T16:04:17Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'a234088d-be78-5da3-88c2-cd3a98d87e0a', 'https://www.content-technologist.com/rss', 'https://www.content-technologist.com/', 'The Content Technologist',
  'A resource for content professionals working in the age of algorithms', 'https://www.content-technologist.com/content/images/size/w256h256/2020/12/content-technologist-icon--1--1.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:31.964537Z', '2026-01-12T17:03:54Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'fd871040-3602-57dd-a9c6-599cffe38440', 'https://herman.bearblog.dev/feed', 'https://herman.bearblog.dev/', 'Herman''s blog',
  'Hi I''m Herman Martinus. I''m a maker of things, rider of bikes, and hiker of mountains.', 'https://bearblog.dev/static/favicon.svg', 'en', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:28.861523Z', '2026-02-24T11:43:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6308cb43-b69e-5e15-8079-56bdcb83e555', 'https://giuliomagnifico.blog/index.xml', 'https://giuliomagnifico.blog/', '/home/⏎',
  'Recent content on /home/⏎', 'https://giuliomagnifico.blog/img/apple-touch-icon.png', 'en', 'other', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:30.699864Z', '2026-01-02T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '968db885-07b5-53cd-a6de-ea1d22e7b6be', 'https://probablydance.com/feed', 'https://probablydance.com/', 'Probably Dance',
  'I can program and like games', 'https://s1.wp.com/i/favicon.ico?m=1713425267i', 'en', 'gaming', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:29.368936Z', '2026-03-07T15:51:58Z',
  0, 'opml_import', 'auto_approved', 'blog', 'gaming'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e7a5bb52-1a7a-5493-bdc1-4aae7be05579', 'https://blog.jim-nielsen.com/feed.xml', 'https://blog.jim-nielsen.com/', 'Jim Nielsen’s Blog',
  'Writing about the big beautiful mess that is making things for the world wide web.', 'https://blog.jim-nielsen.com/favicon.ico', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:29.378711Z', '2026-03-08T19:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '16f2d4d2-37db-5224-a235-eac6041216bc', 'https://axbom.com/rss', 'https://axbom.com/', 'Axbom • My Next Heartbeat',
  'Designer, writer, teacher and UX Ethicist highlighting the human and systemic impact of tech', 'https://axbom.com/content/images/size/w256h256/2025/07/axbom-favicon-2025.png', 'en', 'tech', 'ux',
  'active', 'rss20', 60, '2026-03-14T11:40:31.634723Z', '2026-03-02T20:08:28Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '73b67560-14f7-5115-be47-b5f8753575a8', 'https://mahadk.com/rss.xml', 'https://mahadk.com/', 'Mahad Kalam',
  'Mahad Kalam (@skyfall)''s personal website. I ramble about Rust, TypeScript, web dev, and more!', 'https://mahadk.com/favicon-32x32.png', 'en', 'automotive', 'webdev',
  'active', 'rss20', 60, '2026-03-14T11:40:29.376469Z', '2026-02-13T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5b8c253e-ec82-524a-aff4-3c4ae90cb1bc', 'https://pluralistic.net/feed', 'https://pluralistic.net/', 'Pluralistic: Daily links from Cory Doctorow',
  'No trackers, no ads. Black type, white background. Privacy policy: we don''t collect or retain any data at all ever period.', 'https://i0.wp.com/pluralistic.net/wp-content/uploads/2020/02/cropped-guillotine-French-Revolution.jpg?fit=32%2C32&ssl=1', 'en', 'tech', 'data,curation,daily',
  'active', 'rss20', 60, '2026-03-14T11:40:31.820658Z', '2026-03-13T02:17:20Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '260bdbf2-fb86-501e-81c0-6107e0391840', 'https://ednutting.substack.com/feed', 'https://ednutting.substack.com/', 'Ed''s Substack',
  'My personal Substack where I post about my experiences as founder of a processor design startup.

My Substack is complementary to my Patreon and YouTube channels, where you can subscribe for my videos. I also write a free technical blog on my website.', 'https://substackcdn.com/icons/substack/favicon.ico', 'en', 'tech', 'startup',
  'hidden', 'rss20', 60, '2026-03-14T11:40:30.023646Z', '2025-09-16T09:28:22Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'de9ca402-7cc6-500d-85de-fa71b7b91682', 'https://shalomeir.substack.com/feed', 'https://shalomeir.substack.com/', 'shalomeir’s inside mode',
  '#해시태그 네트워크, 스닙팟 창업가 입니다. #스타트업 #테크 #인공지능 #정보검색 #SNS 에 대한 생각들을 전달합니다.', 'https://substackcdn.com/image/fetch/$s_!3zHF!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fccbc65ef-dbb9-4921-aa30-a7b9706c6ed3%2Ffavicon.ico', 'en', 'media', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:30.471237Z', '2025-09-25T23:40:28Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '82ca0f8f-59f5-5263-b188-912f81504de5', 'https://technicalwriting.dev/rss.xml', 'https://technicalwriting.dev/', 'technicalwriting.dev',
  'Field notes from the frontier of technical writing.', 'https://technicalwriting.dev/_static/logo.svg', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:29.728831Z', '2025-10-30T04:47:07Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ecfb7d28-8b23-57ca-a6ea-f24666d7effc', 'https://urlahmed.com/feed.xml', 'https://urlahmed.com/', '|',
  'Exploring technology, AI, and possible futures', 'https://urlahmed.com/favicon.ico', 'en', 'tech', 'opensource',
  'rejected', 'atom10', 60, '2026-03-14T11:40:30.348084Z', '2026-02-11T00:00:00Z',
  0, 'opml_import', 'generic_or_invalid_title', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '3a90ca76-1b3e-5e34-9802-496749d6a564', 'https://www.exponentialview.co/feed', 'https://www.exponentialview.co/', 'Exponential View',
  '"One of the best for understanding how tech can solve our biggest problems and shape our society." — Daniel Ek, CEO of Spotify', 'https://substackcdn.com/image/fetch/$s_!3KoR!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Faa7453ed-eb02-46d7-b523-74d86b1c1e24%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:30.742866Z', '2026-03-13T17:32:47Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,culture'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6ecac659-6267-55a9-b2d2-b7463ba93e8a', 'https://www.philmorton.co/rss', 'https://www.philmorton.co/', 'Phil Morton',
  'Leading product design and research teams. Sign up for my free newsletter, Desk Notes.', 'https://www.philmorton.co/content/images/size/w256h256/2025/02/Phil-Morton-square.jpeg', 'en', 'tech', 'product',
  'active', 'rss20', 60, '2026-03-14T11:40:30.523060Z', '2026-03-11T10:50:08Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '06e98526-3d68-5989-a10a-d943bd8232b6', 'https://www.sourcery.vc/feed', 'https://www.sourcery.vc/', 'Sourcery',
  'Top Weekly VC Deals & Tech Interviews', 'https://substackcdn.com/image/fetch/$s_!SqI1!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F7d25567a-2303-448b-8ce1-f43207adb9d5%2Ffavicon.ico', 'en', 'tech', 'interview,weekly',
  'active', 'rss20', 60, '2026-03-14T11:40:31.863419Z', '2026-03-13T17:20:12Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c05f7d13-0078-5e6b-8e84-7f2183cb117e', 'https://importai.substack.com/feed', 'https://importai.substack.com/', 'Import AI',
  'Import AI is a weekly newsletter about artificial intelligence based on detailed analysis of cutting-edge research.', 'https://substackcdn.com/image/fetch/$s_!ksbh!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F031520ec-8765-4d1b-a233-67c6fdb6258a%2Ffavicon.ico', 'en', 'tech', 'ai,analysis,weekly',
  'active', 'rss20', 60, '2026-03-14T11:40:30.452197Z', '2026-03-09T12:45:54Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f348aa63-fdd5-5003-af44-5ada8739599a', 'https://www.commits.world/feed', 'https://www.commits.world/', 'Commits',
  'Commits은 기업과 산업에 관한 흥미로운 글을 공유하는 커뮤니티입니다.

뉴스레터에 소개하지 못한 수많은 글들은 300+ 규모의 실명 카톡방에서 …', 'https://substackcdn.com/image/fetch/$s_!4bZR!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F982d469c-0fd5-4792-b6a1-535d70697e0f%2Ffavicon.ico', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:32.696154Z', '2026-03-12T12:21:43Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'a6f10f29-39f9-5cdb-be26-2cadc5e5ca89', 'https://adamsilver.io/atom.xml', 'https://adamsilver.io/', 'Adam Silver',
  'Sharing what I''ve learned.', 'https://adamsilver.io/assets/images/favicon/apple-touch-icon.png', 'en', 'design', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:31.327895Z', '2026-03-08T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c80ce096-e0e0-5f66-8677-52eea2e7468e', 'https://www.conduit.xyz/blog/rss', 'https://www.conduit.xyz/blog', 'Conduit Blog',
  'Updates from the Conduit team', 'https://www.conduit.xyz/blog/content/images/size/w256h256/2024/06/conduit-pfp-blue.png', 'en', 'science', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:35.633392Z', '2025-12-29T18:18:39Z',
  0, 'opml_import', 'stale_feed', 'research', 'science,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e0ff1368-c20a-5c6e-a8d9-f481a1986057', 'https://newsletter.pragmaticengineer.com/feed', 'https://newsletter.pragmaticengineer.com/', 'The Pragmatic Engineer',
  'Big Tech and startups, from the inside. Highly relevant for software engineers, AI engineers and engineering leaders, useful for those working in tech.', 'https://substackcdn.com/image/fetch/$s_!PIQa!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F9d53c70a-bdd3-4080-8425-9520ca6acfd4%2Ffavicon.ico', 'en', 'tech', 'ai,startup',
  'active', 'rss20', 60, '2026-03-14T11:40:32.314821Z', '2026-03-12T17:46:41Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '057aae03-aede-56e2-97ae-ea4a4e6f0d30', 'https://micahflee.com/rss', 'https://micahflee.com/', 'micahflee',
  'Hi, I''m Micah. I help journalists, researchers, and activists stay safe and productive.', 'https://micahflee.com/content/images/size/w256h256/2025/02/programming.png', 'en', 'science', 'product',
  'active', 'rss20', 60, '2026-03-14T11:40:31.335714Z', '2026-03-01T21:21:35Z',
  0, 'opml_import', 'auto_approved', 'research', 'science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd8c9a72b-74b1-568d-abea-3b052fdc45c2', 'https://blog.readymag.com/rss', 'https://blog.readymag.com/', 'Readymag Blog',
  'Everything you need to spring as a designer: website selections to nurture creativity, Readymag product updates to streamline your design workflow and tutorials to boost your skills', 'https://blog.readymag.com/content/images/size/w256h256/2022/08/Group-1.png', 'en', 'education', 'machine-learning,product,productivity',
  'active', 'rss20', 60, '2026-03-14T11:40:32.610767Z', '2026-03-10T16:11:37Z',
  0, 'opml_import', 'auto_approved', 'blog', 'education,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f84e883e-c450-56e6-a101-023480c08360', 'https://samwilkinson.io/rss.xml', 'https://samwilkinson.io/', 'Sam Wilkinson',
  'Sam Wilkinson''s personal blog', 'https://samwilkinson.io/favicon.ico', 'en', 'hobby', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:31.699454Z', '2026-01-27T19:42:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'hobby'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1174c65f-62bd-5d51-a2ab-c3e85dc9be95', 'https://www.quantamagazine.org/feed', 'https://www.quantamagazine.org/', 'Quanta Magazine',
  'Illuminating science', 'https://www.quantamagazine.org/wp-content/themes/quanta2024/frontend/images/favicon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:35.629036Z', '2026-03-13T14:37:02Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'acaa8bc1-46c6-53e4-8182-3f8f22724859', 'https://tidyfirst.substack.com/feed', 'https://tidyfirst.substack.com/', 'Software Design: Tidy First?',
  'Software design is an exercise in human relationships. So are all the other techniques we use to develop software. How can we geeks get better at technique as one way of getting better at relationships?', 'https://substackcdn.com/icons/substack/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:32.324122Z', '2026-03-04T15:52:09Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '68a39ae1-50a0-5c5d-9bfd-956c4025261f', 'https://blog-eu.bitflyer.com/rss', 'https://blog-eu.bitflyer.com/', 'bitFlyer Europe',
  'Europe Blog', 'https://blog-eu.bitflyer.com/content/images/size/w256h256/2021/12/bf-512-square.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:32.526052Z', '2025-02-17T09:42:30Z',
  0, 'opml_import', 'stale_feed', 'news', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '40224e85-8edc-5348-9295-38b4cdd5d9cc', 'https://terriblesoftware.org/feed', 'https://terriblesoftware.org/', 'Terrible Software',
  'Software | Engineering Leadership | Tech', 'https://i0.wp.com/terriblesoftware.org/wp-content/uploads/2024/12/android-chrome-512x512-2.png?fit=32%2C32&ssl=1', 'en', 'tech', 'leadership',
  'active', 'rss20', 60, '2026-03-14T11:40:32.017952Z', '2026-03-03T12:22:26Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '430d35e9-2f1c-5b56-9b27-c16b293684ce', 'https://samwho.dev/rss.xml', 'https://samwho.dev/', 'samwho.dev',
  'Personal website of Sam Rose.', 'https://samwho.dev/favicon.ico', 'en', 'automotive', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:35.703074Z', '2025-12-23T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd0fc0457-99eb-5a30-85fc-2fbea669f5f2', 'https://blog.samaltman.com/posts.atom', 'https://blog.samaltman.com/', 'Sam Altman',
  'Sam Altman', 'https://phthemes.s3.amazonaws.com/189/ocI2l2NFgWKLlp1H/images/favicon.ico?v=1496356566', 'en', 'other', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:37.006299Z', '2025-10-04T00:37:50Z',
  0, 'opml_import', 'stale_feed', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '00caf4bb-ccc4-5055-9731-61b601974d2e', 'https://morrick.me/feed', 'https://morrick.me/', 'Riccardo Mori',
  'Writer & Translator', 'https://i0.wp.com/morrick.me/wp-content/uploads/2017/10/cropped-new-R-logo-red-siteicon.png?fit=32%2C32&ssl=1', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:35.677115Z', '2026-03-03T19:12:57Z',
  0, 'opml_import', 'auto_approved', 'blog', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '053732dc-f9c7-5b3b-bf1e-c3ce3d987347', 'https://mitchellh.com/feed.xml', 'https://mitchellh.com/', 'Mitchell Hashimoto',
  'Mitchell Hashimoto''s personal website.', 'https://mitchellh.com/static/favicons/safari-pinned-tab.svg', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:32.100827Z', '2026-02-05T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '151053bc-d334-56cb-b802-849983724113', 'https://nickyoder.com/rss', 'https://nickyoder.com/', 'Nick Yoder',
  'Thoughts, stories and ideas', 'https://nickyoder.com/content/images/size/w256h256/2023/05/Logo-Invert.png', 'en', 'finance', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:36.893748Z', '2025-06-18T21:17:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'finance,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8fedcd84-31bb-5b32-bc50-3084bce5df97', 'https://blogbyash.com/feed', 'https://blogbyash.com/', 'blog by ash',
  'pieces of read, write, think', 'https://i0.wp.com/blogbyash.com/wp-content/uploads/2025/04/cropped-solid-color-image-1.png?fit=32%2C32&ssl=1', 'ko', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:36.796074Z', '2026-03-13T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1efe856f-0ca0-5133-bb93-025192cefcdb', 'https://snakecharmers.ethereum.org/rss', 'https://snakecharmers.ethereum.org/', 'Snake Charmers',
  'Python + Ethereum', 'https://snakecharmers.ethereum.org/content/images/size/w256h256/2022/12/snek2-headshot-2.png', 'en', 'other', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:36.046909Z', '2025-09-08T15:33:18Z',
  0, 'opml_import', 'stale_feed', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c975df0c-f42a-5243-8b9c-798cb86195bb', 'https://smallcultfollowing.com/babysteps/atom.xml', 'https://smallcultfollowing.com/babysteps', 'baby steps',
  NULL, 'https://smallcultfollowing.com/favicon.ico', 'en', 'other', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:35.525924Z', '2026-02-27T00:00:00Z',
  0, 'opml_import', 'missing_description', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '9f5810a2-33bd-57fc-8d75-c8e3a88423e3', 'https://engineering.nordeus.com/rss', 'https://engineering.nordeus.com/', 'Nordeus Engineering',
  'Nordeus Engineering Blog', 'https://engineering.nordeus.com/content/images/size/w256h256/2025/05/apple-touch-icon.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:39.152439Z', '2025-12-03T09:52:11Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,gaming'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '7dadc1e7-313b-56f6-9f3c-17a3179fad51', 'https://overreacted.io/rss.xml', 'https://overreacted.io/', 'overreacted — A blog by Dan Abramov',
  'A blog by Dan Abramov', 'https://overreacted.io/icon.png?e0852c1e2c7f0e65', 'en', 'other', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:35.028401Z', '2026-01-18T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '54b5fd52-a3b5-5c40-9285-5c9a410d1eab', 'https://mikefisher.substack.com/feed', 'https://mikefisher.substack.com/', 'Fish Food for Thought',
  'Thoughts on people, process, and technology', 'https://substackcdn.com/image/fetch/$s_!Ltdo!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F67efda01-59bc-43fc-856e-aa7f45857342%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:36.159600Z', '2026-03-11T13:01:24Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,food'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5df394aa-8c0a-5a65-b0ca-3a005483c817', 'https://www.notboring.co/feed', 'https://www.notboring.co/', 'Not Boring by Packy McCormick',
  'Tech strategy, analysis, and philosophy, but not boring.', 'https://substackcdn.com/image/fetch/$s_!N4Qz!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F5ec10a31-1fa7-415a-b2ae-53a71f17baed%2Ffavicon.ico', 'en', 'tech', 'analysis',
  'active', 'rss20', 60, '2026-03-14T11:40:35.600913Z', '2026-03-13T12:54:26Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '4f5f39c4-bdbe-5b01-912b-bf470b6768dd', 'https://pxdstory.tistory.com/rss', 'https://pxdstory.tistory.com/', 'pxd story',
  'UX에 관한 pxd사람들의 진지하거나 소소한 수다', 'https://story.pxd.co.kr/favicon.ico', 'ko', 'design', 'ux',
  'active', 'rss20', 60, '2026-03-14T11:40:36.744131Z', '2026-03-11T22:50:59Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'dfdc32d3-2a42-5d2d-a7bc-af41c5f1d8f5', 'https://www.mbi-deepdives.com/rss', 'https://www.mbi-deepdives.com/', 'MBI Deep Dives',
  'Investment Research', 'https://www.mbi-deepdives.com/content/images/size/w256h256/2022/07/Screenshot-2022-07-23-225436.png', 'en', 'finance', 'investing,advanced',
  'active', 'rss20', 60, '2026-03-14T11:40:37.443794Z', '2026-03-13T14:16:03Z',
  0, 'opml_import', 'auto_approved', 'research', 'finance,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'febc1c6a-18f7-587a-9c27-d04fbbe26576', 'https://www.worksinprogress.news/feed', 'https://www.worksinprogress.news/', 'The Works in Progress Newsletter',
  'New and underrated ideas to improve the world. Visit our website: worksinprogress.co', 'https://substackcdn.com/image/fetch/$s_!_4iA!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F1928a761-c368-4a01-adef-68f8656aa6fe%2Ffavicon.ico', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:36.754706Z', '2026-03-13T15:04:34Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b5f43ff5-2ccc-508d-9494-eea9ec0d6195', 'https://lyra.horse/blog/posts/index.xml', 'https://lyra.horse/blog/posts', 'lyra''s epic blog!',
  'lyra''s epic blog and its posts!', 'https://lyra.horse/favicon.ico', 'en', 'automotive', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:40.088875Z', '2025-12-04T14:00:00Z',
  0, 'opml_import', 'stale_feed', 'news', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '3f4390e8-d3da-544f-a89f-abf00e1012d4', 'https://ghuntley.com/rss', 'https://ghuntley.com/', 'Geoffrey Huntley',
  'It''s an uncertain time for our profession, but one thing is certain—things will change. Drafting used to require a room of engineers, but then CAD came along...', 'https://ghuntley.com/content/images/size/w256h256/format/jpeg/2026/02/A-black-and-white--low-angle-digital-illustration-in-a-symbolic-traditional-tattoo-art-style.--A-bald--light-skinned-man-with-a-bushy-beard--prominent-eyebrows--and-a-friendly-expression-wears-denim-overalls--2-.jpg', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:36.103292Z', '2026-03-12T18:55:07Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '7bf3cf08-5992-51b0-8618-1f7a6f370ef5', 'https://endler.dev/rss.xml', 'https://endler.dev/', 'Matthias Endler',
  'Consultant at corrode.dev. Likes just-in-time compilers and hot chocolate', 'https://endler.dev/favicon.ico', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:36.797236Z', '2026-01-26T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1b51a3eb-7ad5-55ce-b353-8746a373f92b', 'https://www.construction-physics.com/feed', 'https://www.construction-physics.com/', 'Construction Physics',
  'Essays about buildings, infrastructure, and industrial technology.', 'https://substackcdn.com/image/fetch/$s_!8lke!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F996cb600-c77d-471b-ac46-8a9a3aac5709%2Ffavicon.ico', 'en', 'tech', 'devops,opinion',
  'active', 'rss20', 60, '2026-03-14T11:40:39.190557Z', '2026-03-12T12:03:45Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '98aad2fa-fd16-5395-b93f-194c9a4f0bd7', 'https://morethanmoore.substack.com/feed', 'https://morethanmoore.substack.com/', 'More Than Moore',
  'The latest in semiconductors: silicon, AI, processors, market trends.', 'https://substackcdn.com/image/fetch/$s_!EHFZ!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F541804b9-69b6-4ae5-a11c-b3b299d59498%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:39.251963Z', '2026-03-09T14:59:49Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '514e41eb-e42d-5107-84bd-2fe219f46758', 'https://smartmic.bearblog.dev/feed', 'https://smartmic.bearblog.dev/', 'Martin''s blog',
  'Essays and notes on topics or things that cross my mind and that I consider important enough to write about.

I welcome any kind of response or feedback. W...', 'https://smartmic.bearblog.dev/favicon.ico', 'en', 'automotive', 'opensource,opinion',
  'hidden', 'atom10', 60, '2026-03-14T11:40:39.909298Z', '2025-11-30T21:12:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '97ff0b91-c243-54b7-a4ec-97a33d09d706', 'https://businessanalytics.substack.com/feed', 'https://businessanalytics.substack.com/', 'Business Analytics Review',
  'Stay at the forefront of business analytics with our weekly newsletter, ensuring you''re always ahead of the curve.', 'https://substackcdn.com/image/fetch/$s_!CKgU!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F92afe1ee-edf6-412f-89aa-336b3b648aa8%2Ffavicon.ico', 'en', 'business', 'data,review,weekly',
  'active', 'rss20', 60, '2026-03-14T11:40:39.242072Z', '2026-03-13T04:00:53Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'business,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1784b87d-66ca-57bf-a67d-b3d9f679594c', 'https://serpapi.com/blog/rss', 'https://serpapi.com/blog', 'SerpApi',
  'Search engine scraping tutorials, API updates and other tips.', 'https://serpapi.com/blog/content/images/size/w256h256/2021/07/serpapi-favicon.png', 'en', 'education', 'backend,tutorial',
  'active', 'rss20', 60, '2026-03-14T11:40:40.468688Z', '2026-03-13T15:58:05Z',
  0, 'opml_import', 'auto_approved', 'blog', 'education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f6bfe20f-fce1-5141-8422-b1d3da5cda4a', 'https://tylertringas.com/feed', 'https://tylertringas.com/', 'Tyler Tringas',
  'Thoughts on Micro-SaaS, Entrepreneurship, Remote Work', 'https://tylertringas.com/wp-content/uploads/2015/11/cropped-tyler_head-32x32.png', 'en', 'business', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:40.273186Z', '2025-06-08T16:10:40Z',
  0, 'opml_import', 'stale_feed', 'news', 'business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'a7d26e90-875d-59ec-a1a1-2d93992d5ac9', 'https://yasuhisa.com/could/feed', 'https://yasuhisa.com/could', 'could',
  'Design, Content, Experience', 'https://yasuhisa.com/content/images/size/w256h256/2021/01/pulication-icon.png', 'en', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:39.838647Z', '2026-03-08T07:25:34Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd819078b-8914-5d6e-ba5a-0957e7f11b06', 'https://technode.com/feed', 'https://technode.com/', 'TechNode',
  'Latest news and trends about tech in China', 'https://technode.com/wp-content/uploads/2020/03/cropped-cropped-technode-icon-2020_512x512-1-32x32.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:39.498213Z', '2026-03-13T07:06:18Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2966976d-0e7f-5c1d-bd4a-926188aeffa6', 'https://ednutting.com/feed', 'https://ednutting.com/', 'Ed Nutting',
  'Hardware innovation leader revolutionizing computing performance', 'https://ednutting.com/favicon.ico', 'en', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:39.149157Z', '2026-02-20T06:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f8287a08-5419-5136-a9b8-c06594883b4b', 'https://windowsread.me/feed', 'https://windowsread.me/', 'The Windows ReadMe',
  'Windows PC tips, tricks, and experiments from Chris Hoffman. (Formerly Windows Intelligence.)', 'https://substackcdn.com/image/fetch/$s_!L3Uj!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F186e464c-8887-415e-b60f-72bc2e19fc63%2Ffavicon.ico', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:41.462977Z', '2026-03-06T12:03:22Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '355e6bb2-ed96-5c80-9da6-7b616fbe3904', 'https://www.tanayj.com/feed', 'https://www.tanayj.com/', 'Tanay’s Newsletter',
  'Musings about tech and business', 'https://substackcdn.com/image/fetch/$s_!i_wo!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F32cc9710-7f71-45d2-9067-9232c34d3383%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:41.481868Z', '2026-03-03T01:57:05Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8d9e5959-f9ee-51b1-94b2-47a9fa926c8d', 'https://catskull.net/feed.xml', 'https://catskull.net/', 'catskull.net',
  'mostly harmless', 'https://catskull.net/favicon.png', 'en', 'other', 'machine-learning',
  'active', 'atom10', 60, '2026-03-14T11:40:40.474377Z', '2026-02-13T23:41:30Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '48ab1352-5913-5715-9f85-b0db5c06f796', 'https://arslan.io/rss', 'https://arslan.io/', 'Fatih Arslan',
  'Engineer with a passion for Design, Dieter Rams, Watches, Pens, Coffee and Bauhaus', 'https://arslan.io/favicon.ico', 'en', 'design', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:40.254582Z', '2025-12-26T15:00:46Z',
  0, 'opml_import', 'stale_feed', 'blog', 'design,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'a86f199b-30fe-54e1-a234-64bc17570e38', 'https://www.seangoedecke.com/rss.xml', 'https://www.seangoedecke.com/', 'seangoedecke.com RSS feed',
  'Sean Goedecke''s personal blog', 'https://www.seangoedecke.com/favicon-32x32.png?v=ac7bb3aa286bd21c42741d9c9aa60cb7', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:40.658921Z', '2026-03-14T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '0a125d55-f778-5926-99a0-edeba12f5ec7', 'https://nextbigteng.substack.com/feed', 'https://nextbigteng.substack.com/', 'Next Big Teng',
  'VC @ Bessemer; data-driven reflections on startups, AI/ML trends, and venture investing', 'https://substackcdn.com/image/fetch/$s_!5Zwm!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F0cedc3e6-7539-4baa-9010-596c3e2689fa%2Ffavicon.ico', 'en', 'tech', 'startup,investing,data',
  'active', 'rss20', 60, '2026-03-14T11:40:41.488471Z', '2026-02-26T20:35:55Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8bd58203-7b15-50ab-8291-45550836228f', 'https://unchartedterritories.tomaspueyo.com/feed', 'https://unchartedterritories.tomaspueyo.com/', 'Uncharted Territories',
  'Understand the world of today to prepare for the world of tomorrow: AI, tech; the future of democracy, energy, education, and more', 'https://substackcdn.com/image/fetch/$s_!7Unu!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F432206f1-de85-4462-815b-56af07ec8e5f%2Ffavicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:42.189389Z', '2026-03-13T16:52:43Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '384404c4-bd50-5b32-8295-b1ca911eef94', 'https://longform.asmartbear.com/index.xml', 'https://longform.asmartbear.com/', 'A Smart Bear',
  'Articles from A Smart Bear', 'https://longform.asmartbear.com/images/bear-green-32-sq.png', 'en', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:40.425050Z', '2026-02-22T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '274923b7-6ac9-56aa-b7cf-4ed701d3b2cc', 'https://kodekloud.com/blog/rss', 'https://kodekloud.com/blog', 'DevOps Blog',
  'Explore our latest insights on DevOps. Get practical tips on tools like Azure, Docker, and Kubernetes. Straightforward advice for your DevOps. Join us and make your DevOps journey better.', 'https://kodekloud.com/blog/content/images/size/w256h256/2022/07/kk_ghost_favicon.png', 'en', 'tech', 'devops,cloud',
  'active', 'rss20', 60, '2026-03-14T11:40:41.923415Z', '2026-03-10T07:06:22Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '33e85f83-a19a-5c77-a1bc-147d69460a40', 'https://www.besttechie.com/rss', 'https://www.besttechie.com/', 'BestTechie',
  'Talking tech since 2003', 'https://www.besttechie.com/content/images/size/w256h256/2020/07/bticon.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:42.412144Z', '2026-01-25T13:13:16Z',
  0, 'opml_import', 'stale_feed', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '94916f78-794b-5722-8d8a-6bb315b46098', 'https://cloudedjudgement.substack.com/feed', 'https://cloudedjudgement.substack.com/', 'Clouded Judgement',
  'Weekly data driven analysis of SaaS companies', 'https://substackcdn.com/image/fetch/$s_!e6Vj!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F32362fc8-8807-45aa-b8f0-3143e3e993f4%2Ffavicon.ico', 'en', 'tech', 'cloud,data,analysis',
  'active', 'rss20', 60, '2026-03-14T11:40:42.027946Z', '2026-03-13T13:03:05Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'eac06806-1624-5deb-ab12-e75e5defa11e', 'https://iq.pulselabs.ai/rss', 'https://iq.pulselabs.ai/', 'Pulse Labs Insights',
  'Pulse Labs Insights is your source of research insights.', 'https://iq.pulselabs.ai/content/images/size/w256h256/2025/09/pl_logo_mark.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:42.492521Z', '2025-09-30T13:47:24Z',
  0, 'opml_import', 'stale_feed', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '59762dd8-cf36-52d8-84c6-cc9bf31446c5', 'https://specbranch.com/index.xml', 'https://specbranch.com/', 'Speculative Branches',
  'Recent content on Speculative Branches', 'https://specbranch.com/icons/apple-touch-icon.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:41.774539Z', '2025-05-04T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c68dd656-8384-5148-8e93-5a105b8036c7', 'https://stratechery.com/feed', 'https://stratechery.com/', 'Stratechery by Ben Thompson',
  'On the business, strategy, and impact of technology.', 'https://i0.wp.com/stratechery.com/wp-content/uploads/2018/03/cropped-android-chrome-512x512-1.png?fit=32%2C32&ssl=1', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:41.894889Z', '2026-03-13T17:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ec5ab2ba-0e9b-588c-aeee-3ee48d845a0e', 'https://www.derekthompson.org/feed', 'https://www.derekthompson.org/', 'Derek Thompson',
  'A newsletter about abundance and building a better world.', 'https://substackcdn.com/image/fetch/$s_!4DPl!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd039a582-17eb-4fa5-ac1f-7facc5333d62%2Ffavicon.ico', 'en', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:41.562079Z', '2026-03-13T12:13:13Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'design,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2d29fcfb-7f2b-5b8f-b3b1-d3a4dca18dba', 'https://daringfireball.net/feeds/main', 'https://daringfireball.net/', 'Daring Fireball',
  'By John Gruber', 'https://daringfireball.net/graphics/apple-touch-icon.png', 'en', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:41.958856Z', '2026-03-13T23:49:17Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b36fcbc4-9ccf-550c-8258-ef4cd40e4f81', 'https://blog.alexmaccaw.com/rss', 'https://blog.alexmaccaw.com/', 'Alex MacCaw',
  'Musings about life, the universe, and everything.', 'https://blog.alexmaccaw.com/favicon.ico', 'en', 'lifestyle', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:42.854990Z', '2025-06-20T12:03:38Z',
  0, 'opml_import', 'stale_feed', 'blog', 'lifestyle,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '0875f7c2-1411-5376-99e5-dede5e5f994a', 'https://helentoner.substack.com/feed', 'https://helentoner.substack.com/', 'Rising Tide',
  'Intermittent thoughts on navigating the transition to a world with extremely advanced AI systems', 'https://helentoner.substack.com/favicon.ico', 'en', 'tech', 'ai,advanced',
  'hidden', 'rss20', 60, '2026-03-14T11:40:42.386403Z', '2025-11-24T15:00:41Z',
  0, 'opml_import', 'stale_feed', 'newsletter', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f0b2feea-3706-5726-89a6-ba47d38476b5', 'https://www.lukew.com/ff/rss', 'https://www.lukew.com/', 'LukeW | Digital Product Design + Strategy',
  'Expert articles about user experience, mobile, Web applications, usability, interaction design and visual design.', 'https://static.lukew.com/apple-touch-icon.png', 'en', 'business', 'mobile,product,ux',
  'active', 'rss20', 60, '2026-03-14T11:40:42.967510Z', '2026-03-12T14:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'business,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '3f67a457-2dd7-5236-af63-21d6e7f4db6b', 'https://www.ben-evans.com/benedictevans?format=rss', 'https://www.ben-evans.com/benedictevans', 'Essays - Benedict Evans',
  NULL, 'https://images.squarespace-cdn.com/content/v1/50363cf324ac8e905e7df861/ebdb4645-db93-4967-881d-db698ee59c2c/favicon.ico?format=100w', 'en', 'automotive', 'opinion',
  'hidden', 'rss20', 60, '2026-03-14T11:40:43.652134Z', '2026-02-19T20:51:04Z',
  0, 'opml_import', 'missing_description', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1b4f104a-115c-5ee2-bb94-26dfce883502', 'https://interfacecafe.com/rss', 'https://interfacecafe.com/', 'Interface Café',
  'the theory, practice, and joy of the interface', 'https://interfacecafe.com/content/images/size/w256h256/2024/04/favicon-1.png', 'en', 'media', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:42.890448Z', '2026-02-17T09:55:37Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8c924ad6-ebe1-577f-907a-5b543b1e3c76', 'https://www.smashingmagazine.com/feed', 'https://www.smashingmagazine.com/', 'Articles on Smashing Magazine — For Web Designers And Developers',
  'Recent content in Articles on Smashing Magazine — For Web Designers And Developers', 'https://www.smashingmagazine.com/images/favicon/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:43.087863Z', '2026-03-13T13:00:00Z',
  0, 'opml_import', 'auto_approved', 'magazine', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '7baf0602-cc68-5437-b816-6b09ea124191', 'https://tech.marksblogg.com/feeds/all.atom.xml', 'https://tech.marksblogg.com/', 'Tech Blog',
  'Benchmarks & Tips for Big Data, Hadoop, AWS, Google Cloud, PostgreSQL, Spark, Python & More...', 'https://tech.marksblogg.com/theme/images/mark.jpg', 'en', 'tech', 'cloud,data',
  'active', 'atom10', 60, '2026-03-14T11:40:50.625580Z', '2026-03-12T10:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '4668cd0d-3cd2-599b-b7df-f6cc9da1698f', 'https://nghiant3223.github.io/feed.xml', 'https://nghiant3223.github.io/', 'Melatoni',
  'Writings about software engineering', 'https://nghiant3223.github.io/favicon.ico', 'en', 'tech', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:42.793967Z', '2025-06-03T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '0324feb0-ce34-573d-8f90-e040c26588db', 'https://blog.packagist.com/rss', 'https://blog.packagist.com/', 'Private Packagist',
  'PHP Package Repositories for Composer', 'https://blog.packagist.com/content/images/size/w256h256/2018/11/logo-128.png', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:44.954571Z', '2026-02-09T16:16:06Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd7ad156d-5d33-5562-b5c8-e360b3acdc4b', 'https://www.ystrickler.com/rss', 'https://www.ystrickler.com/', 'Yancey Strickler',
  'Exploring new forms for creative people', 'https://www.ystrickler.com/content/images/size/w256h256/2025/08/Stylish-Minimalist-Portrait-Drawing.png', 'en', 'business', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:44.977026Z', '2026-03-05T19:36:14Z',
  0, 'opml_import', 'auto_approved', 'research', 'business,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '524beffb-139e-5c8d-9ddf-0a4d725afc8e', 'https://spikepuppet.io/rss.xml', 'https://spikepuppet.io/', 'Rhys'' Ramblings',
  'My personal blog about all things tech and startups (with occasional diversions I find fun!)', 'https://spikepuppet.io/favicon-96x96.png', 'en', 'tech', 'startup',
  'active', 'rss20', 60, '2026-03-14T11:40:43.457816Z', '2026-02-22T08:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c8f0cb65-66be-5759-a449-f6fe8b725828', 'https://werd.io/rss', 'https://werd.io/', 'Ben Werdmuller',
  'Writing at the intersection of technology, journalism, and community.', 'https://werd.io/content/images/size/w256h256/format/png/2025/06/thumb.webp', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:50.616992Z', '2026-03-13T13:30:23Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6fcaa1d9-e7a8-51ae-88b9-d2714aab2e19', 'https://martinfowler.com/feed.atom', 'https://martinfowler.com/', 'Martin Fowler',
  'Master feed of news and updates from martinfowler.com', 'https://martinfowler.com/favicon.ico', NULL, 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:44.863395Z', '2026-03-10T17:50:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '053e37dd-5d8c-530d-bef1-218bc92333c1', 'https://engineering.mercari.com/blog/feed.xml', 'https://engineering.mercari.com/', 'メルカリエンジニアリングブログ',
  'メルカリのエンジニアブログです。技術情報やエンジニアリング組織などの情報を日々発信していきます。', 'https://engineering.mercari.com/favicon.ico', 'ja', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:43.530147Z', '2026-03-05T07:00:28Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '254f814c-2878-51d9-97fe-f188f5930335', 'https://www.lorenstew.art/rss.xml', 'https://www.lorenstew.art/', 'Loren Stewart',
  'A blog exploring web development and AI', 'https://www.lorenstew.art/favicon.svg', 'en', 'tech', 'ai,webdev,product',
  'hidden', 'rss20', 60, '2026-03-14T11:40:43.520278Z', '2025-12-19T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6eded0f2-ccb0-5d6a-916c-7f44135ce3b6', 'https://www.4rknova.com/feed.xml', 'https://www.4rknova.com/', '4rknova.com',
  'Personal Homepage', 'https://www.4rknova.com/assets/img/favicons/apple-touch-icon-57x57.png?v=qABrlBgnqd', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:45.255794Z', '2026-03-05T00:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ce40b69f-d1a8-5fa4-b1ab-3ca74424277b', 'https://eugeneyan.com/rss', 'https://eugeneyan.com/', 'Eugene Yan',
  'Eugene Yan works at the intersection of consumer data & tech to build machine learning products, and writes about effective data science, learning & career.', 'https://eugeneyan.com/assets/favicon/favicon.ico', 'en', 'tech', 'data,machine-learning,product',
  'hidden', 'rss20', 60, '2026-03-14T11:40:44.879862Z', '2025-12-14T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '566d2d64-fef2-5e51-9736-74851986a135', 'https://etsd.tech/rss.xml', 'https://etsd.tech/', 'etsd.tech',
  'Exploring code, design, and agentic-coding — with both feet off the ground.', 'https://etsd.tech/favicon.svg', 'en', 'tech', 'programming',
  'active', 'rss20', 60, '2026-03-14T11:40:43.898560Z', '2026-02-01T12:34:55Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e771eda5-769b-53ae-a740-31ddb3a395b5', 'https://www.dzombak.com/blog/rss', 'https://www.dzombak.com/', 'Chris Dzombak',
  'A Midwestern software developer with objectively too many hobbies.', 'https://www.dzombak.com/content/images/size/w256h256/2025/02/2023-Apple---square.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:45.082273Z', '2026-03-10T18:51:13Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'de27b63a-4619-5870-9a57-16d171b6fada', 'https://thinkingmachines.ai/blog/index.xml', 'https://thinkingmachines.ai/blog', 'Connectionism on Thinking Machines Lab',
  'Recent content in Connectionism on Thinking Machines Lab', 'https://thinkingmachines.ai/images/apple-touch-icon.png', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:44.072978Z', '2025-10-27T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '46b0e6fd-3255-5b4c-95f0-74f98fad938f', 'https://themarkup.org/feeds/rss.xml', 'https://themarkup.org/', 'The Markup',
  'All stories from The Markup', 'https://mrkp-static-production.themarkup.org/static/img/social-icons/favicon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:45.673947Z', '2026-03-09T12:30:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,finance'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f2b9d55b-8c1c-5785-bab1-7599ee0be338', 'https://blog.ag-grid.com/rss', 'https://blog.ag-grid.com/', 'AG Grid Blog',
  'Enterprise Data Grid for React, Angular, Vue and JavaScript', 'https://blog.ag-grid.com/content/images/size/w256h256/2021/02/200pxArtboard-5.png', 'en', 'tech', 'webdev,data',
  'active', 'rss20', 60, '2026-03-14T11:40:46.399887Z', '2026-02-11T12:20:48Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f807cd6f-69a7-5dfe-ac65-96c85acfdd7e', 'https://www.yardeniquicktakes.com/rss', 'https://www.yardeniquicktakes.com/', 'Yardeni QuickTakes',
  'Daily insights, focused news, clear charts, weekly video webcasts, and much more. Posted by Dr Ed Yardeni and his research team.', 'https://www.yardeniquicktakes.com/content/images/size/w256h256/2022/10/circle-approved-yri.png', 'en', 'tech', 'daily,weekly',
  'active', 'rss20', 60, '2026-03-14T11:40:45.763946Z', '2026-03-13T01:24:58Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '9d6ceb2a-e575-5eb4-843d-d9e53816b523', 'https://thecore.media/rss', 'https://thecore.media/', 'The Core(더코어)',
  'AI, Digital Business와 미디어 & 콘텐츠 산업 등을 심층적으로 분석하는 경제 전문 미디어입니다. 각종 전문 번역 자료와 세미나, 이벤트도 만나 볼 수 있습니다', 'https://cdn.media.bluedot.so/bluedot.thecore/2022/08/favicon_thecore.png', 'other', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:45.428289Z', '2026-03-14T03:02:12Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5820d793-af18-530c-b92c-9ba225078fa2', 'https://ppc.land/rss', 'https://ppc.land/', 'PPC Land',
  'Your go-to source for digital marketing news. Get the latest updates from Google, Meta, Amazon, and The Trade Desk. Stay informed on ad tech innovations, programmatic trends, and policy changes.', 'https://ppc.land/content/images/2024/03/ppc.ico', 'en', 'tech', 'marketing',
  'active', 'rss20', 60, '2026-03-14T11:40:46.111443Z', '2026-03-14T10:44:43Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd5c12375-7880-5a6d-8c34-a2cbb8d83a74', 'https://reason.com/latest/feed', 'https://reason.com/latest', 'Latest - Reason.com',
  'The leading libertarian magazine and covering news, politics, culture, and more with reporting and analysis.', 'https://reason.com/wp-content/uploads/2025/09/cropped-rinsquareRGB-32x32.png', 'en', 'culture', 'analysis',
  'active', 'rss20', 60, '2026-03-14T11:40:46.392283Z', '2026-03-14T11:00:11Z',
  0, 'opml_import', 'auto_approved', 'news', 'culture,politics'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '342506ce-94d2-5ccc-bde0-2b7464cc88c0', 'https://the-decoder.com/feed', 'https://the-decoder.com/', 'The Decoder',
  'AI, Menschen, Wirtschaft', 'https://the-decoder.com/resources/favicons/apple-touch-icon-60x60.png?v=3', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:50.176625Z', '2026-03-14T11:12:35Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2f17dbfd-5381-57eb-becb-7871a2ccbf8e', 'https://marginalrevolution.com/feed', 'https://marginalrevolution.com/', 'Marginal REVOLUTION',
  'Small Steps Toward A Much Better World', 'https://marginalrevolution.com/wp-content/uploads/2015/10/cropped-MR-logo-thumbnail-32x32.png', 'en', 'automotive', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:46.151027Z', '2026-03-14T09:13:44Z',
  0, 'opml_import', 'auto_approved', 'blog', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8312b9a9-0748-5122-8c6d-703e4515bf80', 'https://www.latent.space/feed', 'https://www.latent.space/', 'Latent.Space',
  'The AI Engineer newsletter + Top technical AI podcast. How leading labs build Agents, Models, Infra, & AI for Science. See https://latent.space/about for highlights from Greg Brockman, Andrej Karpathy, George Hotz, Simon Willison, Soumith Chintala et al!', 'https://www.latent.space/favicon.ico', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:45.912248Z', '2026-03-14T03:25:49Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e37d5199-5fd2-5309-af27-027a7747e8fc', 'https://reclaimthenet.org/feed', 'https://reclaimthenet.org/', 'Reclaim The Net',
  'The number one newsletter for all things privacy, free speech, and digital civil liberties.', 'https://reclaimthenet.org/wp-content/uploads/fbrfg/apple-touch-icon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:45.814747Z', '2026-03-13T19:18:43Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '0ac64dff-5487-5998-a715-2fb2cbda9bae', 'https://spyglass.org/rss', 'https://spyglass.org/', 'Spyglass',
  'Insight from afar by M.G. Siegler', 'https://spyglass.org/content/images/size/w256h256/2025/07/Spyglass-Rings-----Multi.png', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:46.673939Z', '2026-03-13T10:41:08Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '87a03aed-765a-5b48-9ead-2a0a29cc604a', 'https://www.testingcatalog.com/rss', 'https://www.testingcatalog.com/', 'TestingCatalog',
  'Reporting AI updates. A future news media, driven by virtual assistants 🤖', 'https://www.testingcatalog.com/content/images/size/w256h256/2023/01/5iVVRzJO_400x400.jpeg', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:46.955174Z', '2026-03-11T00:54:39Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '40799f82-a8b3-50d1-9b5d-e5b2dae377a2', 'https://simonwillison.net/atom/everything', 'https://simonwillison.net/', 'Simon Willison''s Weblog',
  NULL, 'https://simonwillison.net/favicon.ico', 'en', 'other', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:50.156387Z', '2026-03-13T18:29:13Z',
  0, 'opml_import', 'missing_description', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5bde3f3f-282c-5c24-bac5-0fbb490acba8', 'https://www.platformer.news/rss', 'https://www.platformer.news/', 'Platformer',
  'News at the intersection of Silicon Valley and democracy. On Monday, Tuesday, and Thursday at 5PM Pacific.', 'https://www.platformer.news/content/images/size/w256h256/2024/05/Logomark_Blue_800px.png', 'en', 'other', 'product',
  'active', 'rss20', 60, '2026-03-14T11:40:46.379144Z', '2026-03-13T00:01:06Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b11dd5d6-3286-5f5f-a3c2-9d8fc26f6dac', 'https://ebadak.news/feed', 'https://ebadak.news/', '이바닥늬우스',
  '찰지고 신나는 테크바닥 늬우스', 'https://ebadak.news/wp-content/uploads/2019/01/cropped-icon_square_512.png?w=32', 'ko', 'other', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:46.983602Z', '2025-12-24T15:13:44Z',
  0, 'opml_import', 'stale_feed', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '79b33ad0-f20c-585b-87e0-c5d2a9737a90', 'https://www.romanceip.xyz/rss', 'https://www.romanceip.xyz/', '낭만투자파트너스',
  'VC 산업도 혁신할 수 있습니다', 'https://www.romanceip.xyz/content/images/size/w256h256/2023/12/--------------17.png', 'ko', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:51.510156Z', '2026-03-04T23:05:04Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '282de8c8-6956-5662-a0bc-e7c092e1a910', 'https://blogs.itmedia.co.jp/serial/atom.xml', 'https://blogs.itmedia.co.jp/serial', '経営者が読むNVIDIAのフィジカルAI / ADAS業界日報 by 今泉大輔',
  '20年以上断続的にこのブログを書き継いできたインフラコモンズ代表の今泉大輔です。NVIDIAのフィジカルAIの世界が日本の上場企業多数に時価総額増大の事業機会を1つだけではなく複数与えることを確信してこの名前にしました。ネタは無限にあります。何卒よろしくお願い申し上げます。', 'https://blogs.itmedia.co.jp/favicon.ico', 'ja', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:50.150932Z', '2026-03-14T10:09:28Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6f159384-3e2c-5a41-b594-624a7bff8475', 'https://arstechnica.com/feed', 'https://arstechnica.com/', 'Ars Technica',
  'Serving the Technologist since 1998. News, reviews, and analysis.', 'https://cdn.arstechnica.net/wp-content/uploads/2016/10/cropped-ars-logo-512_480-60x60.png', 'en', 'tech', 'analysis,review',
  'active', 'rss20', 60, '2026-03-14T11:40:51.041942Z', '2026-03-14T07:14:53Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b0386db1-3bec-5081-8eef-43cf6a32ed91', 'https://blog.bandprotocol.com/rss', 'https://blog.bandprotocol.com/', 'Band',
  'Band Is The Data Layer That Trains AI Engines and Powers Blockchain Applications', 'https://blog.bandprotocol.com/content/images/size/w256h256/format/png/2025/08/band-token.svg', 'en', 'tech', 'ai,data',
  'active', 'rss20', 60, '2026-03-14T11:40:51.633217Z', '2026-02-26T11:01:14Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '99d6245c-c67a-589a-a390-7e62d2d4d371', 'https://chipsandcheese.com/feed', 'https://chipsandcheese.com/', 'Chips and Cheese',
  'The Devil is in the Details! Deep dives into computer hardware and software and the wider industry...', 'https://substackcdn.com/image/fetch/$s_!A3C4!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F6d6ceac7-3196-46ce-837d-21e5b40021ae%2Ffavicon.ico', 'en', 'tech', 'advanced',
  'active', 'rss20', 60, '2026-03-14T11:40:46.974606Z', '2026-03-03T06:51:25Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'c6de04e9-014d-5e15-b0f2-9da5abba64f8', 'https://developer.chrome.com/blog/feed.xml', 'https://developer.chrome.com/blog', 'developer.chrome.com: Blog',
  'All of developer.chrome.com articles.', 'https://www.gstatic.com/devrel-devsite/prod/va845a6a69ec71f6762e80b2da8e8faa65e74307aa7e53d6c2485adee73edb48b/chrome/images/favicon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:51.022862Z', '2026-03-11T07:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2a816f9f-bd70-5a97-b526-b9becf09a236', 'https://www.coindesk.com/arc/outboundfeeds/rss', 'https://www.coindesk.com/', 'CoinDesk: Bitcoin, Ethereum, Crypto News and Price Data',
  'Leader in cryptocurrency, Bitcoin, Ethereum, XRP, blockchain, DeFi, digital finance and Web 3.0 news with analysis, video and live price updates.', 'https://www.coindesk.com/favicons/production/favicon.ico', 'en', 'tech', 'data,analysis',
  'active', 'rss20', 60, '2026-03-14T11:40:51.119401Z', '2026-03-14T06:08:27Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,finance'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '02951b7d-0644-56d0-9c6a-68157a6989e1', 'https://coinpedia.org/feed', 'https://coinpedia.org/', 'Coinpedia Fintech News',
  'Coinpedia is Crypto Encyclopedia offering crypto-related comprehensive information, Cryptocurrency News, Events, PR and Bitcoin Event info.', 'https://image.coinpedia.org/wp-content/uploads/2024/10/14132640/favicon.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:51.569951Z', '2026-03-14T10:58:43Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'cbcfec7e-6980-5c09-84d7-fa564b888a66', 'https://daotimes.com/tag/news/rss', 'https://daotimes.com/', 'News - DAO Times',
  'We are the voice of the rising decentralized world', 'https://daotimes.com/content/images/size/w256h256/format/jpeg/2026/02/1Uq-gO3H_400x400.jpg', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:50.815237Z', '2026-03-14T10:26:50Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'eff1dbeb-9580-519c-a052-33d46578e86e', 'https://darkwebinformer.com/rss', 'https://darkwebinformer.com/', 'Dark Web Informer',
  'A real-time cyber threat intelligence platform that monitors the dark web and clearnet for data breaches, ransomware campaigns, darknet market activity, leaked databases, and active threat actors.', 'https://darkwebinformer.com/content/images/size/w256h256/2026/01/new_profile_image-3.png', 'en', 'tech', 'data',
  'active', 'rss20', 60, '2026-03-14T11:40:51.081789Z', '2026-03-13T16:21:43Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '79b0b796-ef55-57d9-8e5e-5f922725f885', 'https://deno.com/feed', 'https://deno.com/blog', 'Deno',
  'The latest news from Deno Land Inc.', 'https://deno.com/favicon.ico?__frsh_c=1145239c663d5e82dd26c3ed95191bd9bd98cde3', 'en', 'other', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:51.918409Z', '2026-02-25T09:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '822cdc01-0f0c-595f-b80c-5fa17091c0ab', 'https://electrek.co/feed', 'https://electrek.co/', 'Electrek',
  'EV and Tesla News, Green Energy, Ebikes, and more', 'https://electrek.co/wp-content/themes/ninetofive/dist/svg/electrek-e.svg', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:51.588033Z', '2026-03-13T23:54:23Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd6ef5c77-31f8-5de4-bdb6-bdf58b1528b4', 'https://blog.emojipedia.org/rss', 'https://blog.emojipedia.org/', 'Emojipedia - The Latest Emoji News',
  'Emojipedia', 'https://blog.emojipedia.org/content/images/size/w256h256/2017/08/64x64@2x.png', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:51.624065Z', '2026-03-09T17:35:35Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '04955b31-324b-58f7-ad9e-e223fa5fc0e8', 'https://blog.flutterflow.io/rss', 'https://blog.flutterflow.io/', 'FlutterFlow',
  'Explore amazing project ideas along with step-by-step tutorials for building your next app using FlutterFlow.', 'https://blog.flutterflow.io/content/images/size/w256h256/2022/11/@3xlogoMark_outlinePrimary_fav.png', 'en', 'education', 'tutorial',
  'active', 'rss20', 60, '2026-03-14T11:40:51.962393Z', '2026-02-03T16:21:09Z',
  0, 'opml_import', 'auto_approved', 'blog', 'education,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e174352d-6b57-5bb4-95b1-94e5c7ea9012', 'https://deepmind.google/blog/rss.xml', 'https://deepmind.google/blog', 'Google DeepMind News',
  'Read the latest articles and stories from DeepMind and find out more about our latest breakthroughs in cutting-edge AI research.', 'https://storage.googleapis.com/gdm-deepmind-com-prod-public/icons/google_deepmind_2x_96dp.png', 'en', 'tech', 'ai,product',
  'active', 'rss20', 60, '2026-03-14T11:40:53.168670Z', '2026-03-09T13:52:36Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '960a8997-ef1d-5a75-83f9-1694301a3e69', 'https://hnrss.org/frontpage', 'https://news.ycombinator.com/', 'Hacker News: Front Page',
  'Hacker News RSS', 'https://news.ycombinator.com/y18.svg', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:52.862936Z', '2026-03-14T11:35:49Z',
  0, 'opml_import', 'auto_approved', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '02ee283a-e2f8-5d8b-9628-b5f5bcf805c6', 'https://research.ibm.com/rss', 'https://research.ibm.com/', 'IBM Research',
  'At IBM Research, we’re inventing what’s next in AI, quantum computing, and hybrid cloud to shape the world ahead.', 'https://www.ibm.com/favicon.ico', 'en', 'tech', 'cloud',
  'active', 'rss20', 60, '2026-03-14T11:40:53.698444Z', '2026-03-12T10:00:00Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '2602c2a4-7e01-59e3-8648-1c22e0042e04', 'https://investing101.substack.com/feed', 'https://investing101.substack.com/', 'Investing 101',
  'Learning in Public: Investing', 'https://investing101.substack.com/favicon.ico', 'en', 'finance', 'investing',
  'active', 'rss20', 60, '2026-03-14T11:40:51.557231Z', '2026-03-11T22:58:04Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'finance,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'a8abec4d-e742-5786-8c30-63b7af62594c', 'https://www.jeffgeerling.com/blog.xml', 'https://www.jeffgeerling.com/', 'Jeff Geerling',
  'Recent content on Jeff Geerling', 'https://www.jeffgeerling.com/favicon.ico', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:51.556800Z', '2026-03-13T14:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '7548eb1d-02bb-507b-b7fd-1899db1002d9', 'https://updates.kickstarter.com/rss', 'https://updates.kickstarter.com/', 'Kickstarter Blog: Crowdfunding Tips, Stories & Insights',
  'Crowdfunding tips, trends, and success stories to bring ideas to life.', 'https://updates.kickstarter.com/content/images/size/w256h256/2025/05/kickstarter-logo-k-green.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:52.040314Z', '2026-03-11T12:11:44Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,lifestyle'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '1ea8f2b4-e323-56cc-8b9f-f98d0cbcf431', 'https://www.lennysnewsletter.com/feed', 'https://www.lennysnewsletter.com/', 'Lenny''s Newsletter',
  'Deeply researched product, growth, and career advice—newsletter, podcast, community, and living library', 'https://substackcdn.com/image/fetch/$s_!6RbS!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5d6af901-7717-4d79-b49e-8bc28427148c%2Ffavicon.ico', 'en', 'science', 'product,marketing,career',
  'active', 'rss20', 60, '2026-03-14T11:40:53.049902Z', '2026-03-12T12:32:15Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'science,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '50a048c2-9ba6-5495-b08d-895c1d1c7f0e', 'https://lowendbox.com/feed', 'https://lowendbox.com/', 'LowEndBox',
  'The home of cheap VPS, hosting deals, and industry news', 'https://lowendbox.com/wp-content/themes/leb3/favicon.ico', 'en', 'automotive', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:53.026668Z', '2026-03-13T17:09:33Z',
  0, 'opml_import', 'auto_approved', 'news', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '41d77506-c4eb-5bcf-9615-fa711cf801ed', 'https://blog.lucidprivacy.io/rss', 'https://blog.lucidprivacy.io/', 'Lucid Privacy Group',
  'Trusted Global Privacy Specialists for Data-Driven Companies', 'https://blog.lucidprivacy.io/content/images/size/w256h256/2022/04/lucid-icon.png', 'en', 'other', 'data,global',
  'hidden', 'rss20', 60, '2026-03-14T11:40:53.182512Z', '2025-10-02T19:19:55Z',
  0, 'opml_import', 'stale_feed', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ba1c07e8-3f07-5346-a5a1-264204322f90', 'https://lwn.net/headlines/rss', 'https://lwn.net/', 'LWN.net',
  'LWN.net is a comprehensive source of news and opinions from
        and about the Linux community.  This is the main LWN.net feed,
        listing all articles which are posted to the site front page.', 'https://static.lwn.net/images/favicon.png', 'en', 'tech', 'ux,opinion',
  'active', 'rss20', 60, '2026-03-14T11:40:52.877146Z', '2026-03-13T18:26:09Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '72aad247-0782-5d2d-8a00-34f1dacb28c7', 'https://developer.mozilla.org/en-US/blog/rss.xml', 'https://developer.mozilla.org/en-US/blog', 'MDN Blog',
  'The MDN Web Docs blog publishes articles about web development, open source software, web platform updates, tutorials, changes and updates to MDN, and more.', 'https://developer.mozilla.org/favicon.ico', 'en', 'tech', 'opensource,webdev,product',
  'hidden', 'rss20', 60, '2026-03-14T11:40:52.070394Z', '2025-11-05T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'blog', 'tech,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'bb1c9fa7-71d7-5463-80cb-1fe95e22bded', 'https://mjtsai.com/blog/feed', 'https://mjtsai.com/blog', 'Michael Tsai',
  NULL, 'https://mjtsai.com/favicon.ico', 'en', 'tech', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:54.532679Z', '2026-03-13T21:04:39Z',
  0, 'opml_import', 'missing_description', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'aefe48f0-99b1-577a-8e16-31da72607017', 'https://updates.midjourney.com/rss', 'https://updates.midjourney.com/', 'Midjourney',
  'Thoughts, stories and ideas.', 'https://updates.midjourney.com/favicon.ico', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:52.959401Z', '2026-02-26T20:13:48Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'b654e71e-f5e1-599f-938e-b58b0cb945d4', 'https://www.livemint.com/rss/technology', 'https://www.livemint.com/rss/technology', 'mint - technology',
  'Get the latest news and analysis on business, finance, politics from mint, the website of the Mint newspaper, one of India''s leading business and financial dailies', 'https://www.livemint.com/favicon.ico', NULL, 'tech', 'analysis',
  'active', 'rss20', 60, '2026-03-14T11:40:52.157987Z', '2026-03-13T08:55:15Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6313ce40-f20c-50eb-9354-5ac524fbe9a5', 'https://www.mobileindustryreview.com/rss', 'https://www.mobileindustryreview.com/', 'Mobile Industry Review',
  'News and opinion for mobile industry executives and fanatics', 'https://www.mobileindustryreview.com/content/images/size/w256h256/2025/11/MIR-square-600x600.png', 'en', 'automotive', 'mobile,opinion,review',
  'active', 'rss20', 60, '2026-03-14T11:40:54.128338Z', '2026-02-18T20:14:24Z',
  0, 'opml_import', 'auto_approved', 'news', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e463ebfb-3e65-5b47-a14e-f8949063ca74', 'https://blog.mozilla.ai/rss', 'https://blog.mozilla.ai/', 'Mozilla.ai',
  'We are building a future where AI works for you.', 'https://blog.mozilla.ai/content/images/size/w256h256/2025/10/mzai-60-1.png', 'en', 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:53.301891Z', '2026-03-10T13:00:38Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd322d136-7eef-5152-a2ef-12c368203280', 'https://www.natesilver.net/feed', 'https://www.natesilver.net/', 'Silver Bulletin',
  'Essays and analysis about elections, media, sports, poker, and all the other things I care about.', 'https://substackcdn.com/image/fetch/$s_!u8Hz!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fc34a9b4e-dd48-4d18-bb34-5e7cda997390%2Ffavicon.ico', 'en', 'sports', 'analysis,opinion',
  'active', 'rss20', 60, '2026-03-14T11:40:52.425906Z', '2026-03-13T17:03:00Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'sports,politics'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e103f11f-e801-5a3d-9930-d1cb2dec0f62', 'https://obsidian.md/feed.xml', 'https://obsidian.md/', 'Obsidian Blog',
  'New blog posts from the Obsidian team.', 'https://obsidian.md/favicon.ico', 'en', 'other', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:52.786048Z', '2025-10-01T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'news', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '36cfb54b-8f21-5d42-aebb-ca4e349770e4', 'https://openai.com/news/rss.xml', 'https://openai.com/news', 'OpenAI News',
  'The OpenAI blog', 'https://openai.com/favicon.ico', NULL, 'tech', 'ai',
  'active', 'rss20', 60, '2026-03-14T11:40:53.738714Z', '2026-03-11T13:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'e1763770-0ea3-5662-ae62-4e682d227e39', 'https://pinata.cloud/blog/rss', 'https://pinata.cloud/blog', 'Pinata',
  'Tips, tricks, and news', 'https://pinata.cloud/blog/content/images/size/w256h256/2024/06/_Pinata_Watermark_RGB_Full-Color.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:56.006163Z', '2026-03-11T21:07:06Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8bbd077f-0475-592d-8659-22b7ad5598fd', 'https://pydevtools.com/blog/index.xml', 'https://pydevtools.com/blog', 'Python Developer Tooling Handbook – Python Tooling Blog',
  'Recent content in Python Tooling Blog on Python Developer Tooling Handbook', 'https://pydevtools.com/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:55.802282Z', '2026-02-24T17:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd123bbe2-6824-5586-96ce-b227ad38886e', 'https://devblog.qnx.com/rss', 'https://devblog.qnx.com/', 'QNX Developer Blog',
  'Embedded development starts here.', 'https://devblog.qnx.com/content/images/size/w256h256/2025/02/apple-touch-icon.png', 'en', 'tech', 'product',
  'active', 'rss20', 60, '2026-03-14T11:40:53.760107Z', '2026-03-04T12:37:06Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ea0b9d5f-d89e-59bc-9255-3d31dbd4f10b', 'https://research.google/blog/rss', 'https://research.google/blog', 'The latest research from Google',
  NULL, 'https://www.gstatic.com/images/branding/googleg_gradient/1x/googleg_gradient_standard_20dp.png', 'en', 'science', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:54.589082Z', '2026-03-12T13:03:15Z',
  0, 'opml_import', 'missing_description', 'research', 'science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f4a62a25-3ca5-50c5-87d5-2168cdb25856', 'https://blog.snapmaker.com/rss', 'https://blog.snapmaker.com/', 'Snapmaker Official Blog',
  'The hub for Snapmaker users worldwide. Connect with our community and master the #1 3-in-1 3D printer for endless creative possibilities.', 'https://blog.snapmaker.com/content/images/size/w256h256/2025/04/snapmakerjs-icon-256x256.png', 'en', 'other', 'opensource,product',
  'active', 'rss20', 60, '2026-03-14T11:40:54.826511Z', '2026-03-10T09:01:54Z',
  0, 'opml_import', 'auto_approved', 'forum', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '7702e11e-ce78-5491-81af-ad59bb4b357f', 'https://techfundingnews.com/feed', 'https://techfundingnews.com/', 'Tech Funding News',
  'Tech Funding News', 'https://techfundingnews.com/wp-content/uploads/2021/07/cropped-android-chrome-192x192-1-32x32.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:55.739195Z', '2026-03-13T14:39:28Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '81f2aa55-2ea1-50b9-be1e-5869bade3f59', 'https://techxplore.com/rss-feed', 'https://techxplore.com/', 'Tech Xplore - electronic gadgets, technology advances and research news',
  'Tech Xplore internet news portal provides the latest news on electronics, technology, and engineering.', 'https://techxplore.com/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:56.048955Z', '2026-03-13T23:30:03Z',
  0, 'opml_import', 'auto_approved', 'research', 'tech,science'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '684ca0e4-086a-56de-804e-04ba6466f542', 'https://www.techloy.com/rss', 'https://www.techloy.com/', 'Techloy',
  'Techloy.com publishes information about companies, products, careers, and funding in the technology industry across emerging markets globally.', 'https://www.techloy.com/content/images/size/w256h256/2023/07/techloy-avatar-1.png', 'en', 'tech', 'opensource,investing,product',
  'active', 'rss20', 60, '2026-03-14T11:40:55.817153Z', '2026-03-13T19:53:36Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '66b0d56b-3846-5327-b540-1b2719335319', 'https://www.theblock.co/rss.xml', 'https://www.theblock.co/rss.xml', 'The Block',
  'The Block features breaking Crypto news about Bitcoin, Blockchain, Web3, and DeFi from the web''s most reliable source.', 'https://www.theblock.co/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:54.063197Z', '2026-03-13T20:03:52Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,business'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '9c6c3590-8941-5036-b006-d07ea5c518ab', 'https://boston.conman.org/bostondiaries.rss', 'https://boston.conman.org/', 'The Boston Diaries',
  'The on going saga of a programmer who doesn''t live in Boston, nor
        does he even like Boston, but yet named his weblog/journal
	“The Boston Diaries.”', 'https://boston.conman.org/favicon.ico', 'en', 'tech', 'other',
  'hidden', 'rss091u', 60, '2026-03-14T11:40:56.814900Z', NULL,
  0, 'opml_import', 'missing_published_dates', 'news', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '8df900c4-2019-571f-8fc0-0670e356dac6', 'https://blog.cloudflare.com/rss', 'https://blog.cloudflare.com/', 'The Cloudflare Blog',
  'Get the latest news on how products at Cloudflare are built, technologies used, and join the teams helping to build a better Internet.', 'https://blog.cloudflare.com/images/favicon-32x32.png', 'en', 'tech', 'cloud,product',
  'active', 'rss20', 60, '2026-03-14T11:40:54.924074Z', '2026-03-16T05:00:00Z',
  0, 'opml_import', 'auto_approved', 'news', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ce4d73ab-e7d2-5f79-bc7b-98fbecb9305a', 'https://www.generalist.com/feed', 'https://www.generalist.com/', 'The Generalist',
  'The people, companies, and technologies shaping the future.', 'https://substackcdn.com/image/fetch/$s_!olig!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe3c721f9-a7fd-4ada-bcef-0e48260a4c8b%2Ffavicon.ico', 'en', 'tech', 'backend',
  'active', 'rss20', 60, '2026-03-14T11:40:54.986278Z', '2026-03-10T12:03:39Z',
  0, 'opml_import', 'auto_approved', 'newsletter', 'tech,media'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'd8b8604c-e9e9-53d5-9c79-e9e7e2979252', 'https://thegnomonworkshop.com/blog/rss', 'https://thegnomonworkshop.com/blog', 'The Gnomon Workshop',
  'Professional Artists Training with Tutorials in Visual Effects and 3D Animation Software', 'https://thegnomonworkshop.com/blog/content/images/size/w256h256/format/jpeg/2022/10/gw-60x60.jpg', 'en', 'tech', 'tutorial',
  'active', 'rss20', 60, '2026-03-14T11:40:56.088399Z', '2026-03-07T03:33:54Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,education'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '15c02106-22db-5ab3-b155-38202e62a76a', 'https://blog.jetbrains.com/feed', 'https://blog.jetbrains.com/', 'The JetBrains Blog',
  'Developer Tools for Professionals and Teams', 'https://blog.jetbrains.com/wp-content/themes/jetbrains/assets/img/favicons/favicon.ico', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:56.954331Z', '2026-03-13T13:05:10Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '762e13c3-7e56-58af-b299-da74876cf6c4', 'https://blog.pragmaticengineer.com/rss', 'https://blog.pragmaticengineer.com/', 'The Pragmatic Engineer',
  'Observations across the software engineering industry.', 'https://blog.pragmaticengineer.com/content/images/size/w256h256/2024/06/The-Pragmatic-Engineer-Blog-Publication-Icon--Logo-.png', NULL, 'tech', 'opensource',
  'active', 'rss20', 60, '2026-03-14T11:40:55.894184Z', '2026-03-05T18:03:16Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'ee70f927-090a-578e-a5c5-c252f545ee0e', 'https://blog.sui.io/rss', 'https://blog.sui.io/', 'The Sui Blog',
  'Supporting and empowering builders and creators in the Sui Ecosystem.', 'https://blog.sui.io/content/images/size/w256h256/2023/04/Sui_Droplet_Logo_Blue-1.png', 'en', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:55.726538Z', '2026-03-13T18:56:13Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '65217884-e053-5e1b-9305-7fe39bde8289', 'https://jyn.dev/atom.xml', 'https://jyn.dev/', 'the website of jyn',
  'i write about code, and things that bring me joy, and sometimes other things too', 'https://jyn.dev/favicon.jpg', 'en', 'automotive', 'other',
  'hidden', 'atom10', 60, '2026-03-14T11:40:55.943280Z', '2026-01-22T00:00:00Z',
  0, 'opml_import', 'stale_feed', 'news', 'automotive'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '5974ab0a-2829-576a-a9ea-4b06f0ca619b', 'https://waxy.org/feed', 'https://waxy.org/', 'Waxy.org',
  'Andy Baio lives here', 'https://waxy.org/wp-content/uploads/2016/10/square_logo-150x150.png', 'en', 'tech', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:56.927272Z', '2026-03-13T17:37:37Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '196eea36-8a3a-59d0-89b0-b7c1e88b343b', 'https://www.ycombinator.com/blog/rss', 'https://www.ycombinator.com/blog', 'Y Combinator Blog',
  'Y Combinator Blog', 'https://bookface-static.ycombinator.com/assets/ycdc/favicon-c8a914eeeba9fe6f7a863b35608b55aeedd7c1ff409c97b9ecb96b7a6c278d70.ico', 'en', 'other', 'other',
  'active', 'rss20', 60, '2026-03-14T11:40:56.411258Z', '2026-02-05T17:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '94c16cac-3e63-5551-b4f0-7b85b832f05a', 'https://techblog.zozo.com/feed', 'https://techblog.zozo.com/', 'ZOZO TECH BLOG',
  'ZOZO TECH BLOG', 'https://techblog.zozo.com/icon/favicon', 'ja', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:56.603076Z', '2026-03-13T04:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '4f9cd8e0-1123-521c-8972-cc49842e0cc4', 'https://designcompass.org/feed', 'https://designcompass.org/', '디자인 나침반',
  '좋은 디자인을 향하는 나침반', 'https://designcompass.org/wp-content/uploads/2024/11/cropped-symbol-white-32x32.png', 'ko', 'design', 'other',
  'active', 'rss20', 60, '2026-03-14T11:41:07.488477Z', '2026-03-13T03:00:00Z',
  0, 'opml_import', 'auto_approved', 'blog', 'design'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  'f3875a1e-83fb-5cc0-867d-16d4a070e00d', 'https://yozm.wishket.com/magazine/feed', 'https://yozm.wishket.com/magazine/list/new', '요즘IT » 피드',
  '쉽고 재미있는 IT 이야기를 다룹니다. 업계 전문가들이 전하는 IT 트렌드, 기획, 디자인, 개발, 인사이트 소식들이 가득합니다.', 'https://yozm.wishket.com/favicon.ico', 'ko', 'other', 'other',
  'hidden', 'rss20', 60, '2026-03-14T11:40:56.671483Z', NULL,
  0, 'opml_import', 'missing_published_dates', 'magazine', 'other'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

INSERT INTO sources (
  id, rss_url, site_url, title, description, favicon_url, language, category, tags,
  status, feed_format, fetch_interval_minutes, last_fetched_at, last_published_at,
  consecutive_fail_count, registered_by, status_reason, type, categories
) VALUES (
  '6f51852b-539c-58de-b7fb-90c6b65f3733', 'https://techlife.cookpad.com/feed', 'https://techlife.cookpad.com/', 'クックパッド開発者ブログ',
  'クックパッド開発者ブログ', 'https://techlife.cookpad.com/icon/favicon', 'ja', 'tech', 'other',
  'active', 'atom10', 60, '2026-03-14T11:40:56.655961Z', '2026-02-13T01:45:02Z',
  0, 'opml_import', 'auto_approved', 'blog', 'tech,lifestyle'
)
ON CONFLICT (rss_url) DO UPDATE SET
  site_url = EXCLUDED.site_url,
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  favicon_url = EXCLUDED.favicon_url,
  language = EXCLUDED.language,
  category = EXCLUDED.category,
  tags = EXCLUDED.tags,
  status = EXCLUDED.status,
  feed_format = EXCLUDED.feed_format,
  fetch_interval_minutes = EXCLUDED.fetch_interval_minutes,
  last_fetched_at = EXCLUDED.last_fetched_at,
  last_published_at = EXCLUDED.last_published_at,
  consecutive_fail_count = EXCLUDED.consecutive_fail_count,
  registered_by = EXCLUDED.registered_by,
  status_reason = EXCLUDED.status_reason,
  type = EXCLUDED.type,
  categories = EXCLUDED.categories;

COMMIT;