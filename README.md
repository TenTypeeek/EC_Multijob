# 🧳 Eclipse Multijob

Let your players hold multiple jobs and switch between them in a couple of clicks.
**Eclipse Multijob** is a lightweight, framework-independent resource for FiveM that gives every player a sleek personal job menu, complete with paycheck info and automatic work-hour tracking.
Built for server owners who want a clean, optimized, and modern multijob system without unnecessary bloat.

---

## 💬 Community & Support

Join our Discord community for support, updates, script releases, and custom development!

* **📢 Announcements & Updates:** Be the first to get news on updates and new features.
* **🛠️ Support & Help:** Need help installing or setting up the script? Open a support ticket.
* **💡 Feature Requests:** Have ideas to make Eclipse Multijob better? We'd love to hear them!

👉 **[Click Here to Join the Discord Community](https://discord.gg/5D3wdy4dQH)**

---

## 🚀 Why Eclipse Multijob?

Players rarely stick to a single job. Constantly asking admins to change their job is tedious, and many multijob scripts are locked to one framework or look outdated.
**Eclipse Multijob** works out of the box with both **ESX** and **QBCore**, saves every job a player has held, and lets them switch between them from a modern, responsive interface, all while tracking how long they have worked at each one.

---

## ✨ Features

* **🧳 Multiple Jobs Per Player:** Players can keep several jobs at once, with a configurable slot limit (default `3`).
* **🔄 One-Click Job Switching:** Switch to any saved job, or go unemployed, straight from the menu without needing an admin.
* **🤖 Automatic Job Tracking:** Jobs assigned by admins, bosses, or other scripts are automatically added to the player's list. Fired jobs are automatically removed (both configurable).
* **⏱️ Work Hour Tracking:** Tracks total, weekly, and daily hours for every job. Weekly and daily counters reset automatically.
* **💾 Persistent Hours:** Optionally keep a player's hours when they remove a job, so progress is there when they come back.
* **💵 Paycheck & Grade Info:** Displays the job label, current grade, and paycheck for each job in the menu.
* **🔒 Blocked & Locked Jobs:** Blacklist jobs from ever being added, or lock jobs so players can't remove them from their list.
* **🎮 Multiple Access Methods:** Open the menu using a configurable chat command (default `/multijob`) or a rebindable keybind (default `F5`).
* **🛡️ Built-in Protection:** Server-side validation and an action cooldown protect against spam and abuse.
* **🔌 Developer Exports:** Add, remove, and query player jobs from your own scripts.
* **🌍 Built-in Localization:** Includes English (`en`), Czech (`cs`), German (`de`), and Spanish (`es`) translations out of the box. Easily add your own by creating a new JSON file.

---

## 🛠️ Compatibility & Dependencies

* **Frameworks:** `es_extended` (ESX Legacy) or `qb-core` (QBCore), detected automatically
* **Required Scripts:** `ox_lib`, `oxmysql`

---

## 📥 Installation

1. Download the resource and place it into your server's `resources` folder.
2. Import the included `install.sql` into your database. It creates the `multijob_jobs` table.
3. Open `config.lua` and adjust the settings to your liking (framework, locale, job limit, blocked jobs, etc.).
4. Add `ensure ec_multijob` (or whatever you named the folder) to your `server.cfg`, ensuring it starts *after* your framework, `ox_lib`, and `oxmysql`.
5. Restart your server.

Your players can now press **F5** or type **/multijob** to manage their jobs!

---

## ⚙️ Configuration

Everything is configured in `config.lua`:

| Option | Default | Description |
| --- | --- | --- |
| `Config.Framework` | `'auto'` | `'auto'`, `'esx'`, or `'qb'`. Auto detects the running framework. |
| `Config.Locale` | `'en'` | Language file to use (`en`, `cs`, `de`, `es`). |
| `Config.Command` | `'multijob'` | Chat command that opens the menu. |
| `Config.Keybind` | `'F5'` | Default keybind (players can rebind it in their settings). Set to `''` to disable. |
| `Config.MaxJobs` | `3` | Maximum number of jobs a player can hold at once. |
| `Config.UnemployedJob` | `'unemployed'` | Name of your framework's unemployed job. |
| `Config.BlockedJobs` | `{}` | Jobs that can never be added to a player's list. |
| `Config.LockedJobs` | `{}` | Jobs that players cannot remove from their list. |
| `Config.AutoAddJobs` | `true` | Automatically add jobs the player receives to their list. |
| `Config.RemoveFiredJobs` | `true` | Automatically remove a job when the player is set to unemployed. |
| `Config.TrackHours` | `true` | Track total, weekly, and daily hours per job. |
| `Config.KeepHours` | `true` | Keep hours saved when a job is removed. |
| `Config.Cooldown` | `2` | Seconds between menu actions (anti-spam). |
| `Config.NotifyPosition` | `'top'` | Position of `ox_lib` notifications. |
| `Config.NotifyDuration` | `5000` | Notification duration in milliseconds. |

---

## 🔌 Exports (Server)

Integrate Eclipse Multijob into your own scripts:

```lua
-- Add a job to a player's list. Returns true, or false + error key.
exports['ec_multijob']:AddJob(source, 'police', 2)

-- Remove a job from a player's list.
exports['ec_multijob']:RemoveJob(source, 'police')

-- Check whether a player has a job in their list.
local hasJob = exports['ec_multijob']:HasJob(source, 'police')

-- Get all of a player's jobs (job, grade, total, week, day).
local jobs = exports['ec_multijob']:GetJobs(source)
```

---

## 🌍 Adding a Language

1. Copy `locales/en.json` and rename it (for example `fr.json`).
2. Translate the values, leaving the keys untouched.
3. Set `Config.Locale = 'fr'` in `config.lua`.

Missing keys automatically fall back to English.

---

## 👀 Showcase

<!-- Add your screenshots here, for example: -->
<!-- ![Multijob Menu](https://i.imgur.com/your-image.png) -->

---

<div align="center">

### 🌐 Created by Eclipse Development

Need help or custom FiveM scripts?  
[**Join our Discord**](https://discord.gg/5D3wdy4dQH)

</div>