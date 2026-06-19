# Fish Scripts (mksite & start)

Een verzameling van twee krachtige, native Fish shell scripts die de web-development workflow drastisch versnellen. 

Beide scripts draaien lokaal op je machine en zijn ontworpen met snelheid en robuustheid in gedachten.

---

## 1. `mksite` (De Ultieme Webproject Builder)
`mksite` is een interactieve generator die in enkele seconden een compleet webproject voor je opzet, formatteert en lanceert. 

**Features:**
- **Express.js Monolith**: Productie-ready backend met SQLite en ingebouwde error-handlers.
- **Vite Front-end**: Bliksemsnelle vanilla JS front-end template.
- **Vanilla Split**: API en Frontend (Vite) perfect gescheiden, samen gedraaid via Concurrently.
- **Premium Full-stack**: Een prachtig geconfigureerde React + Tailwind CSS client, gekoppeld aan een Express/SQLite API.
- **Automatisering**: Formatteert de code met Prettier, maakt `.gitignore` bestanden aan, doet de eerste Git commit én pusht de code direct naar een **nieuwe privé GitHub repository**.

---

## 2. `start` (De Slimme Dev Server Launcher)
Geen zin meer om handmatig mappen te openen en poorten te zoeken? `start` neemt het over.

**Features:**
- **Automatische Detectie**: Scant de `~/Development/` map en toont al je projecten in een keuzemenu.
- **Nieuwe Terminal**: Start de dev-server (`npm run dev`) automatisch op in een losse Alacritty (of Konsole) window, zodat je huidige terminal bruikbaar blijft.
- **Revolutionaire Poort Detectie**: Leest real-time de output van je dev-server uit. Zodra Vite of Express logt op welke poort hij draait (bijv. `http://localhost:5174`), opent het script **exact die poort** volautomatisch in je browser.

---

## ⚙️ Auto-Sync Workflow (Systemd)
Deze repository onderhoudt zichzelf! 
Op de achtergrond draait een `systemd` user-service (`fish-scripts-sync.path`). Zodra je één van de originele bestanden (`~/.config/fish/functions/mksite.fish` of `start.fish`) bewerkt en opslaat, springt de watcher aan.
Hij kopieert het script, maakt een commit, en pusht de wijzigingen geruisloos naar GitHub. 

Je hoeft zelf dus **nooit** handmatig te pushen!
