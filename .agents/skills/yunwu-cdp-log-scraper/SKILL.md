---
name: yunwu-cdp-log-scraper
description: Connect to a running Chrome CDP session, handle authentication states, interact with React/Semi-UI tabular components, expand and parse detail rows, and translate multilingual cell data to generate a clean CSV.
disable-model-invocation: true
---

# Yunwu CDP Log Scraper

Use this skill when you need to automate log or data extraction from a console web interface (such as `yunwu.ai/console/log`) using a running Chrome instance connected via Chrome DevTools Protocol (CDP).

## Prerequisites & Setup

### 1. Connection
Automated tools should connect to Chrome via standard Puppeteer/Playwright using the debugging port:
```javascript
const puppeteer = require('puppeteer');
const browser = await puppeteer.connect({ browserURL: 'http://127.0.0.1:9222' });
const pages = await browser.pages();
const page = pages.find(p => p.url().includes('console/log'));
```

### 2. Session Authentication Injection
If a fresh headless profile is started and redirects to a login page (e.g., `login?expired=true`), transfer cookies and local storage from the user's home Chrome profile:
- **Source Paths (macOS):**
  - `~/Library/Application Support/Google/Chrome/Default/Cookies`
  - `~/Library/Application Support/Google/Chrome/Default/Local Storage`
- **Action:**
  1. Kill the running headless Chrome process (`pkill -f "/tmp/chrome-profile"`).
  2. Copy both the `Cookies` file and the entire `Local Storage` directory into the temporary profile path (e.g., `/tmp/chrome-profile/Default/`).
  3. Restart Chrome with the remote debugging flags and connect again.

---

## Interacting with the Web UI

### 1. Changing Layouts
Web dashboards (especially those using Douyinfe Semi-UI) often have responsive card-based grids and compact table layouts. Toggle to **Compact list** (which renders standard HTML `table`, `tr`, `td` elements) rather than parsing flexible card grids:
- Look for a button containing "Compact list" or "Adaptive list" and click it.

### 2. Modifying React-Controlled Date Inputs
Directly updating input `value` properties will not trigger state updates in React. Use the standard prototype value setter dispatch pattern:
```javascript
function setReactInputValue(inputEl, value) {
  const valueSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, "value").set;
  const prototype = Object.getPrototypeOf(inputEl);
  const prototypeValueSetter = Object.getOwnPropertyDescriptor(prototype, "value").set;
  
  if (valueSetter && valueSetter !== prototypeValueSetter) {
    prototypeValueSetter.call(inputEl, value);
  } else {
    valueSetter.call(inputEl, value);
  }
  inputEl.dispatchEvent(new Event('input', { bubbles: true }));
  inputEl.dispatchEvent(new Event('change', { bubbles: true }));
}
```

---

## Sequential Row Extraction (Accordion Handling)

UI libraries like Semi Design often enforce accordion constraints or React state batching, preventing multiple rows from being expanded synchronously.
- **Rule:** Do not batch-click all rows. Click each row sequentially, wait for the details to render, parse the values, and collapse the row.

### Extraction Pattern
```javascript
for (const row of rows) {
  const isExpandable = row.getAttribute('aria-expanded') !== null || !!row.querySelector('.semi-table-expand-icon');
  
  let detailsJSON = '';
  if (isExpandable) {
    // 1. Expand row
    if (row.getAttribute('aria-expanded') === 'false') {
      row.click();
      await new Promise(r => setTimeout(r, 100)); // Wait for DOM injection
    }
    
    // 2. Parse descriptions table
    const desc = document.querySelector(`tr[data-row-key="${row.key}-expanded-row"] .semi-descriptions`);
    if (desc) {
      const details = {};
      desc.querySelectorAll('table tr').forEach(tr => {
        const keyEl = tr.querySelector('.semi-descriptions-key');
        const valEl = tr.querySelector('.semi-descriptions-value');
        if (keyEl && valEl) {
          details[keyEl.innerText.trim()] = valEl.innerText.trim().replace(/\s*Copy\s*$/, '').trim();
        }
      });
      
      detailsJSON = JSON.stringify({
        'Request ID': details['Request ID'] || '',
        'Cache Tokens': details['Cache Tokens'] || details['Create Tokens with 5m cache'] || '',
        'Log Details': details['Log details'] || details['Log Details'] || '',
        'Binning Process': details['Binning process'] || details['Binning Process'] || '',
        'Reasoning Effort': details['Reasoning Effort'] || details['Reasoning effort'] || ''
      });
    }
    
    // 3. Collapse row
    if (row.getAttribute('aria-expanded') === 'true') {
      row.click();
      await new Promise(r => setTimeout(r, 80)); // Wait for collapse
    }
  }
}
```

---

## Post-Processing: Translation & Cleanup

If the scraped console returns multilingual content (e.g., Chinese types or system notice messages) but the target output requires English:

1. **Scan:** Use Python to read the generated CSV and extract all unique cell values containing non-ASCII characters:
   ```python
   re.search(r'[\u4e00-\u9fff]', cell_value)
   ```
2. **Translate:** Feed each unique string to the LLM completion API to translate the Chinese/multilingual parts to English while retaining numerical multipliers and formulas:
   ```python
   prompt = f"Translate any Chinese words in the text to English. Keep formulas and numbers: {text}"
   translation = completion(prompt)
   ```
3. **Map and Save:** Replace all occurrences of the Chinese values in the CSV rows with the translated English strings and write back to disk.
