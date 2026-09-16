# DESIGN.md - Material 3 Expressive (M3E) Web Design Specification

This document details the visual guidelines, design token configurations, component structures, and code architecture for implementing a Material 3 Expressive (M3E) website.

---

## 1. Visual Language & Principles

This design utilizes Google's **Material 3 Expressive (M3E)** guidelines, adapted for web environments. It emphasizes:
1. **Dynamic Color & Containers:** Deep color nesting using five levels of surface containers to establish layout containment.
2. **High Shape Contrast:** Bold rounded corners, asymmetrical shapes, and dynamic shape-morphing transitions to focus user attention on interactions.
3. **Variable Typography:** Harnessing variable font axes (`wght` and `wdth`) to animate weights and scales during transitions.
4. **Fluid Motion:** Transition speeds mapping to standard, decelerated, and emphasized M3E bezier curves, ensuring interaction feel is responsive and tactile.

---

## 2. Core Tokens (CSS Theme Custom Properties)

Integrate these design tokens into your website's main stylesheet (e.g. `theme.css`). They support auto-switching dark mode.

```css
:root {
  /* Color Roles - Light Theme */
  --md-sys-color-primary: #6750A4;
  --md-sys-color-on-primary: #FFFFFF;
  --md-sys-color-primary-container: #EADDFF;
  --md-sys-color-on-primary-container: #21005D;
  
  --md-sys-color-secondary: #625B71;
  --md-sys-color-on-secondary: #FFFFFF;
  --md-sys-color-secondary-container: #E8DEF8;
  --md-sys-color-on-secondary-container: #1D192B;
  
  --md-sys-color-tertiary: #7D5260;
  --md-sys-color-on-tertiary: #FFFFFF;
  --md-sys-color-tertiary-container: #FFD8E4;
  --md-sys-color-on-tertiary-container: #31111D;
  
  --md-sys-color-surface: #FEF7FF;
  --md-sys-color-on-surface: #1D1B20;
  --md-sys-color-surface-variant: #E7E0EC;
  --md-sys-color-on-surface-variant: #49454F;
  
  /* Spacing Surfaces */
  --md-sys-color-surface-container-lowest: #FFFFFF;
  --md-sys-color-surface-container-low: #F7F2FA;
  --md-sys-color-surface-container: #F3EDF7;
  --md-sys-color-surface-container-high: #ECE6F0;
  --md-sys-color-surface-container-highest: #E6E1E5;
  
  --md-sys-color-outline: #79747E;
  --md-sys-color-outline-variant: #C4C2C7;
  --md-sys-color-shadow: rgba(0, 0, 0, 0.08);
  --md-sys-color-scrim: rgba(0, 0, 0, 0.35);
  --md-sys-color-focus-outline: #6750A4;

  /* Shapes */
  --md-sys-shape-corner-none: 0px;
  --md-sys-shape-corner-extra-small: 4px;
  --md-sys-shape-corner-small: 8px;
  --md-sys-shape-corner-medium: 12px;
  --md-sys-shape-corner-large: 16px;
  --md-sys-shape-corner-extra-large: 28px;
  --md-sys-shape-corner-full: 9999px;
  
  /* Expressive Asymmetric Morph Presets */
  --md-sys-shape-expressive-primary-default: 28px 12px 28px 12px;
  --md-sys-shape-expressive-primary-hover: 12px 28px 12px 28px;
  --md-sys-shape-expressive-card: 24px 12px 24px 12px;

  /* Typography */
  --md-sys-typescale-font-family: 'Roboto Flex', 'Inter', system-ui, -apple-system, sans-serif;
  
  /* Motion & Easing */
  --md-sys-motion-duration-short: 150ms;
  --md-sys-motion-duration-medium: 300ms;
  --md-sys-motion-duration-long: 500ms;
  --md-sys-motion-easing-standard: cubic-bezier(0.2, 0, 0, 1);
  --md-sys-motion-easing-emphasized: cubic-bezier(0.3, 0, 0, 1);
  
  /* Elevation Shadows */
  --md-sys-elevation-1: 0px 1px 3px 1px var(--md-sys-color-shadow), 0px 1px 2px 0px rgba(0, 0, 0, 0.15);
  --md-sys-elevation-2: 0px 2px 6px 2px var(--md-sys-color-shadow), 0px 1px 2px 0px rgba(0, 0, 0, 0.15);
  --md-sys-elevation-3: 0px 4px 8px 3px var(--md-sys-color-shadow), 0px 1px 3px 0px rgba(0, 0, 0, 0.15);
}

@media (prefers-color-scheme: dark) {
  :root {
    /* Color Roles - Dark Theme */
    --md-sys-color-primary: #D0BCFF;
    --md-sys-color-on-primary: #381E72;
    --md-sys-color-primary-container: #4F378B;
    --md-sys-color-on-primary-container: #EADDFF;
    
    --md-sys-color-secondary: #CCC2DC;
    --md-sys-color-on-secondary: #332D41;
    --md-sys-color-secondary-container: #4A4458;
    --md-sys-color-on-secondary-container: #E8DEF8;
    
    --md-sys-color-tertiary: #EFB8C8;
    --md-sys-color-on-tertiary: #492532;
    --md-sys-color-tertiary-container: #633B48;
    --md-sys-color-on-tertiary-container: #FFD8E4;
    
    --md-sys-color-surface: #141218;
    --md-sys-color-on-surface: #E6E1E5;
    --md-sys-color-surface-variant: #49454F;
    --md-sys-color-on-surface-variant: #C4C2C7;
    
    --md-sys-color-surface-container-lowest: #0F0D13;
    --md-sys-color-surface-container-low: #1D1B20;
    --md-sys-color-surface-container: #211F26;
    --md-sys-color-surface-container-high: #2B2930;
    --md-sys-color-surface-container-highest: #36343B;
    
    --md-sys-color-outline: #938F99;
    --md-sys-color-outline-variant: #44474F;
    --md-sys-color-shadow: rgba(0, 0, 0, 0.25);
    --md-sys-color-focus-outline: #D0BCFF;
  }
}
```

