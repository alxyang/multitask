# Multitask

Keep four tiny games alive at the same time. A browser remake of the Flash game *Multitask* by IcyLime.

**Play it:** https://alxyang.github.io/multitask/

You start with one game. A new one joins at 0:12, 0:27 and 0:45, and everything speeds up the longer you last. One mistake in any panel ends the run. Your score is how long you survived.

| Task | Keys | Goal |
|---|---|---|
| Balance | ← → | Tilt the plank so the ball stays on. Watch the wind. |
| Dodge | ↑ ↓ | Hop between five boxes to dodge the arrows. |
| Zones | W A S D | Touch every box with your square before its countdown hits zero. |
| Hover | Space | Hold to rise, let go to drop. Fly past the walls. |

P pauses and M mutes.

## Scores

After each run you enter a name of up to six letters or numbers; a run only goes on the shared scoreboard once it has a name, and the game remembers it for next time. The scoreboard has three tabs: **Today** (resets at midnight UTC), **All time** and **Recent**. Every run is saved in the player's browser. When the shared scoreboard is configured (see below), runs also go to a Supabase table so everyone sees the same boards; if it can't be reached, the game falls back to the browser's scores.

## Phones and tablets

The panels resize to fill the screen: a column in portrait, a 2×2 grid in landscape (recommended, so each thumb covers two games). Touch controls:

- **Balance:** hold the left or right side of its panel.
- **Dodge:** tap the top or bottom half to switch boxes.
- **Zones:** drag anywhere in its panel to steer, like a joystick.
- **Hover:** hold its panel to rise.

Use the full screen button where the browser supports it. On iPhone, add the page to your home screen (Share → Add to Home Screen) to play full screen.

## Run it locally

The whole game is `index.html`: no build step and no dependencies apart from two Google Fonts. Open the file in a browser, or serve the folder with `python3 -m http.server` and visit http://localhost:8000.

## Deployment

GitHub Pages serves `index.html` from the root of `main`, so every push to `main` updates the site. `manifest.webmanifest` and the `icon-*.png` files let the game be installed to a phone's home screen.

The shared scoreboard is set by the `SHARED` line in the game's script (`{ url, key }`: the Supabase project URL and its public anon or publishable key). Leave it empty to keep scores in each browser only.

`supabase/migrations/` holds the database setup. Supabase's GitHub integration runs new migration files when they're pushed to `main`. The scoreboard migration creates the scores table and its rules: names are 1-6 letters or digits, anyone can read scores and add one, nobody can change or delete them, the server stamps every score's time, times over 15 minutes are rejected, and at most 20 scores a minute (2,000 a day) are accepted. `.github/workflows/keep-scoreboard-awake.yml` reads one score a day so Supabase doesn't pause the free project; if the read fails, GitHub emails you.
