# LM+ Locator docs site

This is a [Starlight](https://starlight.astro.build/) (Astro) site that turns the Markdown files in [/docs](../docs/) into a browsable documentation website.

## How it's wired up

There's no separate copy of the docs. [src/content.config.ts](src/content.config.ts) points Starlight's content loader straight at `../docs`, so every `.md` file in the repo's `docs/` folder becomes a page here:

| File in `/docs` | Page |
|---|---|
| `README.md` | `/` (home page) |
| `architecture.md` | `/architecture/` |
| `features.md` | `/features/` |
| `data-pipeline.md` | `/data-pipeline/` |

Each of those files needs a `title` (and optionally a `description`) in a small YAML frontmatter block at the top, which Starlight uses for the page title, browser tab title, and `<meta>` description. The sidebar in [astro.config.mjs](astro.config.mjs) lists those four pages explicitly, so a new file in `/docs` needs a line added there too to show up in the sidebar.

## Commands

Run these from inside `docs-site/`:

| Command | What it does |
|---|---|
| `npm install` | Installs dependencies (only needed once, or after `package.json` changes) |
| `npm run dev` | Starts a local dev server at `http://localhost:4321/` with live reload |
| `npm run build` | Builds the static site into `dist/` |
| `npm run preview` | Serves the built `dist/` locally, to sanity-check a production build |

## Editing the docs

Edit the `.md` files in `/docs` as normal. With `npm run dev` running, the site picks up changes and reloads automatically, same as editing any other Astro/Starlight content.

There's currently no automated deployment: `npm run build` produces a static `dist/` folder that would need to be hosted somewhere (e.g. GitHub Pages, Netlify, Vercel) and rebuilt/redeployed whenever the docs change. Until that's set up, this site is for local previewing; `/docs` on GitHub remains the canonical place to read the docs.