---

## 3. Layout Architecture (Responsive App Shell)

The website layout dynamically switches navigation mechanisms to maintain optimal content width and readability:

```
  ┌────────────────────────────────────────────────────────┐
  │ [Logo]  Search Here...                (Avatar) (Theme) │  <- Top App Bar (Header)
  ├──────────────┬─────────────────────────────────────────┤
  │ [Home]       │  Welcome,                               │
  │ [Explore]    │  ┌───────────────────────────────────┐  │
  │ [Settings]   │  │   Hero Container (Interactive)    │  │  <- Hero Area
  │              │  └───────────────────────────────────┘  │
  │              │  ┌───────────────┐ ┌───────────────┐    │
  │              │  │  Card 1 (Asym)│ │  Card 2 (Asym)│    │  <- Expressive Cards Grid
  │              │  └───────────────┘ └───────────────┘    │
  │              │                                         │
  └──────────────┴─────────────────────────────────────────┘
   Navigation      Main Content Canvas (Nested surfaces)
   Drawer/Rail
```

- **Sidebar (Nav Rail/Drawer):** Collapsible panel on Expanded screens, locking to a slim 72px rail on tablet viewports, and moving to the bottom of the viewport as a Navigation Bar on compact mobile displays.
- **Surface Elevation Grouping:** The viewport background is set to `surface-container-lowest` or `surface`. Individual layout cards and sidebar navigations rest on elevated panels like `surface-container` and `surface-container-high`.

---

## 4. Key Expressive Components & Code Structures

### A. Shape-Morphing CTA Button
An interactive element where shapes transition on hover/focus to indicate clickability.

```html
<button class="m3e-btn-primary">
  Explore Now
</button>
```

