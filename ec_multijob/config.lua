Config = {}

-- Set to 'esx' or 'qb', override the automatic detection.
Config.Framework = 'auto'

-- Set to 'en', 'cs', etc., to change language.
Config.Locale = 'en'

-- command to open the multijob menu.
Config.Command = 'multijob'
-- set to '' to remove this option
Config.Keybind = 'F5'

-- Maximum number of jobs a player can have at once.
Config.MaxJobs = 3
-- Job the unemployed player is assigned to when they have no jobs.
Config.UnemployedJob = 'unemployed'
-- Jobs the player cannot add.
Config.BlockedJobs = {}
-- Jobs the player cannot remove. (Config.UnemployedJob is always locked)
Config.LockedJobs = {}

-- Keep this true i have no idea why you would change it.
Config.AutoAddJobs = true
Config.RemoveFiredJobs = true

-- Set to true to track the number of hours a player has worked in each job.
Config.TrackHours = true
Config.KeepHours = true

-- Cooldown between job changes.
Config.Cooldown = 2

-- Notify position and duration in milliseconds. (mainly for ox_lib)
Config.NotifyPosition = 'top'
Config.NotifyDuration = 5000