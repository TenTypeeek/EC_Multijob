# 💼 Eclipse BossMenu

Take complete control over your job societies with a modern and responsive management system.
**Eclipse BossMenu** is a lightweight, feature-rich resource for FiveM that allows job bosses to efficiently manage their employees, society funds, and recruitment from a sleek user interface.
Built for server owners who want a seamless, optimized, and visually appealing boss menu without unnecessary bloat.

---

## 💬 Community & Support

Join our Discord community for support, updates, script releases, and custom development!

* **📢 Announcements & Updates:** Be the first to get news on updates and new features.
* **🛠️ Support & Help:** Need help installing or setting up the script? Open a support ticket.
* **💡 Feature Requests:** Have ideas to make Eclipse BossMenu better? We'd love to hear them!

👉 **[Click Here to Join the Discord Community](https://discord.gg/5D3wdy4dQH)**

---

## 🚀 Why Eclipse BossMenu?

Managing a business or faction in FiveM should be intuitive. Many older boss menus are clunky, rely on outdated menus, or lack essential visual feedback.
**Eclipse BossMenu** acts as your all-in-one company dashboard. It integrates smoothly with modern resources like `ox_target` and `ox_lib`, providing real-time activity logs, easy nearby player recruitment, and seamless offline employee management.

---

## ✨ Features

* **📊 Modern Dashboard UI:** A responsive, sleek HTML/CSS/JS interface displaying real-time statistics, active employees, and society balances.
* **💰 Society Funds Management:** Easily deposit and withdraw money from your company's `esx_addonaccount`.
* **📝 Activity Logging:** Automatically tracks and displays recent financial transactions, hires, and rank changes directly in the UI.
* **👥 Advanced Employee Management:** Hire players in your immediate vicinity, promote or demote staff, and fire employees (even if they are currently offline).
* **🎯 Multiple Access Methods:** Open the menu anywhere via a configurable chat command (default `/bossmenu`) or interact via `ox_target` zones at specific job locations.
* **📱 Immersive Animations:** Automatically plays a tablet animation and attaches a prop to the player's hands while the menu is active.
* **🌍 Built-in Localization:** Includes English (`en`) and Czech (`cs`) translations out of the box. Automatically adapts to the server's `ox:locale` convar or can be manually overridden.

---

## 🛠️ Compatibility & Dependencies

* **Framework:** `es_extended` (ESX Legacy)
* **Required Scripts:** `ox_lib`, `ox_target`, `esx_addonaccount`, `oxmysql`

---

## 📥 Installation

1. Download the resource and place it into your server's `resources` folder.
2. Open `config.lua` to define which jobs have boss menu access, set the minimum required grades, and configure the precise `ox_target` locations for each job.
3. Verify your desired language settings in `config.lua` (leave as `false` to let `ox_lib` handle it automatically).
4. Add `ensure ec_bossmenu` (or whatever you named the folder) to your `server.cfg`, ensuring it starts *after* all required dependencies.
5. Restart your server.

Your faction leaders and business owners are now ready to manage their teams!

---

## 👀 Showcase

![Dashboard](https://i.imgur.com/kYcyjcg.png)
![Employees](https://i.imgur.com/oOzUNxK.png)
![Company Account](https://i.imgur.com/eWuEh9I.png)
![Ranks & Salaries](https://i.imgur.com/6xowwdB.png)
![Recruit](https://i.imgur.com/cpvhs8U.png)

---

<div align="center">

### 🌐 Created by Eclipse Development

Need help or custom FiveM scripts?  
[**Join our Discord**](https://discord.gg/5D3wdy4dQH)

</div>