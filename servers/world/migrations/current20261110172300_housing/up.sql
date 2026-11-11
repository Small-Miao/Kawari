-- 排在已发布的 current_world 初始迁移之后。
ALTER TABLE volatile ADD COLUMN housing_location INTEGER NOT NULL DEFAULT 0;

CREATE TABLE housing_estate (
    district INTEGER NOT NULL CHECK (district IN (339, 340, 418, 641, 979)),
    ward INTEGER NOT NULL CHECK (ward BETWEEN 0 AND 29),
    plot INTEGER NOT NULL CHECK (plot BETWEEN 0 AND 59),
    owner_id BIGINT NOT NULL UNIQUE REFERENCES character(content_id) ON DELETE CASCADE,
    permit_id INTEGER NOT NULL DEFAULT 0,
    estate_name TEXT NOT NULL DEFAULT '',
    visitors_allowed BOOLEAN NOT NULL DEFAULT 0,
    state TEXT NOT NULL DEFAULT '{}',
    PRIMARY KEY (district, ward, plot)
);
