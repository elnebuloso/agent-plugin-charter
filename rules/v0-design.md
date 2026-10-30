# Frontend before the design is agreed

The project's web frontend is built for structure and function, not looks: its visual design is
not agreed yet, and anything styled before it is thrown away.

- **No own styling.** No colours, fonts, shadows, radii, animations or theming — not in global CSS,
  not in `<style>` blocks, not inline, not as utility classes. Structural CSS only: layout
  (flex/grid), sizes, spacing, visibility — as utility classes too. Anything beyond that only where
  the UI is otherwise not operable, with a comment saying why.
- **Native elements keep the browser default.** No reset or normalize of your own — at most
  `box-sizing: border-box` and `margin: 0` on `body` where the layout needs it. One a framework
  applies by default stays, untouched.
- **Third-party components keep the styling they ship, unmodified** — components copied into the
  project included.
- **Design skills stay off.** Load no design, styling or animation skill for frontend work, even
  when its description matches — unless the user asks for one by name.
