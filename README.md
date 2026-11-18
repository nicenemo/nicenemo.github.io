# hanskruse.eu

The weblog and project index of Hans Kruse, built with [Hugo](https://gohugo.io/) (extended, pinned to 0.170.0) and
deployed to GitHub Pages by GitHub Actions.

## Local use

```bash
hugo server                 # http://localhost:1313/
hugo --gc --minify          # production build into public/
hugo new content post/2026-01-01-title.md
```

Hugo is installed on kos by the `dev-setup.yml` playbook of the [kos](https://github.com/nicenemo/kos) project (package
`hugo`, the extended build).

## Layout

* `hugo.toml`: site configuration. `data/projects.yaml`: the playbook projects and other links, used by the menu and
  the home page.
* `layouts/`: own templates, no theme. `assets/css/` has the site additions and the Chroma syntax colours (light and
  dark); `static/` has `style.css`, `menu.js`, `hero-bg.svg` and `favicon.svg`, which are identical in the kos, samos,
  mikmakmuk and multiberry project pages.
* `content/post/`: posts in Markdown, named `YYYY-MM-DD-title.md`. `content/about/`: the about page.

## Deployment

`.github/workflows/hugo.yml` builds the site on every push to `main` (and on request) and deploys it with the Pages
actions. In the repository settings, Pages > Source must be "GitHub Actions"; the custom domain is `hanskruse.eu`
(`static/CNAME`). Nothing else deploys the site.

## Security notes

The old `silhouette-hugo` theme was removed. It loaded these from CDNs, all outdated or end of life:

* Bootstrap 4.1.3 (XSS in tooltip and popover data attributes, CVE-2019-8331, fixed in 4.3.1; the 4.x line is EOL),
  jQuery 3.3.1 (prototype pollution CVE-2019-11358 and two XSS issues CVE-2020-11022 and CVE-2020-11023, fixed in 3.5.0),
  Popper 1.14.3, Font Awesome 5.5.0 and Google Fonts.
* Result: the site now has no third-party JavaScript, CSS, fonts or analytics. `menu.js` is the only script (14 lines,
  same origin), and the pages work without it.
* `metadata.xml` (SAML identity provider metadata of a former employer) and the Travis CI deployment, which pushed to
  a separate branch with a personal token, were removed.
* GitHub Actions are pinned to current major versions (checkout v7, configure-pages v6, upload-pages-artifact v5,
  deploy-pages v5), and Hugo is downloaded from the official release and verified against its published SHA-256 sums.
* There is no `package.json` or Go module, so there are no other dependencies. Posts may contain raw HTML
  (`markup.goldmark.renderer.unsafe`); they are the author's own.

## Linting and hooks

Run `./githooks-setup.sh` once per checkout. The `pre-commit` hook in `.githooks/` runs `gitleaks` on the staged
changes, `yamllint`, `actionlint` (the Pages workflow), `markdownlint-cli2` (README and posts) and a `hugo` build that
must finish without warnings, and `scripts/check-dependencies.sh` (no vendored libraries, nothing loaded from other
origins); the `pre-push` hook runs `trufflehog` on the commits being pushed and `osv-scanner` for known vulnerabilities. The hooks refuse to run
when a tool is missing. The tools are installed by the kos playbooks (`common_packages` in `inventory.yml`; `trufflehog`
is a manual install; `osv-scanner` is installed from `common_packages` too). Never bypass the hooks with `--no-verify`.
