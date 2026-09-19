CREATE TABLE IF NOT EXISTS `multijob_jobs` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `identifier`    VARCHAR(60)  NOT NULL,
    `job`           VARCHAR(50)  NOT NULL,
    `grade`         INT          NOT NULL DEFAULT 0,
    `active`        TINYINT(1)   NOT NULL DEFAULT 1,
    `total_seconds` INT UNSIGNED NOT NULL DEFAULT 0,
    `week_seconds`  INT UNSIGNED NOT NULL DEFAULT 0,
    `day_seconds`   INT UNSIGNED NOT NULL DEFAULT 0,
    `week_key`      VARCHAR(10)  NOT NULL DEFAULT '',
    `day_key`       VARCHAR(10)  NOT NULL DEFAULT '',
    `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_identifier_job` (`identifier`, `job`),
    KEY `idx_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
