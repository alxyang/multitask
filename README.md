# Multitask

Keep four tiny games alive at the same time. A browser remake of the Flash game *Multitask* by IcyLime.

**Play it:** https://alxyang.github.io/multitask/

You start with one game. A new one joins at 0:12, 0:27 and 0:45, and everything speeds up the longer you last. One mistake in any panel ends the run. Your score is how long you survived.

| Task | Keys | Goal |
|---|---|---|
| Balance | ← → | Tilt the plank so the ball stays on. Watch the wind. |
| Dodge | ↑ ↓ | Hop between five boxes to dodge the arrows. |
| Zones | W A S D | Keep your square inside a box. Move into the next one before it vanishes. |
| Jump | Space | Hop over the blocks. |

P pauses and M mutes. On a touch screen, hold either half of Balance to tilt it, tap the top or bottom of Dodge to switch boxes, hold where the Zones square should go, and tap Jump to hop.

## Run it locally

The whole game is `index.html`: no build step and no dependencies apart from two Google Fonts. Open the file in a browser, or serve the folder with `python3 -m http.server` and visit http://localhost:8000.

## Deployment

GitHub Pages serves `index.html` from the root of `main`, so every push to `main` updates the site.