```css
.m3e-btn-primary {
  font-family: var(--md-sys-typescale-font-family);
  font-size: 0.875rem;
  font-weight: 500;
  letter-spacing: 0.1px;
  line-height: 1.25rem;
  height: 48px;
  padding: 0 24px;
  border: none;
  cursor: pointer;
  background: var(--md-sys-color-primary);
  color: var(--md-sys-color-on-primary);
  border-radius: var(--md-sys-shape-expressive-primary-default);
  box-shadow: var(--md-sys-elevation-1);
  position: relative;
  overflow: hidden;
  transition: border-radius var(--md-sys-motion-duration-medium) var(--md-sys-motion-easing-emphasized),
              box-shadow var(--md-sys-motion-duration-short) linear;
}

/* Hover & Focus state layers overlay */
.m3e-btn-primary::before {
  content: "";
  position: absolute;
  inset: 0;
  background: var(--md-sys-color-on-primary);
  opacity: 0;
  transition: opacity var(--md-sys-motion-duration-short) linear;
}

.m3e-btn-primary:hover {
  border-radius: var(--md-sys-shape-expressive-primary-hover);
  box-shadow: var(--md-sys-elevation-2);
}

.m3e-btn-primary:hover::before {
  opacity: 0.08; /* hover overlay opacity */
}

.m3e-btn-primary:focus-visible {
  outline: 3px solid var(--md-sys-color-focus-outline);
  outline-offset: 2px;
}
```

### B. Expressive Feed Cards
Cards grouping dashboard modules or articles, morphing their shape asymmetry when hovered.

```html
<article class="m3e-feed-card">
  <h3>Material 3 Expressive Spec</h3>
  <p>Learn how shapes, variable-font scaling, and motion improve information hierarchy.</p>
</article>
```

```css
.m3e-feed-card {
  padding: 24px;
  background: var(--md-sys-color-surface-container);
  border: 1px solid var(--md-sys-color-outline-variant);
  border-radius: var(--md-sys-shape-expressive-card);
  transition: transform var(--md-sys-motion-duration-medium) var(--md-sys-motion-easing-emphasized),
              border-radius var(--md-sys-motion-duration-medium) var(--md-sys-motion-easing-emphasized),
              box-shadow var(--md-sys-motion-duration-medium) ease,
              border-color var(--md-sys-motion-duration-short) linear;
}

.m3e-feed-card:hover {
  transform: translateY(-4px) scale(1.015);
  border-radius: 12px 24px 12px 24px;
  border-color: var(--md-sys-color-outline);
  box-shadow: var(--md-sys-elevation-2);
  background: var(--md-sys-color-surface-container-high);
}
```

### C. Floating Docked Toolbar
A centrally-anchored navigation bar resting at the bottom of the screen. Ideal for layout filtering or screen tools.

```html
<nav class="m3e-docked-toolbar">
  <button class="m3e-toolbar-item m3e-toolbar-item--active">🔍</button>
  <button class="m3e-toolbar-item">⚡</button>
  <button class="m3e-toolbar-item">⚙️</button>
</nav>
```

```css
.m3e-docked-toolbar {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 8px;
  padding: 8px;
  background: var(--md-sys-color-surface-container-highest);
  border-radius: var(--md-sys-shape-corner-full);
  box-shadow: var(--md-sys-elevation-3);
  z-index: 100;
}

.m3e-toolbar-item {
  width: 48px;
  height: 48px;
  border: none;
  background: transparent;
  border-radius: var(--md-sys-shape-corner-full);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--md-sys-motion-duration-short) linear;
}

.m3e-toolbar-item:hover {
  background: rgba(0, 0, 0, 0.05);
}

.m3e-toolbar-item--active {
  background: var(--md-sys-color-secondary-container);
  color: var(--md-sys-color-on-secondary-container);
}
```

---

## 5. Interaction & Accessibility Standards

1. **Focus Ring Indication:** Never remove outlines on elements. Implement a clear, thick focus ring:
   ```css
   :focus-visible {
     outline: 3px solid var(--md-sys-color-focus-outline);
     outline-offset: 2px;
   }
   ```
2. **Touch Targets:** All interactive anchors and buttons must occupy a minimum clickable footprint of `48px x 48px` to support mobile usage.
3. **Respecting Reduced Motion Preferences:** All layout morphing, hover animations, and sliding panel behaviors must honor the system reduced motion scale:
   ```css
   @media (prefers-reduced-motion: reduce) {
     *, *::before, *::after {
       animation-delay: -1ms !important;
       animation-duration: 1ms !important;
       animation-iteration-count: 1 !important;
       background-attachment: initial !important;
       scroll-behavior: auto !important;
       transition-duration: 0s !important;
       transition-delay: 0s !important;
     }
   }
   ```
