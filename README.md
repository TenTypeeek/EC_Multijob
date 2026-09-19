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

## 👀 Showcase

![MyJobs](https://i.imgur.com/R3UFo7A.png)
![Job](https://i.imgur.com/SlvSDB5.png)

---

<div align="center">

### 🌐 Created by Eclipse Development

Need help or custom FiveM scripts?  
[**Join our Discord**](https://discord.gg/5D3wdy4dQH)

</div>