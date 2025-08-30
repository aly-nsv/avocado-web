-- Insert all I-4 and I-95 cameras into database
-- Generated: 2025-08-28 18:34:02.865778
-- Total cameras: 776

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2242', 'EBM at Selmon Connector ramp', 'EBM at Selmon Connector ramp', 
    27.964729, -82.428684, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'EBM at Selmon Connector ramp', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2243', 'at 31st St', 'at 31st St', 
    27.965421, -82.425622, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'at 31st St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2325', 'I-4 at Alexander St', 'I-4 at Alexander St', 
    28.030849, -82.136942, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at Alexander St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2327', 'I-4 WB at MM 15.8', 'I-4 WB at MM 15.8', 
    28.027971, -82.216066, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 WB at MM 15.8', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2328', 'I-4 at US-41 / 50th St', 'I-4 at US-41 / 50th St', 
    27.967479, -82.402471, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at US-41 / 50th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2330', 'I-4 E of Mango Rd', 'I-4 E of Mango Rd', 
    28.008496, -82.288043, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 E of Mango Rd', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2377', 'WBM at Selmon Connector', 'WBM at Selmon Connector', 
    27.965362, -82.426935, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'WBM at Selmon Connector', '2024-12-12T16:12:05.5001444+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2403', 'Seffner I-4 Weigh Station EB 70691', 'Seffner I-4 Weigh Station EB 70691', 
    28.015803, -82.265786, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'Seffner I-4 Weigh Station EB 70691', '2024-12-12T16:12:05.5017114+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2449', 'I-4 at SR-574 / M L K Jr Blvd', 'I-4 at SR-574 / M L K Jr Blvd', 
    27.982886, -82.382987, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at SR-574 / M L K Jr Blvd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2450', 'I-4 at I-75 Overpass', 'I-4 at I-75 Overpass', 
    28.002719, -82.324369, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at I-75 Overpass', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2474', 'I-4 at Paul Buchman Hwy', 'I-4 at Paul Buchman Hwy', 
    28.035643, -82.124734, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at Paul Buchman Hwy', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2476', 'I-4 at Park Rd', 'I-4 at Park Rd', 
    28.036775, -82.104, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at Park Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2484', 'I-4 EB at I-75', 'I-4 EB at I-75', 
    28.001336, -82.330566, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 EB at I-75', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2488', 'I-4 E of McIntosh Rd', 'I-4 E of McIntosh Rd', 
    28.026033, -82.231338, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 E of McIntosh Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2490', 'I-4 at Thonotosassa Rd', 'I-4 at Thonotosassa Rd', 
    28.027182, -82.153932, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at Thonotosassa Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2495', 'I-4 W of I-75', 'I-4 W of I-75', 
    27.998097, -82.340536, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 W of I-75', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2497', 'I-4 W of McIntosh Rd', 'I-4 W of McIntosh Rd', 
    28.019792, -82.2596, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 W of McIntosh Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2498', 'EB at Weigh Station', 'EB at Weigh Station', 
    28.011659, -82.278204, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'EB at Weigh Station', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2506', 'EB at 21st/22nd ramp', 'EB at 21st/22nd ramp', 
    27.964457, -82.440979, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'EB at 21st/22nd ramp', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2513', 'I-4 WB at Hillsborough Ave', 'I-4 WB at Hillsborough Ave', 
    27.993983, -82.368688, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 WB at Hillsborough Ave', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2515', 'I-4 E of Park Rd', 'I-4 E of Park Rd', 
    28.036837, -82.088383, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 E of Park Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2517', 'I-4 EB at Hillsborough Ave', 'I-4 EB at Hillsborough Ave', 
    27.995955, -82.362665, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 EB at Hillsborough Ave', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2520', 'I-4 at I-75', 'I-4 at I-75', 
    28.002349, -82.322555, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at I-75', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2522', 'I-4 at McIntosh Rd', 'I-4 at McIntosh Rd', 
    28.046909, -82.403297, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at McIntosh Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2523', 'I-4 W of Thonotosassa Rd', 'I-4 W of Thonotosassa Rd', 
    28.02662, -82.165474, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 W of Thonotosassa Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2530', 'I-4 W of SR-574 /M L K Jr Blvd', 'I-4 W of SR-574 /M L K Jr Blvd', 
    27.974886, -82.392213, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 W of SR-574 /M L K Jr Blvd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2540', 'I-4 at U S Hwy 301', 'I-4 at U S Hwy 301', 
    27.996328, -82.35711, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at U S Hwy 301', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2660', 'I-4 W of County Line Rd', 'I-4 W of County Line Rd', 
    28.036658, -82.072214, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 W of County Line Rd', '2024-12-12T16:12:05.5180071+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2695', 'I-4 at I-275', 'I-4 at I-275', 
    27.96498, -82.450428, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at I-275', '2024-12-12T16:12:05.5204282+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2698', 'I-4 at CR-579 / Mango Rd', 'I-4 at CR-579 / Mango Rd', 
    28.00675, -82.30193, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at CR-579 / Mango Rd', '2024-12-12T16:12:05.5204282+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2706', 'I-4 WB W of US-41 / 50th St', 'I-4 WB W of US-41 / 50th St', 
    27.965589, -82.413742, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 WB W of US-41 / 50th St', '2024-12-12T16:12:05.5204282+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2708', 'I-4 EB at Selmon Connector', 'I-4 EB at Selmon Connector', 
    27.964498, -82.42259, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 EB at Selmon Connector', '2024-12-12T16:12:05.5204282+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2711', 'I-4 at I-75', 'I-4 at I-75', 
    28.00238, -82.32763, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 at I-75', '2024-12-12T16:12:05.5204282+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4305', 'I-4 EB side at 21st St', 'I-4 EB side at 21st St', 
    27.964451, -82.435417, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 EB side at 21st St', '2025-02-11T19:09:04.3565112+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4306', 'I-4 WB side at 21st St', 'I-4 WB side at 21st St', 
    27.965733, -82.435652, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 WB side at 21st St', '2025-02-11T19:12:07.2145014+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4307', 'WBM at Selmon Connector', 'WBM at Selmon Connector', 
    27.965337, -82.426947, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    'WBM at Selmon Connector', '2025-02-11T19:21:13.9312549+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4308', 'I-4 W of Branch Forbes Rd', 'I-4 W of Branch Forbes Rd', 
    28.027105, -82.203505, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Hillsborough', 
    'I-4 W of Branch Forbes Rd', '2025-02-11T19:25:02.2162568+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4319', '[not provided]', '[not provided]', 
    28.017514, -82.272647, 
    'I-4', 'Westbound', 'Tampa Bay', 'Hillsborough', 
    '[not provided]', '2025-02-11T21:10:08.608501+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '767', 'I-4 @ MM 81.7-SECURITY WB', 'I-4 @ MM 81.7-SECURITY WB', 
    28.523886, -81.38595, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 81.7-SECURITY WB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '802', 'I-4 @ MM 73.6 M', 'I-4 @ MM 73.6 M', 
    28.448292, -81.474283, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 73.6 M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '804', 'I-4 @ MM 73.8 EB', 'I-4 @ MM 73.8 EB', 
    28.450411, -81.471948, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 73.8 EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '807', 'I-4 @ MM 74.5 EB', 'I-4 @ MM 74.5 EB', 
    28.460944, -81.470639, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 74.5 EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '808', 'I-4 @ MM 75.0-SECURITY EB', 'I-4 @ MM 75.0-SECURITY EB', 
    28.462428, -81.461713, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 75.0-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '811', 'I-4 @ MM 75.1 WB', 'I-4 @ MM 75.1 WB', 
    28.468823, -81.466755, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 75.1 WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '812', 'I-4 @ MM 75.4-SECURITY M', 'I-4 @ MM 75.4-SECURITY M', 
    28.469906, -81.460053, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 75.4-SECURITY M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '813', 'I-4 @ MM 75.6-SECURITY WB', 'I-4 @ MM 75.6-SECURITY WB', 
    28.473916, -81.460833, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 75.6-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '814', 'I-4 @ MM 75.7-SECURITY EB', 'I-4 @ MM 75.7-SECURITY EB', 
    28.4702, -81.453731, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 75.7-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '815', 'I-4 @ MM 76.0-SECURITY WB', 'I-4 @ MM 76.0-SECURITY WB', 
    28.47914, -81.456928, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 76.0-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '816', 'I-4 @ MM 76.4-SECURITY EB', 'I-4 @ MM 76.4-SECURITY EB', 
    28.476009, -81.445555, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 76.4-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '817', 'I-4 @ MM 76.8 WB', 'I-4 @ MM 76.8 WB', 
    28.487401, -81.448087, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 76.8 WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '818', 'I-4 @ MM 77.2 EB', 'I-4 @ MM 77.2 EB', 
    28.483667, -81.434741, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 77.2 EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '819', 'I-4 @ MM 77.6-SECURITY EB', 'I-4 @ MM 77.6-SECURITY EB', 
    28.488344, -81.429526, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 77.6-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '820', 'I-4 @ MM 77.7-SECURITY EB', 'I-4 @ MM 77.7-SECURITY EB', 
    28.491362, -81.431758, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 77.7-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '822', 'I-4 @ MM 77.8-SECURITY EB', 'I-4 @ MM 77.8-SECURITY EB', 
    28.491663, -81.428453, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 77.8-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '823', 'I-4 @ MM 78.1-SECURITY EB', 'I-4 @ MM 78.1-SECURITY EB', 
    28.497294, -81.429478, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 78.1-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '825', 'I-4 @ MM 78.8-SECURITY EB', 'I-4 @ MM 78.8-SECURITY EB', 
    28.504204, -81.420643, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 78.8-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '826', 'I-4 @ MM 79.1-SECURITY WB', 'I-4 @ MM 79.1-SECURITY WB', 
    28.513273, -81.421523, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 79.1-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '827', 'I-4 @ MM 79.1-SECURITY EB', 'I-4 @ MM 79.1-SECURITY EB', 
    28.504279, -81.416759, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 79.1-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '828', 'I-4 @ MM 79.2-SECURITY EB', 'I-4 @ MM 79.2-SECURITY EB', 
    28.504185, -81.4156, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 79.2-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '830', 'I-4 @ MM 80.6-SECURITY WB', 'I-4 @ MM 80.6-SECURITY WB', 
    28.516648, -81.398541, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 80.6-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '832', 'I-4 @ MM 81.2-SECURITY WB', 'I-4 @ MM 81.2-SECURITY WB', 
    28.516894, -81.387417, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 81.2-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '833', 'I-4 @ MM 81.3-SECURITY EB', 'I-4 @ MM 81.3-SECURITY EB', 
    28.51523, -81.388796, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 81.3-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '834', 'I-4 @ MM 81.6-SECURITY EB', 'I-4 @ MM 81.6-SECURITY EB', 
    28.522444, -81.385942, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 81.6-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '837', 'I-4 @ MM 82.3-SECURITY WB', 'I-4 @ MM 82.3-SECURITY WB', 
    28.532392, -81.384689, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 82.3-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '838', 'I-4 @ SR-408 RP-SCCTV2 WB', 'I-4 @ SR-408 RP-SCCTV2 WB', 
    28.534976, -81.384363, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ SR-408 RP-SCCTV2 WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '839', 'I-4 @ SR-408 RP-SCCTV3 WB', 'I-4 @ SR-408 RP-SCCTV3 WB', 
    28.535086, -81.389594, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ SR-408 RP-SCCTV3 WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '840', 'I-4 @ SR-408 RP-SCCTV4 WB', 'I-4 @ SR-408 RP-SCCTV4 WB', 
    28.534257, -81.390087, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ SR-408 RP-SCCTV4 WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '841', 'I-4 @ MM 82.7-SECURITY WB', 'I-4 @ MM 82.7-SECURITY WB', 
    28.538819, -81.388821, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 82.7-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '842', 'I-4 @ MM 82.8-SECURITY WB', 'I-4 @ MM 82.8-SECURITY WB', 
    28.539114, -81.381856, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 82.8-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '843', 'I-4 @ MM 83.0-SECURITY WB', 'I-4 @ MM 83.0-SECURITY WB', 
    28.539629, -81.384809, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 83.0-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '845', 'I-4 @ MM 83.6-SCCTV EB', 'I-4 @ MM 83.6-SCCTV EB', 
    28.547584, -81.380109, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 83.6-SCCTV EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '846', 'I-4 @ MM 83.7-SECURITY WB', 'I-4 @ MM 83.7-SECURITY WB', 
    28.549073, -81.384572, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 83.7-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '847', 'I-4 @ MM 83.9-SECURITY EB', 'I-4 @ MM 83.9-SECURITY EB', 
    28.551486, -81.380324, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 83.9-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '848', 'I-4 @ MM 84.3-SECURITY WB', 'I-4 @ MM 84.3-SECURITY WB', 
    28.560476, -81.381998, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 84.3-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '851', 'I-4 @ MM 85.5-SECURITY WB', 'I-4 @ MM 85.5-SECURITY WB', 
    28.577512, -81.377105, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 85.5-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '853', 'I-4 @ MM 86.3-SECURITY WB', 'I-4 @ MM 86.3-SECURITY WB', 
    28.586688, -81.378457, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 86.3-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '854', 'I-4 @ MM 86.7-SECURITY WB', 'I-4 @ MM 86.7-SECURITY WB', 
    28.591643, -81.384036, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 86.7-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '855', 'FAIRBANKS @ I-4-SECURITY EB', 'FAIRBANKS @ I-4-SECURITY EB', 
    28.593038, -81.378414, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'FAIRBANKS @ I-4-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '856', 'I-4 @ MM 87.4-SECURITY WB', 'I-4 @ MM 87.4-SECURITY WB', 
    28.600611, -81.3888, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 87.4-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '857', 'I-4 @ MM 87.6-SECURITY EB', 'I-4 @ MM 87.6-SECURITY EB', 
    28.604078, -81.384615, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 87.6-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '858', 'I-4 @ MM 88.0-SECURITY EB', 'I-4 @ MM 88.0-SECURITY EB', 
    28.610709, -81.382727, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 88.0-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '859', 'I-4 @ MM 88.5-SECURITY WB', 'I-4 @ MM 88.5-SECURITY WB', 
    28.617904, -81.389551, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 88.5-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '860', 'I-4 @ MM 88.5-SECURITY EB', 'I-4 @ MM 88.5-SECURITY EB', 
    28.617904, -81.384379, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 88.5-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '901', 'I-4 @ MM 89.9-SCCTV M', 'I-4 @ MM 89.9-SCCTV M', 
    28.637418, -81.387466, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 89.9-SCCTV M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '908', 'I-4 @ MM 89.1-SCCTV M', 'I-4 @ MM 89.1-SCCTV M', 
    28.625475, -81.386638, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 89.1-SCCTV M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '910', 'I-4 @ MM 89.6-SECURITY M', 'I-4 @ MM 89.6-SECURITY M', 
    28.632514, -81.387668, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 89.6-SECURITY M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '923', 'I-4 @ MM 80.5-SECURITY EB', 'I-4 @ MM 80.5-SECURITY EB', 
    28.508455, -81.397133, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 80.5-SECURITY EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '932', 'I-4 @ MM 80.4-SECURITY M', 'I-4 @ MM 80.4-SECURITY M', 
    28.510125, -81.397769, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 80.4-SECURITY M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '936', 'I-4 @ MM 82.6-SECURITY EB', 'I-4 @ MM 82.6-SECURITY EB', 
    28.536444, -81.383285, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 82.6-SECURITY EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '943', 'I-4_WB_MM_84.4-SECURITY', 'I-4_WB_MM_84.4-SECURITY', 
    28.562285, -81.379938, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4_WB_MM_84.4-SECURITY', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '944', 'I-4_M_MM_84.6-SCCTV', 'I-4_M_MM_84.6-SCCTV', 
    28.564258, -81.377211, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4_M_MM_84.6-SCCTV', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '945', 'I-4 @ MM 85.8-SECURITY2 EB', 'I-4 @ MM 85.8-SECURITY2 EB', 
    28.580922, -81.372771, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 85.8-SECURITY2 EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '946', 'I-4_WB_MM_87.8-Security', 'I-4_WB_MM_87.8-Security', 
    28.606861, -81.386642, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4_WB_MM_87.8-Security', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '951', 'I-4 @ MM 82.1-SECURITY1 WB', 'I-4 @ MM 82.1-SECURITY1 WB', 
    28.526547, -81.385838, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 82.1-SECURITY1 WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '952', 'I-4 @ MM 82.9-SECURITY M', 'I-4 @ MM 82.9-SECURITY M', 
    28.540515, -81.382169, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 82.9-SECURITY M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '953', 'I-4 @ MM 82.1-SECURITY2 WB', 'I-4 @ MM 82.1-SECURITY2 WB', 
    28.52649, -81.384015, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 82.1-SECURITY2 WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '954', 'I-4 @ MM 83.1-SECURITY M', 'I-4 @ MM 83.1-SECURITY M', 
    28.5422, -81.38229, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 83.1-SECURITY M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '955', 'I-4 @ MM 87.0-SECURITY EB', 'I-4 @ MM 87.0-SECURITY EB', 
    28.59608, -81.384783, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 87.0-SECURITY EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '956', 'I-4 @ MM 89.4-SCCTV WB', 'I-4 @ MM 89.4-SCCTV WB', 
    28.629468, -81.387474, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 89.4-SCCTV WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '963', 'I-4 @ MM 79.7-Security W', 'I-4 @ MM 79.7-Security W', 
    28.509521, -81.409163, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 79.7-Security W', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '965', 'I-4 @ MM 80.9-SECURITY WB', 'I-4 @ MM 80.9-SECURITY WB', 
    28.518572, -81.394786, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 80.9-SECURITY WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '966', 'I-4 @ MM 82.7-SECURITY EB', 'I-4 @ MM 82.7-SECURITY EB', 
    28.536123, -81.38056, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 82.7-SECURITY EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '968', 'I-4 @ MM 83.3-SCCTV WB', 'I-4 @ MM 83.3-SCCTV WB', 
    28.54585, -81.382963, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 83.3-SCCTV WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '972', 'I-4 @ MM 84.1-SECURITY WB', 'I-4 @ MM 84.1-SECURITY WB', 
    28.558139, -81.382362, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 84.1-SECURITY WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '974', 'I-4_EB_MM_84.3-SECURITY', 'I-4_EB_MM_84.3-SECURITY', 
    28.559741, -81.377985, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4_EB_MM_84.3-SECURITY', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '975', 'I-4 @ MM 85.1-SCCTV2 WB', 'I-4 @ MM 85.1-SCCTV2 WB', 
    28.568768, -81.378135, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 85.1-SCCTV2 WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '976', 'I-4 @ MM 85.1-SCCTV2 EB', 'I-4 @ MM 85.1-SCCTV2 EB', 
    28.569578, -81.373693, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 85.1-SCCTV2 EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1022', 'I-4 @ MM 87.7-Lee EB', 'I-4 @ MM 87.7-Lee EB', 
    28.607619, -81.384572, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 87.7-Lee EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1048', 'I-4 @ MM 84.1-SECURITY EB', 'I-4 @ MM 84.1-SECURITY EB', 
    28.553992, -81.375753, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 84.1-SECURITY EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1125', 'I-4 @ MM 68.2 M', 'I-4 @ MM 68.2 M', 
    28.377811, -81.504344, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 68.2 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1144', 'I-4 @ MM 65.8 WB', 'I-4 @ MM 65.8 WB', 
    28.353526, -81.528811, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 65.8 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1154', 'I-4 @ MM 71.8 EB', 'I-4 @ MM 71.8 EB', 
    28.422114, -81.473789, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 71.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1162', 'I-4 @ MM 67.3 M', 'I-4 @ MM 67.3 M', 
    28.368369, -81.512831, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 67.3 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1164', 'I-4 @ MM 72.6 EB', 'I-4 @ MM 72.6 EB', 
    28.433358, -81.473981, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 72.6 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1176', 'I-4 @ MM 69 EB', 'I-4 @ MM 69 EB', 
    28.386171, -81.493599, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 69 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1188', 'I-4 @ MM 69.7 EB', 'I-4 @ MM 69.7 EB', 
    28.395345, -81.485295, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 69.7 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1194', 'I-4 @ MM 66.5 WB', 'I-4 @ MM 66.5 WB', 
    28.357028, -81.5239, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 @ MM 66.5 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1198', 'I-4 @ MM 70.9 M', 'I-4 @ MM 70.9 M', 
    28.409653, -81.475814, 
    'I-4', 'Eastbound', 'Central', 'Orange', 
    'I-4 @ MM 70.9 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1215', 'I-4 WB MM 80.6', 'I-4 WB MM 80.6', 
    28.51646, -81.401267, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'I-4 WB MM 80.6', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1220', 'Ramp Signal Verification', 'Ramp Signal Verification', 
    28.519331, -81.386983, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'Ramp Signal Verification', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1221', 'Ramp Signal Verification', 'Ramp Signal Verification', 
    28.537542, -81.383012, 
    'I-4', 'Westbound', 'Central', 'Orange', 
    'Ramp Signal Verification', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '614', 'I-4 @ MM 60.6 EB', 'I-4 @ MM 60.6 EB', 
    28.292213, -81.580975, 
    'I-4', 'Eastbound', 'Central', 'Osceola', 
    'I-4 @ MM 60.6 EB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '675', 'I-4 @ MM 62.9 WB', 'I-4 @ MM 62.9 WB', 
    28.319239, -81.559064, 
    'I-4', 'Westbound', 'Central', 'Osceola', 
    'I-4 @ MM 62.9 WB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '676', 'I-4 @ MM 63.2 M', 'I-4 @ MM 63.2 M', 
    28.322371, -81.555078, 
    'I-4', 'Eastbound', 'Central', 'Osceola', 
    'I-4 @ MM 63.2 M', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '677', 'I-4 @ MM 64.1 EB', 'I-4 @ MM 64.1 EB', 
    28.332572, -81.544669, 
    'I-4', 'Eastbound', 'Central', 'Osceola', 
    'I-4 @ MM 64.1 EB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '678', 'I-4 @ MM 64.1 WB', 'I-4 @ MM 64.1 WB', 
    28.332696, -81.548337, 
    'I-4', 'Westbound', 'Central', 'Osceola', 
    'I-4 @ MM 64.1 WB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1126', 'I-4 @ MM 59.5 WB', 'I-4 @ MM 59.5 WB', 
    28.280894, -81.594772, 
    'I-4', 'Westbound', 'Central', 'Osceola', 
    'I-4 @ MM 59.5 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1142', 'I-4 @ MM 61.7 WB', 'I-4 @ MM 61.7 WB', 
    28.307172, -81.570503, 
    'I-4', 'Westbound', 'Central', 'Osceola', 
    'I-4 @ MM 61.7 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1150', 'I-4 @ MM 59.7 WB', 'I-4 @ MM 59.7 WB', 
    28.285486, -81.592626, 
    'I-4', 'Westbound', 'Central', 'Osceola', 
    'I-4 @ MM 59.7 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1170', 'I-4 @ MM 65.3 M', 'I-4 @ MM 65.3 M', 
    28.345242, -81.533608, 
    'I-4', 'Eastbound', 'Central', 'Osceola', 
    'I-4 @ MM 65.3 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1193', 'I-4 @ MM 58.5 WB', 'I-4 @ MM 58.5 WB', 
    28.269233, -81.605747, 
    'I-4', 'Westbound', 'Central', 'Osceola', 
    'I-4 @ MM 58.5 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2548', 'I-4 W of Kathleen Rd', 'I-4 W of Kathleen Rd', 
    28.071078, -81.988549, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    'I-4 W of Kathleen Rd', '2024-12-12T16:12:05.5022807+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2685', 'I-4 at County Line Rd', 'I-4 at County Line Rd', 
    28.036148, -82.055573, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    'I-4 at County Line Rd', '2024-12-12T16:12:05.5198618+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4320', 'I-4 at Old Grade Rd / Co Rd 557', 'I-4 at Old Grade Rd / Co Rd 557', 
    28.181875, -81.743501, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    'I-4 at Old Grade Rd / Co Rd 557', '2025-02-12T17:16:08.2616596+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5002', '[not provided]', '[not provided]', 
    28.251796, -81.62435, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-06-11T14:20:03.9405757+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5003', '[not provided]', '[not provided]', 
    28.232912, -81.65037, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-06-11T14:20:03.9405757+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5004', '[not provided]', '[not provided]', 
    28.24219, -81.637458, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-06-11T14:20:03.9405757+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5075', '[not provided]', '[not provided]', 
    28.036257, -82.039151, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:17:17.2541084+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5076', '[not provided]', '[not provided]', 
    28.043579, -82.026533, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:21:04.6372664+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5077', '[not provided]', '[not provided]', 
    28.05206, -82.014295, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:23:06.3836956+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5078', '[not provided]', '[not provided]', 
    28.061053, -82.002154, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:25:06.9901815+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5079', '[not provided]', '[not provided]', 
    28.080082, -81.976597, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:27:08.7585456+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5080', '[not provided]', '[not provided]', 
    28.084974, -81.970536, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:28:09.210319+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5081', '[not provided]', '[not provided]', 
    28.094051, -81.956485, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:31:11.6136634+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5082', '[not provided]', '[not provided]', 
    28.103874, -81.94636, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:33:12.7960764+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5083', '[not provided]', '[not provided]', 
    28.110813, -81.942311, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:34:13.3758402+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5084', '[not provided]', '[not provided]', 
    28.125774, -81.925608, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:35:14.7036979+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5085', '[not provided]', '[not provided]', 
    28.140042, -81.898146, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:36:14.3546436+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5086', '[not provided]', '[not provided]', 
    28.148973, -81.865163, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:38:14.4792249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5087', '[not provided]', '[not provided]', 
    28.154399, -81.847966, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:39:16.445726+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5088', '[not provided]', '[not provided]', 
    28.154135, -81.846757, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:40:17.1484729+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5089', '[not provided]', '[not provided]', 
    28.157804, -81.832194, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:45:04.6028846+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5090', '[not provided]', '[not provided]', 
    28.156803, -81.802256, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:47:05.1941411+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5091', '[not provided]', '[not provided]', 
    28.171868, -81.767938, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:48:05.5189523+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5092', '[not provided]', '[not provided]', 
    28.185141, -81.735641, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:49:07.4367645+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5093', '[not provided]', '[not provided]', 
    28.187266, -81.73169, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:51:08.4293113+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5094', '[not provided]', '[not provided]', 
    28.188485, -81.726695, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:53:10.6455664+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5095', '[not provided]', '[not provided]', 
    28.216973, -81.670496, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:54:10.9588016+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5096', '[not provided]', '[not provided]', 
    28.227682, -81.656585, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T16:55:11.6051679+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5098', '[not provided]', '[not provided]', 
    28.157422, -81.835205, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T18:01:03.2107008+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5099', '[not provided]', '[not provided]', 
    28.185561, -81.734297, 
    'I-4', 'Westbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-11T18:01:03.2107008+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5101', '[not provided]', '[not provided]', 
    28.260616, -81.613392, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-07-15T12:36:05.1377025+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5178', '[not provided]', '[not provided]', 
    28.203061, -81.694227, 
    'I-4', 'Eastbound', 'Tampa Bay', 'Polk', 
    '[not provided]', '2025-08-20T15:54:06.7471953+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '768', 'I-4 @ MM 96.3-TPAS EB', 'I-4 @ MM 96.3-TPAS EB', 
    28.724915, -81.36217, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 96.3-TPAS EB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '865', 'I-4 @ MM 90.6-SECURITY M', 'I-4 @ MM 90.6-SECURITY M', 
    28.647037, -81.388673, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 90.6-SECURITY M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '866', 'I-4 @ MM 90.8-SECURITY M', 'I-4 @ MM 90.8-SECURITY M', 
    28.649334, -81.388757, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 90.8-SECURITY M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '868', 'I-4 @ MM 91.0-SECURITY M', 'I-4 @ MM 91.0-SECURITY M', 
    28.653373, -81.388752, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 91.0-SECURITY M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '874', 'I-4 @ MM 92.9-SECURITY WB', 'I-4 @ MM 92.9-SECURITY WB', 
    28.68061, -81.391696, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 92.9-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '875', 'I-4 @ MM 93.4-SECURITY EB', 'I-4 @ MM 93.4-SECURITY EB', 
    28.687444, -81.385924, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 93.4-SECURITY EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '876', 'I-4 @ MM 93.9-SECURITY WB', 'I-4 @ MM 93.9-SECURITY WB', 
    28.695895, -81.390967, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 93.9-SECURITY WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '879', 'I-4 @ MM 95.1-SECURITY M', 'I-4 @ MM 95.1-SECURITY M', 
    28.710875, -81.379128, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 95.1-SECURITY M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '881', 'I-4 @ MM 95.6 M', 'I-4 @ MM 95.6 M', 
    28.720775, -81.375904, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 95.6 M', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '883', 'I-4 @ MM 96.1 WB', 'I-4 @ MM 96.1 WB', 
    28.725291, -81.37629, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 96.1 WB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '884', 'I-4 @ MM 101.5 EB', 'I-4 @ MM 101.5 EB', 
    28.798586, -81.343917, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 101.5 EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '885', 'I-4 @ MM 96.3 EB', 'I-4 @ MM 96.3 EB', 
    28.725931, -81.372084, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 96.3 EB', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '904', 'I-4 @ MM 92.1-SCCTV M', 'I-4 @ MM 92.1-SCCTV M', 
    28.668809, -81.388593, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 92.1-SCCTV M', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '911', 'I-4 @ MM 91.5 M SCCTV', 'I-4 @ MM 91.5 M SCCTV', 
    28.660381, -81.38844, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 91.5 M SCCTV', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '913', 'I-4 @ MM 94.6 SCCTV EB', 'I-4 @ MM 94.6 SCCTV EB', 
    28.703574, -81.379466, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 94.6 SCCTV EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '914', 'I-4 @ MM 102 EB', 'I-4 @ MM 102 EB', 
    28.804847, -81.340833, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 102 EB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '994', 'I-4 WB MM 101.4', 'I-4 WB MM 101.4', 
    28.798653, -81.345914, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 WB MM 101.4', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1020', 'I-4 @ MM 103.7 WB', 'I-4 @ MM 103.7 WB', 
    28.82675, -81.328517, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 103.7 WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1120', 'I-4 @ MM 100.5 WB', 'I-4 @ MM 100.5 WB', 
    28.786167, -81.351381, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 100.5 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1127', 'I-4 @ MM 100 EB', 'I-4 @ MM 100 EB', 
    28.778408, -81.354097, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 100 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1135', 'I-4 @ MM 99.2 WB', 'I-4 @ MM 99.2 WB', 
    28.768097, -81.359583, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 99.2 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1141', 'I-4 @ MM 96.4 WB', 'I-4 @ MM 96.4 WB', 
    28.727772, -81.373856, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 96.4 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1145', 'I-4 @ MM 104.3 M', 'I-4 @ MM 104.3 M', 
    28.832549, -81.322259, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 104.3 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1146', 'I-4 @ MM 97.4 EB', 'I-4 @ MM 97.4 EB', 
    28.742, -81.365346, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 97.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1160', 'I-4 @ MM 102.4 M', 'I-4 @ MM 102.4 M', 
    28.8108, -81.338175, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 102.4 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1166', 'I-4 @ MM 103.2 WB', 'I-4 @ MM 103.2 WB', 
    28.821103, -81.333447, 
    'I-4', 'Westbound', 'Central', 'Seminole', 
    'I-4 @ MM 103.2 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1183', 'I-4 @ MM 100.5 EB', 'I-4 @ MM 100.5 EB', 
    28.786306, -81.349986, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 100.5 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1186', 'I-4 @ MM 98.3 EB', 'I-4 @ MM 98.3 EB', 
    28.756014, -81.363017, 
    'I-4', 'Eastbound', 'Central', 'Seminole', 
    'I-4 @ MM 98.3 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1053', 'I-4 @ MM 131.5 WB', 'I-4 @ MM 131.5 WB', 
    29.155178, -81.083972, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 131.5 WB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1129', 'I-4 @ MM 120.4 EB', 'I-4 @ MM 120.4 EB', 
    29.039568, -81.20774, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 120.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1134', 'I-4 @ MM 112.7 EB', 'I-4 @ MM 112.7 EB', 
    28.940993, -81.259732, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 112.7 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1138', 'I-4 @ MM 129.4 WB', 'I-4 @ MM 129.4 WB', 
    29.141872, -81.114292, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 129.4 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1139', 'I-4 @ MM 130.3 EB', 'I-4 @ MM 130.3 EB', 
    29.142003, -81.100687, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 130.3 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1140', 'I-4 @ MM 118.5 EB', 'I-4 @ MM 118.5 EB', 
    29.016472, -81.228768, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 118.5 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1147', 'I-4 @ MM 128.8 EB', 'I-4 @ MM 128.8 EB', 
    29.132632, -81.118562, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 128.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1149', 'I-4 @ MM 109.1 EB', 'I-4 @ MM 109.1 EB', 
    28.890054, -81.275932, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 109.1 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1153', 'I-4 @ MM 122.4 EB', 'I-4 @ MM 122.4 EB', 
    29.061815, -81.186754, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 122.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1157', 'I-4 @ MM 105.7 EB', 'I-4 @ MM 105.7 EB', 
    28.846816, -81.304707, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 105.7 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1158', 'I-4 @ MM 114.2 WB', 'I-4 @ MM 114.2 WB', 
    28.96343, -81.257607, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 114.2 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1161', 'I-4 @ MM 127.8 EB', 'I-4 @ MM 127.8 EB', 
    29.120542, -81.130707, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 127.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1165', 'I-4 @ MM 107.4 EB', 'I-4 @ MM 107.4 EB', 
    28.865891, -81.285481, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 107.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1167', 'I-4 @ MM 125.4 EB', 'I-4 @ MM 125.4 EB', 
    29.095289, -81.154997, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 125.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1168', 'I-4 @ MM 104.7 M', 'I-4 @ MM 104.7 M', 
    28.838186, -81.316569, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 104.7 M', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1169', 'I-4 @ MM 115.1 EB', 'I-4 @ MM 115.1 EB', 
    28.97338, -81.249454, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 115.1 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1171', 'I-4 @ MM 116.6 EB', 'I-4 @ MM 116.6 EB', 
    28.994102, -81.242866, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 116.6 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1173', 'I-4 @ MM 124.4 EB', 'I-4 @ MM 124.4 EB', 
    29.084095, -81.165618, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 124.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1175', 'I-4 @ MM 113.8 EB', 'I-4 @ MM 113.8 EB', 
    28.954869, -81.255376, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 113.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1177', 'I-4 @ MM 111.8 EB', 'I-4 @ MM 111.8 EB', 
    28.927828, -81.263916, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 111.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1178', 'I-4 @ MM 119.5 EB', 'I-4 @ MM 119.5 EB', 
    29.029324, -81.217331, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 119.5 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1179', 'I-4 @ MM 122.5 WB', 'I-4 @ MM 122.5 WB', 
    29.065697, -81.189587, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 122.5 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1180', 'I-4 @ MM 115.8 EB', 'I-4 @ MM 115.8 EB', 
    28.983835, -81.24617, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 115.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1181', 'I-4 @ MM 110.6 EB', 'I-4 @ MM 110.6 EB', 
    28.910887, -81.269302, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 110.6 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1182', 'I-4 @ MM 126.3 EB', 'I-4 @ MM 126.3 EB', 
    29.10547, -81.144998, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 126.3 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1184', 'I-4 @ MM 120.2 WB', 'I-4 @ MM 120.2 WB', 
    29.04075, -81.213297, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 120.2 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1185', 'I-4 @ MM 117.3 WB', 'I-4 @ MM 117.3 WB', 
    29.009153, -81.242566, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 117.3 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1187', 'I-4 @ MM 106.6 WB', 'I-4 @ MM 106.6 WB', 
    28.859727, -81.298291, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 106.6 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1190', 'I-4 @ MM 109.8 EB', 'I-4 @ MM 109.8 EB', 
    28.900105, -81.272778, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 109.8 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1191', 'I-4 @ MM 123.6 EB', 'I-4 @ MM 123.6 EB', 
    29.074099, -81.175124, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 123.6 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1192', 'I-4 @ MM 109.7 WB', 'I-4 @ MM 109.7 WB', 
    28.899391, -81.279044, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 109.7 WB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1195', 'I-4 @ MM 108.4 EB', 'I-4 @ MM 108.4 EB', 
    28.879927, -81.279108, 
    'I-4', 'Westbound', 'Central', 'Volusia', 
    'I-4 @ MM 108.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1196', 'I-4 @ MM 121.4 EB', 'I-4 @ MM 121.4 EB', 
    29.050654, -81.197333, 
    'I-4', 'Eastbound', 'Central', 'Volusia', 
    'I-4 @ MM 121.4 EB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '615', 'I-95 @ MM 183.3 SB', 'I-95 @ MM 183.3 SB', 
    28.120344, -80.708441, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 183.3 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '616', 'I-95 @ MM 185 SB', 'I-95 @ MM 185 SB', 
    28.143524, -80.708398, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 185 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '617', 'I-95 @ MM 186.2 SB', 'I-95 @ MM 186.2 SB', 
    28.162727, -80.708248, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 186.2 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '618', 'I-95 @ MM 187.3 SB', 'I-95 @ MM 187.3 SB', 
    28.179656, -80.708312, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 187.3 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '619', 'I-95 @ MM 188.5 NB', 'I-95 @ MM 188.5 NB', 
    28.197189, -80.70651, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 188.5 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '620', 'I-95 @ MM 189.9 NB', 'I-95 @ MM 189.9 NB', 
    28.216344, -80.712025, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 189.9 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '621', 'I-95 @ MM 191 SB', 'I-95 @ MM 191 SB', 
    28.229976, -80.72093, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 191 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '622', 'I-95 @ MM 192.5 SB', 'I-95 @ MM 192.5 SB', 
    28.25179, -80.727174, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 192.5 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '623', 'I-95 @ MM 193.5 SB', 'I-95 @ MM 193.5 SB', 
    28.266513, -80.731444, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 193.5 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '624', 'I-95 @ MM 194.8 NB', 'I-95 @ MM 194.8 NB', 
    28.285335, -80.732259, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 194.8 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '625', 'I-95 @ MM 195.6 NB', 'I-95 @ MM 195.6 NB', 
    28.294367, -80.741915, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 195.6 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '626', 'I-95 @ MM 196.2 SB', 'I-95 @ MM 196.2 SB', 
    28.297163, -80.75421, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 196.2 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '627', 'I-95 @ MM 196.8 SB', 'I-95 @ MM 196.8 SB', 
    28.303058, -80.759983, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 196.8 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '628', 'I-95 @ MM 197.2 SB', 'I-95 @ MM 197.2 SB', 
    28.310199, -80.764768, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 197.2 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '629', 'I-95 @ MM 198.8 NB', 'I-95 @ MM 198.8 NB', 
    28.330637, -80.772621, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 198.8 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '630', 'I-95 @ MM 199.5 NB', 'I-95 @ MM 199.5 NB', 
    28.339514, -80.778458, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 199.5 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '631', 'I-95 @ MM 201.2 SB', 'I-95 @ MM 201.2 SB', 
    28.358455, -80.796568, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 201.2 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '632', 'I-95 @ MM 202.4 SB', 'I-95 @ MM 202.4 SB', 
    28.373635, -80.806546, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 202.4 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '633', 'I-95 @ MM 203.9 SB', 'I-95 @ MM 203.9 SB', 
    28.394345, -80.818583, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 203.9 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '634', 'I-95 @ MM 203.8 NB', 'I-95 @ MM 203.8 NB', 
    28.394326, -80.813477, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 203.8 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '635', 'I-95 @ MM 204.6 SB', 'I-95 @ MM 204.6 SB', 
    28.403556, -80.82206, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 204.6 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '636', 'I-95 @ MM 205.2 SB', 'I-95 @ MM 205.2 SB', 
    28.411577, -80.822746, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 205.2 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '637', 'I-95 @ MM 205.7 NB', 'I-95 @ MM 205.7 NB', 
    28.419579, -80.817232, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 205.7 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '638', 'I-95 @ MM 206.5 SB', 'I-95 @ MM 206.5 SB', 
    28.430618, -80.822768, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 206.5 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '639', 'I-95 @ MM 208.8 SB', 'I-95 @ MM 208.8 SB', 
    28.464635, -80.823626, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 208.8 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '640', 'I-95 @ MM 210 NB', 'I-95 @ MM 210 NB', 
    28.48229, -80.820364, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 210 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '643', 'I-95 @ MM 210.5 SB', 'I-95 @ MM 210.5 SB', 
    28.48561, -80.828819, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 210.5 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '644', 'I-95 @ MM 211.7 SB', 'I-95 @ MM 211.7 SB', 
    28.500018, -80.840406, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 211.7 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '645', 'I-95 @ MM 212.9 NB', 'I-95 @ MM 212.9 NB', 
    28.516535, -80.847659, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 212.9 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '646', 'I-95 @ MM 213 SB', 'I-95 @ MM 213 SB', 
    28.516875, -80.853431, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 213 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '647', 'I-95 @ MM 214.3 SB', 'I-95 @ MM 214.3 SB', 
    28.535878, -80.854074, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 214.3 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '648', 'I-95 @ MM 215.4 SB', 'I-95 @ MM 215.4 SB', 
    28.551919, -80.85401, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 215.4 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '649', 'I-95 @ MM 216.6 SB', 'I-95 @ MM 216.6 SB', 
    28.569277, -80.853881, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 216.6 SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '650', 'I-95 @ MM 217.7 NB', 'I-95 @ MM 217.7 NB', 
    28.584728, -80.84901, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 217.7 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '651', 'I-95 @ MM 218.2 NB', 'I-95 @ MM 218.2 NB', 
    28.593151, -80.849032, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 218.2 NB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '687', 'I-95 @ MM 163.6 SB', 'I-95 @ MM 163.6 SB', 
    27.867287, -80.594179, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 163.6 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '701', 'I-95 @ MM 180.5 NB', 'I-95 @ MM 180.5 NB', 
    28.079534, -80.703763, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 180.5 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '713', 'I-95 @ MM 221.2 SB', 'I-95 @ MM 221.2 SB', 
    28.635006, -80.859546, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 221.2 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '714', 'I-95 @ MM 222.4 NB', 'I-95 @ MM 222.4 NB', 
    28.652369, -80.86152, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 222.4 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '715', 'I-95 @ MM 224.6 SB', 'I-95 @ MM 224.6 SB', 
    28.68061, -80.878193, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 224.6 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '716', 'I-95 @ MM 225.6 SB', 'I-95 @ MM 225.6 SB', 
    28.69422, -80.883858, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 225.6 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '717', 'I-95 @ MM 228.2 SB', 'I-95 @ MM 228.2 SB', 
    28.729262, -80.88978, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 228.2 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '718', 'I-95 @ MM 227.3 SB', 'I-95 @ MM 227.3 SB', 
    28.71784, -80.892934, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 227.3 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '719', 'I-95 @ MM 226.6 SB', 'I-95 @ MM 226.6 SB', 
    28.70875, -80.889801, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 226.6 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '720', 'I-95 @ MM 228.8 NB', 'I-95 @ MM 228.8 NB', 
    28.73929, -80.882635, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 228.8 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '721', 'I-95 @ MM 230.1 SB', 'I-95 @ MM 230.1 SB', 
    28.756297, -80.892183, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 230.1 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '722', 'I-95 @ MM 231.1 SB', 'I-95 @ MM 231.1 SB', 
    28.7708, -80.896239, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 231.1 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '723', 'I-95 @ MM 232.1 SB', 'I-95 @ MM 232.1 SB', 
    28.78404, -80.899994, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 232.1 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '769', 'I-95 @ MM 163.8 NB', 'I-95 @ MM 163.8 NB', 
    27.870303, -80.589265, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 163.8 NB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '770', 'I-95 @ MM 165.6 SB', 'I-95 @ MM 165.6 SB', 
    27.894826, -80.597076, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 165.6 SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '771', 'I-95 @ MM 167.3 SB', 'I-95 @ MM 167.3 SB', 
    27.919781, -80.603513, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 167.3 SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '772', 'I-95 @ MM 168.1-TPAS NB', 'I-95 @ MM 168.1-TPAS NB', 
    27.93345, -80.602118, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 168.1-TPAS NB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '773', 'I-95 @ MM 169.4-TPAS SB', 'I-95 @ MM 169.4-TPAS SB', 
    27.948634, -80.610895, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 169.4-TPAS SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '778', 'I-95 @ MM 181.3 SB', 'I-95 @ MM 181.3 SB', 
    28.091328, -80.708484, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 181.3 SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '779', 'I-95 @ MM 181.8 SB', 'I-95 @ MM 181.8 SB', 
    28.098597, -80.708463, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 181.8 SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '921', 'I-95 @ MM 208.1 SB', 'I-95 @ MM 208.1 SB', 
    28.453882, -80.823712, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 208.1 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1023', 'I-95 @ MM 224.6-TPAS NB', 'I-95 @ MM 224.6-TPAS NB', 
    28.687877, -80.876111, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 224.6-TPAS NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1024', 'I-95 @ MM 223.4 SB', 'I-95 @ MM 223.4 SB', 
    28.665116, -80.871841, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 223.4 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1027', 'I-95 @ MM 219.9 NB', 'I-95 @ MM 219.9 NB', 
    28.616661, -80.848839, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 219.9 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1028', 'I-95 @ MM 192.1 NB', 'I-95 @ MM 192.1 NB', 
    28.247121, -80.72093, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 192.1 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1029', 'I-95 @ MM 226.5-TPAS SB', 'I-95 @ MM 226.5-TPAS SB', 
    28.707884, -80.889437, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 226.5-TPAS SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1039', 'I-95 @ MM 182.3 SB', 'I-95 @ MM 182.3 SB', 
    28.107095, -80.708377, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 182.3 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1045', 'I-95 @ MM 224.6-TPAS NB', 'I-95 @ MM 224.6-TPAS NB', 
    28.687105, -80.875768, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 224.6-TPAS NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1046', 'I-95 @ MM 226.5-TPAS SB', 'I-95 @ MM 226.5-TPAS SB', 
    28.707263, -80.889093, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 226.5-TPAS SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1128', 'I-95 @ MM 162 NB', 'I-95 @ MM 162 NB', 
    27.85046, -80.577292, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 162 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1130', 'I-95 @ MM 167 SB', 'I-95 @ MM 167 SB', 
    27.916861, -80.602784, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 167 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1131', 'I-95 @ MM 170.8 SB', 'I-95 @ MM 170.8 SB', 
    27.968933, -80.616066, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 170.8 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1132', 'I-95 @ MM 165.1 NB', 'I-95 @ MM 165.1 NB', 
    27.889194, -80.590617, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 165.1 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1133', 'I-95 @ MM 173.1 SB', 'I-95 @ MM 173.1 SB', 
    27.997868, -80.632975, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 173.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1136', 'I-95 @ MM 166 NB', 'I-95 @ MM 166 NB', 
    27.903512, -80.594329, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 166 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1137', 'I-95 @ MM 163.1 SB', 'I-95 @ MM 163.1 SB', 
    27.859035, -80.591669, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 163.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1143', 'I-95 @ MM 177.4 SB', 'I-95 @ MM 177.4 SB', 
    28.047439, -80.672843, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 177.4 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1148', 'I-95 @ MM 174.1 SB', 'I-95 @ MM 174.1 SB', 
    28.011054, -80.642309, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 174.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1151', 'I-95 @ MM 176 NB', 'I-95 @ MM 176 NB', 
    28.036, -80.654261, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 176 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1155', 'I-95 @ MM 169.4 SB', 'I-95 @ MM 169.4 SB', 
    27.949734, -80.611131, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 169.4 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1156', 'I-95 @ MM 168.1 NB', 'I-95 @ MM 168.1 NB', 
    27.932654, -80.601904, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 168.1 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1159', 'I-95 @ MM 164.1 SB', 'I-95 @ MM 164.1 SB', 
    27.874362, -80.593879, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 164.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1163', 'I-95 @ MM 171.9 NB', 'I-95 @ MM 171.9 NB', 
    27.984927, -80.61789, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 171.9 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1172', 'I-95 @ MM 178.1 SB', 'I-95 @ MM 178.1 SB', 
    28.054257, -80.683765, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 178.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1174', 'I-95 @ MM 160.4 NB', 'I-95 @ MM 160.4 NB', 
    27.828905, -80.557594, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 160.4 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1189', 'I-95 @ MM 179.8 SB', 'I-95 @ MM 179.8 SB', 
    28.067758, -80.704407, 
    'I-95', 'Southbound', 'Central', 'Brevard', 
    'I-95 @ MM 179.8 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1197', 'I-95 @ MM 161 NB', 'I-95 @ MM 161 NB', 
    27.839151, -80.566885, 
    'I-95', 'Northbound', 'Central', 'Brevard', 
    'I-95 @ MM 161 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1833', 'I-95 S of Hallandale Beach', 'I-95 S of Hallandale Beach', 
    25.974948, -80.165654, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 S of Hallandale Beach', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1834', 'I-95 at Hallandale Beach', 'I-95 at Hallandale Beach', 
    25.984414, -80.165373, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 at Hallandale Beach', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1835', 'I-95 S of Sheridan St', 'I-95 S of Sheridan St', 
    26.025601, -80.166458, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 S of Sheridan St', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1836', 'I-95 at Griffin Rd', 'I-95 at Griffin Rd', 
    26.062656, -80.163513, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 at Griffin Rd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1837', 'I-95 S of SR-84', 'I-95 S of SR-84', 
    26.0859, -80.16817, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 S of SR-84', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1838', 'I-95 N of Sunrise Blvd', 'I-95 N of Sunrise Blvd', 
    26.144224, -80.170109, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 N of Sunrise Blvd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1839', 'I-95 S of Oakland Park East', 'I-95 S of Oakland Park East', 
    26.155363, -80.166351, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 S of Oakland Park East', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1840', 'I-95 N of Davie Blvd', 'I-95 N of Davie Blvd', 
    26.109505, -80.169136, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 N of Davie Blvd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1841', 'I-95 S of Sunrise Blvd', 'I-95 S of Sunrise Blvd', 
    26.133499, -80.169309, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 S of Sunrise Blvd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1936', 'I-95 S Of Commercial Blvd', 'I-95 S Of Commercial Blvd', 
    26.179827, -80.154057, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 S Of Commercial Blvd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1937', 'I-95 SB before Commercial Blvd', 'I-95 SB before Commercial Blvd', 
    26.196086, -80.151109, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB before Commercial Blvd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1938', 'I-95 SB before NW 15th Street', 'I-95 SB before NW 15th Street', 
    26.246357, -80.136855, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 SB before NW 15th Street', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1939', 'I-95 NB before NW 24th Street', 'I-95 NB before NW 24th Street', 
    26.251575, -80.136882, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 NB before NW 24th Street', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1940', 'I-95 SB after NW 24th Street', 'I-95 SB after NW 24th Street', 
    26.260938, -80.132775, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 SB after NW 24th Street', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1941', 'I-95 S of SW 10th St', 'I-95 S of SW 10th St', 
    26.29678, -80.122198, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 S of SW 10th St', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1942', 'I-95 at SW 10th St', 'I-95 at SW 10th St', 
    26.304229, -80.119991, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 at SW 10th St', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1943', 'I-95 at Hillsboro Blvd', 'I-95 at Hillsboro Blvd', 
    26.31861, -80.11658, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 at Hillsboro Blvd', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1999', 'I-95 SB before NW 36th Street', 'I-95 SB before NW 36th Street', 
    26.28269, -80.12558, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB before NW 36th Street', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2008', 'I-95 NB before Cypress Creek', 'I-95 NB before Cypress Creek', 
    26.20042, -80.14781, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB before Cypress Creek', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2009', 'I-95 NB Beyond Cypress Creek', 'I-95 NB Beyond Cypress Creek', 
    26.20557, -80.14218, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB Beyond Cypress Creek', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2010', 'I-95 SB before Cypress Creek', 'I-95 SB before Cypress Creek', 
    26.211433, -80.140457, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB before Cypress Creek', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2011', 'I-95 NB before W Atlantic Blvd', 'I-95 NB before W Atlantic Blvd', 
    26.2159, -80.137903, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB before W Atlantic Blvd', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2012', 'I-95 SB before E Cypress Rd', 'I-95 SB before E Cypress Rd', 
    26.22006, -80.13676, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB before E Cypress Rd', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2013', 'I-95 NB before W Atlantic Blvd', 'I-95 NB before W Atlantic Blvd', 
    26.22689, -80.13602, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB before W Atlantic Blvd', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2014', 'I-95 SB Ramp for W Atlantic Blvd', 'I-95 SB Ramp for W Atlantic Blvd', 
    26.23314, -80.13703, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB Ramp for W Atlantic Blvd', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2015', 'I-95 NB afer W Atlantic Blvd', 'I-95 NB afer W Atlantic Blvd', 
    26.23978, -80.13619, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB afer W Atlantic Blvd', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2016', 'I-95 NB before NW 36th Street', 'I-95 NB before NW 36th Street', 
    26.26492, -80.12884, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB before NW 36th Street', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2017', 'I-95 SB after NW 36th Street', 'I-95 SB after NW 36th Street', 
    26.27152, -80.12576, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB after NW 36th Street', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2018', 'I-95 NB before NE 48th Street', 'I-95 NB before NE 48th Street', 
    26.28942, -80.12367, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB before NE 48th Street', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2021', 'I-95 at Stirling Rd', 'I-95 at Stirling Rd', 
    26.04826, -80.16205, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 at Stirling Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2023', 'I-95 N of SR-84', 'I-95 N of SR-84', 
    26.0935, -80.16838, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 N of SR-84', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2024', 'I-95 S of Broward Blvd', 'I-95 S of Broward Blvd', 
    26.1185, -80.1665, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 S of Broward Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2025', 'I-95 at Pembroke Rd', 'I-95 at Pembroke Rd', 
    25.995612, -80.165725, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 at Pembroke Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2027', 'I-95 Just north of Marina Mile', 'I-95 Just north of Marina Mile', 
    26.089101, -80.167858, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 Just north of Marina Mile', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2028', 'I-95 Perim Rd before Davie Blvd', 'I-95 Perim Rd before Davie Blvd', 
    26.101551, -80.168353, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 Perim Rd before Davie Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2030', 'I-95 SB South of Broward Blvd', 'I-95 SB South of Broward Blvd', 
    26.119892, -80.169014, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB South of Broward Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2031', 'I-95 SB South of Broward Blvd', 'I-95 SB South of Broward Blvd', 
    26.12063, -80.168998, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB South of Broward Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2032', 'I-95SB North of Broward Blvd', 'I-95SB North of Broward Blvd', 
    26.122321, -80.169157, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95SB North of Broward Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2033', 'I 95 NB of 595 Merge', 'I 95 NB of 595 Merge', 
    26.124181, -80.168844, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I 95 NB of 595 Merge', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2036', 'I-95 NB @ Hillsboro Blvd EB Off Ramp', 'I-95 NB @ Hillsboro Blvd EB Off Ramp', 
    26.318607, -80.115921, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB @ Hillsboro Blvd EB Off Ramp', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2037', 'I-95 NB @ Hillsboro Blvd EB On Ramp', 'I-95 NB @ Hillsboro Blvd EB On Ramp', 
    26.323651, -80.116225, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB @ Hillsboro Blvd EB On Ramp', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2056', 'NB on Ramp of I-95 at Copans Rd', 'NB on Ramp of I-95 at Copans Rd', 
    26.264208, -80.129642, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'NB on Ramp of I-95 at Copans Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2057', 'NW of I-95 at Copans Rd', 'NW of I-95 at Copans Rd', 
    26.26288, -80.130693, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'NW of I-95 at Copans Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2059', 'I-95 SB Before Pembroke Rd. Off-Ramp', 'I-95 SB Before Pembroke Rd. Off-Ramp', 
    26.003947, -80.167348, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB Before Pembroke Rd. Off-Ramp', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2060', 'I-95 SB North of Griffin', 'I-95 SB North of Griffin', 
    26.065665, -80.165171, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB North of Griffin', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2061', 'I-95 NB By Dania Canal C-19', 'I-95 NB By Dania Canal C-19', 
    26.068887, -80.165384, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB By Dania Canal C-19', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2062', 'I-95 NB By SW 42nd St South of I-595', 'I-95 NB By SW 42nd St South of I-595', 
    26.070799, -80.166089, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB By SW 42nd St South of I-595', '2024-12-12T16:12:05.5001444+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2063', 'I-95 NB By SW 42nd St South of I-595', 'I-95 NB By SW 42nd St South of I-595', 
    26.071401, -80.167062, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB By SW 42nd St South of I-595', '2024-12-12T16:12:05.5001444+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2064', 'I-95 NB just N of 595 Exit Ramps', 'I-95 NB just N of 595 Exit Ramps', 
    26.079454, -80.168392, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB just N of 595 Exit Ramps', '2024-12-12T16:12:05.5001444+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2065', 'I-595 SB Off Ramp to SB I-95', 'I-595 SB Off Ramp to SB I-95', 
    26.07978, -80.169508, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-595 SB Off Ramp to SB I-95', '2024-12-12T16:12:05.5001444+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2208', 'Broward Blvd at I-95 Park & Ride', 'Broward Blvd at I-95 Park & Ride', 
    26.12086, -80.170111, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'Broward Blvd at I-95 Park & Ride', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5043', 'I-95 at Sheridan st', 'I-95 at Sheridan st', 
    26.033759, -80.163935, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 at Sheridan st', '2025-07-09T15:39:03.9411455+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5044', 'I-95 S of Davie Blvd', 'I-95 S of Davie Blvd', 
    26.1039, -80.16841, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 S of Davie Blvd', '2025-07-09T16:39:14.7560826+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5045', 'I-95 NB North of NW 6th St', 'I-95 NB North of NW 6th St', 
    26.130652, -80.168998, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB North of NW 6th St', '2025-07-09T18:37:11.1015782+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5046', 'I-95 NB North of Sunrise', 'I-95 NB North of Sunrise', 
    26.138388, -80.169057, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB North of Sunrise', '2025-07-09T18:44:15.4798664+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5047', 'I-95 NB North of NW 19th St', 'I-95 NB North of NW 19th St', 
    26.15151, -80.167197, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB North of NW 19th St', '2025-07-09T18:50:09.1182267+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5048', 'I-95 SB North of Oakland Pk Blvd', 'I-95 SB North of Oakland Pk Blvd', 
    26.171018, -80.157859, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB North of Oakland Pk Blvd', '2025-07-09T19:16:03.8717513+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5050', 'I-95 SB South of C-13 Canal', 'I-95 SB South of C-13 Canal', 
    26.158705, -80.164898, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB South of C-13 Canal', '2025-07-10T13:43:05.2909406+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5051', 'I-95 NB Commercial off Ramp', 'I-95 NB Commercial off Ramp', 
    26.186487, -80.151459, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB Commercial off Ramp', '2025-07-10T13:55:16.9350356+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5052', 'I-95 SB Commercial On Ramp', 'I-95 SB Commercial On Ramp', 
    26.185769, -80.152301, 
    'I-95', 'Southbound', 'Southeast', 'Broward', 
    'I-95 SB Commercial On Ramp', '2025-07-10T14:06:11.9832063+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5053', 'I-95 NB Commercial Blvd NB On Ramp', 'I-95 NB Commercial Blvd NB On Ramp', 
    26.189739, -80.151473, 
    'I-95', 'Northbound', 'Southeast', 'Broward', 
    'I-95 NB Commercial Blvd NB On Ramp', '2025-07-10T14:11:14.5360041+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1310', 'I-95 @ SR-9B', 'I-95 @ SR-9B', 
    30.114489, -81.513187, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ SR-9B', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1359', 'I-95 N of Emerson St SB', 'I-95 N of Emerson St SB', 
    30.295646, -81.635735, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of Emerson St SB', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1360', 'I-95 @ Acosta Collector', 'I-95 @ Acosta Collector', 
    30.31382, -81.65874, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ Acosta Collector', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1361', 'I-95 @ Atlantic/Beach Exits', 'I-95 @ Atlantic/Beach Exits', 
    30.31088, -81.64919, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ Atlantic/Beach Exits', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1363', 'I-95 S of Pecan Park Rd', 'I-95 S of Pecan Park Rd', 
    30.505831, -81.63461, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 S of Pecan Park Rd', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1364', 'I-95 @ MM 367.3', 'I-95 @ MM 367.3', 
    30.542183, -81.637505, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ MM 367.3', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1365', 'I-95 @ MM 369.3', 'I-95 @ MM 369.3', 
    30.570492, -81.644292, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ MM 369.3', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1372', 'I-95 N of Butler Blvd', 'I-95 N of Butler Blvd', 
    30.25106, -81.595995, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of Butler Blvd', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1379', 'I-95 N of Airport Rd', 'I-95 N of Airport Rd', 
    30.493139, -81.640806, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of Airport Rd', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1414', 'I-95 at Airport Rd / Max Leggett Pkwy A', 'I-95 at Airport Rd / Max Leggett Pkwy A', 
    30.481428, -81.644253, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Airport Rd / Max Leggett Pkwy A', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1466', 'I-95 San Marco Ramp', 'I-95 San Marco Ramp', 
    30.31366, -81.66372, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 San Marco Ramp', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1468', 'I-95 at I-295 / 9A South', 'I-95 at I-295 / 9A South', 
    30.166194, -81.555028, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at I-295 / 9A South', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1469', 'I-95 S of Greenland Rd', 'I-95 S of Greenland Rd', 
    30.156083, -81.549806, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 S of Greenland Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1470', 'I-95 N of Old St Augustine Rd', 'I-95 N of Old St Augustine Rd', 
    30.146694, -81.544833, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of Old St Augustine Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1471', 'I-95 at Old St Augustine Rd', 'I-95 at Old St Augustine Rd', 
    30.140861, -81.540528, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Old St Augustine Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1472', 'I-95 S of Old St Augustine Rd', 'I-95 S of Old St Augustine Rd', 
    30.130417, -81.530222, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 S of Old St Augustine Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1522', 'I-10 Collector at Forest St', 'I-10 Collector at Forest St', 
    30.324581, -81.680806, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-10 Collector at Forest St', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1523', 'I-95 at Church St SB', 'I-95 at Church St SB', 
    30.332606, -81.6736, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Church St SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1554', 'I-95 at Acosta Bridge Exit', 'I-95 at Acosta Bridge Exit', 
    30.314194, -81.658639, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Acosta Bridge Exit', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1555', 'I-95 at Atlantic Blvd', 'I-95 at Atlantic Blvd', 
    30.30729, -81.64544, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Atlantic Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1556', 'I-95 at Emerson St', 'I-95 at Emerson St', 
    30.290972, -81.629833, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Emerson St', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1557', 'I-95 N of University Blvd', 'I-95 N of University Blvd', 
    30.280639, -81.619833, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of University Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1558', 'I-95 S of Bowden Rd', 'I-95 S of Bowden Rd', 
    30.258833, -81.604472, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 S of Bowden Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1559', 'I-95 at Butler Blvd', 'I-95 at Butler Blvd', 
    30.248611, -81.593861, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Butler Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1560', 'I-95 S of Butler Blvd', 'I-95 S of Butler Blvd', 
    30.24125, -81.5855, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 S of Butler Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1561', 'I-95 N of Baymeadows Rd', 'I-95 N of Baymeadows Rd', 
    30.230944, -81.577583, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of Baymeadows Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1562', 'I-95 at Baymeadows Rd', 'I-95 at Baymeadows Rd', 
    30.22125, -81.571222, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Baymeadows Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1563', 'I-95 N of Southside Blvd', 'I-95 N of Southside Blvd', 
    30.209861, -81.563806, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of Southside Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1564', 'I-95 at US-1 / Philips Hwy', 'I-95 at US-1 / Philips Hwy', 
    30.184944, -81.557778, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at US-1 / Philips Hwy', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1565', 'I-95 N of I-295 South', 'I-95 N of I-295 South', 
    30.179667, -81.55925, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of I-295 South', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1566', 'I-95 at Harper St', 'I-95 at Harper St', 
    30.327744, -81.678792, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Harper St', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1567', 'I-95 at Church St NB', 'I-95 at Church St NB', 
    30.331786, -81.672899, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Church St NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1568', 'I-95 at 8th Street', 'I-95 at 8th Street', 
    30.347139, -81.668139, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at 8th Street', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1569', 'I-95 at MLK / 20th St', 'I-95 at MLK / 20th St', 
    30.35525, -81.668278, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at MLK / 20th St', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1570', 'I-95 at Golfair Blvd', 'I-95 at Golfair Blvd', 
    30.365167, -81.668972, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Golfair Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1571', 'I-95 N of Golfair Blvd', 'I-95 N of Golfair Blvd', 
    30.372917, -81.66925, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of Golfair Blvd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1572', 'I-95 S of Lem Turner Rd', 'I-95 S of Lem Turner Rd', 
    30.379444, -81.673722, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 S of Lem Turner Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1573', 'I-95 N of Lem Turner Rd', 'I-95 N of Lem Turner Rd', 
    30.384528, -81.670472, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of Lem Turner Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1574', 'I-95 at Edgewood Ave', 'I-95 at Edgewood Ave', 
    30.390528, -81.667583, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Edgewood Ave', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1575', 'I-95 at Trout River Bridge', 'I-95 at Trout River Bridge', 
    30.39875, -81.667361, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Trout River Bridge', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1576', 'I-95 N of Heckscher Dr', 'I-95 N of Heckscher Dr', 
    30.410389, -81.657083, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of Heckscher Dr', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1577', 'I-95 at Dunn Ave', 'I-95 at Dunn Ave', 
    30.42975, -81.656639, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Dunn Ave', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1578', 'I-95 N of Dunn Ave', 'I-95 N of Dunn Ave', 
    30.44054, -81.65459, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of Dunn Ave', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1579', 'I-95 S of I-295 North', 'I-95 S of I-295 North', 
    30.44317, -81.65454, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 S of I-295 North', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1580', 'I-95 at I-295 North', 'I-95 at I-295 North', 
    30.459167, -81.649278, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at I-295 North', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1581', 'I-95 S of Airport Rd', 'I-95 S of Airport Rd', 
    30.470333, -81.646333, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 S of Airport Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1603', 'I-95 at I-295 / 9A South', 'I-95 at I-295 / 9A South', 
    30.169389, -81.557833, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at I-295 / 9A South', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1634', 'I-95 S of Dunn Ave', 'I-95 S of Dunn Ave', 
    30.419034, -81.656699, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 S of Dunn Ave', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1635', 'I-95 @ Airport/Duval Rd B', 'I-95 @ Airport/Duval Rd B', 
    30.481502, -81.644918, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 @ Airport/Duval Rd B', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1692', 'I-95 @ Pecan Park Rd', 'I-95 @ Pecan Park Rd', 
    30.517816, -81.634757, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ Pecan Park Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1695', 'I-95 Atlantic Blvd Onramp', 'I-95 Atlantic Blvd Onramp', 
    30.30888, -81.64589, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 Atlantic Blvd Onramp', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1702', 'I-95 N of Emerson St NB', 'I-95 N of Emerson St NB', 
    30.29711, -81.636056, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of Emerson St NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1705', 'I-95 @ MM 368.3', 'I-95 @ MM 368.3', 
    30.556207, -81.64137, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 @ MM 368.3', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1712', 'I-95 @ Hendricks Ave', 'I-95 @ Hendricks Ave', 
    30.31399, -81.65533, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ Hendricks Ave', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1717', 'I-95 N of Pecan Park Rd', 'I-95 N of Pecan Park Rd', 
    30.527556, -81.636417, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 N of Pecan Park Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1748', 'I-95 at Heckscher Dr', 'I-95 at Heckscher Dr', 
    30.405896, -81.657986, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at Heckscher Dr', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1777', 'I-95 at University Blvd', 'I-95 at University Blvd', 
    30.269333, -81.612, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at University Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1785', 'I-95 at Union St', 'I-95 at Union St', 
    30.336444, -81.669194, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Union St', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1793', 'I-95 @ San Marco NB Onramp', 'I-95 @ San Marco NB Onramp', 
    30.31419, -81.664981, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 @ San Marco NB Onramp', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1800', 'I-95 at Southside Blvd Exit', 'I-95 at Southside Blvd Exit', 
    30.198917, -81.55675, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at Southside Blvd Exit', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1813', 'I-95 N of SR-9B', 'I-95 N of SR-9B', 
    30.121183, -81.520167, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 N of SR-9B', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5015', 'I-95 at 350.7 Riverside Ave - CCTV_25', 'I-95 at 350.7 Riverside Ave - CCTV_25', 
    30.316802, -81.676483, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 at 350.7 Riverside Ave - CCTV_25', '2025-06-20T17:54:07.8646193+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5016', 'I-95 at MM 350.2 at Fuller Warren CCTV_26', 'I-95 at MM 350.2 at Fuller Warren CCTV_26', 
    30.31495, -81.669874, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 at MM 350.2 at Fuller Warren CCTV_26', '2025-06-20T17:54:07.8646193+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5019', 'I-95 SB at MM 350.6 beyond Riverside - CCTV_30', 'I-95 SB at MM 350.6 beyond Riverside - CCTV_30', 
    30.316284, -81.675281, 
    'I-95', 'Southbound', 'Northeast', 'Duval', 
    'I-95 SB at MM 350.6 beyond Riverside - CCTV_30', '2025-06-20T17:54:07.8646193+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5020', 'I-95 NB Ramp T to Stockton St - CCTV_16', 'I-95 NB Ramp T to Stockton St - CCTV_16', 
    30.321248, -81.684122, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 NB Ramp T to Stockton St - CCTV_16', '2025-06-20T17:54:07.8646193+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5021', 'I-95 NB Ramp V to I-10 WB - CCTV_17', 'I-95 NB Ramp V to I-10 WB - CCTV_17', 
    30.321359, -81.683843, 
    'I-95', 'Northbound', 'Northeast', 'Duval', 
    'I-95 NB Ramp V to I-10 WB - CCTV_17', '2025-06-20T17:54:07.8646193+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '776', 'I-95 @ MM 286.0-TPAS SB', 'I-95 @ MM 286.0-TPAS SB', 
    29.513, -81.2089, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 286.0-TPAS SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '777', 'I-95 @ MM 286.0-TPAS NB', 'I-95 @ MM 286.0-TPAS NB', 
    29.513, -81.188, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 286.0-TPAS NB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '915', 'I-95 @ MM 280.2 NB', 'I-95 @ MM 280.2 NB', 
    29.430178, -81.163043, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 280.2 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '957', 'I-95 @ MM 285 NB', 'I-95 @ MM 285 NB', 
    29.494895, -81.184844, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 285 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '958', 'I-95 @ MM 288 NB', 'I-95 @ MM 288 NB', 
    29.539411, -81.203556, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 288 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '959', 'I-95 @ MM 293.0 SB', 'I-95 @ MM 293.0 SB', 
    29.598834, -81.253337, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 293.0 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1070', 'I-95 @ MM 284 SB', 'I-95 @ MM 284 SB', 
    29.47533, -81.188, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 284 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1072', 'I-95 @ MM 287.5 SB', 'I-95 @ MM 287.5 SB', 
    29.53466, -81.21193, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 287.5 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1073', 'I-95 @ MM 280.2 SB', 'I-95 @ MM 280.2 SB', 
    29.42799, -81.1702, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 280.2 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1078', 'I-95 @ MM 289 NB', 'I-95 @ MM 289 NB', 
    29.55466, -81.21433, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 289 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1079', 'I-95 @ MM 286 SB', 'I-95 @ MM 286 SB', 
    29.50866, -81.20066, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 286 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1080', 'I-95 @ MM 291 SB', 'I-95 @ MM 291 SB', 
    29.57866, -81.24, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 291 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1082', 'I-95 @ MM 281.6 NB', 'I-95 @ MM 281.6 NB', 
    29.45199, -81.1701, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 281.6 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1084', 'I-95 @ MM 293.5 SB', 'I-95 @ MM 293.5 SB', 
    29.60999, -81.25846, 
    'I-95', 'Southbound', 'Central', 'Flagler', 
    'I-95 @ MM 293.5 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1100', 'I-95 @ MM 295.5 NB', 'I-95 @ MM 295.5 NB', 
    29.64199, -81.267, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 295.5 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1262', 'I-95 @ MM 296.5', 'I-95 @ MM 296.5', 
    29.6445, -81.2721, 
    'I-95', 'Northbound', 'Central', 'Flagler', 
    'I-95 @ MM 296.5', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1872', 'I-95 MP 149.0 Southbound', 'I-95 MP 149.0 Southbound', 
    27.672326, -80.531524, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 149.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1874', 'I-95 NB CR 512 Overpass', 'I-95 NB CR 512 Overpass', 
    27.770215, -80.550127, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 NB CR 512 Overpass', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1919', 'I-95 MP 141.0 Northbound', 'I-95 MP 141.0 Northbound', 
    27.563619, -80.48473, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 141.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1920', 'I-95 MP 143.0 Northbound', 'I-95 MP 143.0 Northbound', 
    27.589116, -80.500442, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 143.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1921', 'I-95 MP 144.0 Northbound', 'I-95 MP 144.0 Northbound', 
    27.602813, -80.507587, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 144.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1922', 'I-95 MP 147.0 Northbound', 'I-95 MP 147.0 Northbound', 
    27.644179, -80.519338, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 147.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1923', 'I-95 MP 148.0 Northbound', 'I-95 MP 148.0 Northbound', 
    27.657648, -80.52434, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 148.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1924', 'I-95 MP 148.0 Southbound', 'I-95 MP 148.0 Southbound', 
    27.656992, -80.526273, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 148.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1925', 'I-95 MP 152.0 Northbound', 'I-95 MP 152.0 Northbound', 
    27.713499, -80.542859, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 152.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1926', 'I-95 MP 153.5 Southbound', 'I-95 MP 153.5 Southbound', 
    27.735732, -80.54851, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 153.5 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1927', 'I-95 MP 155.0 Southbound', 'I-95 MP 155.0 Southbound', 
    27.755909, -80.55194, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 155.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1928', 'I-95 MP 156.5 Northbound', 'I-95 MP 156.5 Northbound', 
    27.778384, -80.550143, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 156.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1929', 'I-95 MP 158.0 Southbound', 'I-95 MP 158.0 Southbound', 
    27.799491, -80.549567, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 158.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1930', 'I-95 MP 159.0 Northbound', 'I-95 MP 159.0 Northbound', 
    27.814811, -80.548261, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 159.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1931', 'I-95 MP 159.0 Southbound', 'I-95 MP 159.0 Southbound', 
    27.81363, -80.549548, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 159.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1932', 'I-95 MP 150.5 Northbound', 'I-95 MP 150.5 Northbound', 
    27.692337, -80.537063, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 150.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2002', 'I-95 MP 142.0 Northbound', 'I-95 MP 142.0 Northbound', 
    27.575518, -80.49335, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 142.0 Northbound', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2003', 'I-95 MP 146.0 Northbound', 'I-95 MP 146.0 Northbound', 
    27.629372, -80.515173, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 146.0 Northbound', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4997', 'I-95 MP 146.0 Southbound', 'I-95 MP 146.0 Southbound', 
    27.629418, -80.515977, 
    'I-95', 'Northbound', 'Southeast', 'Indian River', 
    'I-95 MP 146.0 Southbound', '2025-06-10T19:30:15.8131148+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5040', 'I-95 MP 145.0 Southbound', 'I-95 MP 145.0 Southbound', 
    27.617013, -80.515356, 
    'I-95', 'Southbound', 'Southeast', 'Indian River', 
    'I-95 MP 145.0 Southbound', '2025-07-09T14:47:15.1269819+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1878', 'I-95 MP 89.0 Northbound', 'I-95 MP 89.0 Northbound', 
    26.963216, -80.170657, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 89.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1879', 'I-95 MP 90.5 Northbound', 'I-95 MP 90.5 Northbound', 
    26.981425, -80.183632, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 90.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1880', 'I-95 MP 92.0 Northbound', 'I-95 MP 92.0 Northbound', 
    26.999399, -80.199773, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 92.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1881', 'I-95 MP 93.5 Northbound', 'I-95 MP 93.5 Northbound', 
    27.013782, -80.216164, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 93.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1882', 'I-95 MP 95.0 Southbound', 'I-95 MP 95.0 Southbound', 
    27.028827, -80.231619, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 95.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1883', 'I-95 MP 96.5 Northbound', 'I-95 MP 96.5 Northbound', 
    27.051776, -80.235055, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 96.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1884', 'I-95 MP 98.0 Northbound', 'I-95 MP 98.0 Northbound', 
    27.071636, -80.245192, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 98.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1885', 'I-95 MP 99.5 Northbound', 'I-95 MP 99.5 Northbound', 
    27.091963, -80.254205, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 99.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1886', 'I-95 MP 101.0 Northbound', 'I-95 MP 101.0 Northbound', 
    27.111539, -80.261716, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 101.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1887', 'I-95 MP 102.5 Northbound', 'I-95 MP 102.5 Northbound', 
    27.126206, -80.282545, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 102.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1888', 'I-95 MP 104.0 Northbound', 'I-95 MP 104.0 Northbound', 
    27.12747, -80.305063, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 104.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1889', 'I-95 MP 105.0 Southbound', 'I-95 MP 105.0 Southbound', 
    27.1266, -80.32134, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 105.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1890', 'I-95 MP 106.0 Northbound', 'I-95 MP 106.0 Northbound', 
    27.127407, -80.338654, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 106.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1891', 'I-95 MP 106.0 Southbound', 'I-95 MP 106.0 Southbound', 
    27.126651, -80.338845, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 106.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1892', 'I-95 MP 107.0 Southbound', 'I-95 MP 107.0 Southbound', 
    27.13099, -80.353335, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 107.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1893', 'I-95 MP 108.5 Northbound', 'I-95 MP 108.5 Northbound', 
    27.143446, -80.372421, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 108.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1894', 'I-95 MP 110.0 Northbound', 'I-95 MP 110.0 Northbound', 
    27.15959, -80.388025, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 110.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1895', 'I-95 MP 112.0 Northbound', 'I-95 MP 112.0 Northbound', 
    27.187268, -80.397996, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 112.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1896', 'I-95 MP 112.0 Southbound', 'I-95 MP 112.0 Southbound', 
    27.18705, -80.399159, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 112.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1897', 'I-95 MP 113.0 Northbound', 'I-95 MP 113.0 Northbound', 
    27.201681, -80.400192, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 113.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1933', 'I-95 MP 110.0 Southbound', 'I-95 MP 110.0 Southbound', 
    27.159032, -80.389768, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 110.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1934', 'I-95 MP 111.0 Northbound', 'I-95 MP 111.0 Northbound', 
    27.173174, -80.393972, 
    'I-95', 'Northbound', 'Southeast', 'Martin', 
    'I-95 MP 111.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5037', 'I-95 MP 111.1 Southbound', 'I-95 MP 111.1 Southbound', 
    27.172173, -80.395896, 
    'I-95', 'Southbound', 'Southeast', 'Martin', 
    'I-95 MP 111.1 Southbound', '2025-07-09T14:12:05.6588277+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '411', 'I-95 at Southwest 26th Road', 'I-95 at Southwest 26th Road', 
    25.752344, -80.206225, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Southwest 26th Road', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '412', 'I-95 at Southwest 20th Road', 'I-95 at Southwest 20th Road', 
    25.756116, -80.200836, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Southwest 20th Road', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '413', 'I-95 at Northwest 151st Street', 'I-95 at Northwest 151st Street', 
    25.912864, -80.210408, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 151st Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '414', 'I-95 at Northwest 5th Street', 'I-95 at Northwest 5th Street', 
    25.778431, -80.199486, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 5th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '415', 'I-95 at Northeast 196th Street', 'I-95 at Northeast 196th Street', 
    25.958452, -80.171246, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northeast 196th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '416', 'I-95 at Northwest 103rd Street', 'I-95 at Northwest 103rd Street', 
    25.870491, -80.208814, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 103rd Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '417', 'I-95 at Northwest 159th Street', 'I-95 at Northwest 159th Street', 
    25.920668, -80.210591, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 159th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '434', 'I-95 at Northwest 6th Street', 'I-95 at Northwest 6th Street', 
    25.779603, -80.200117, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 6th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '435', 'I-95 at Southwest 8th Street', 'I-95 at Southwest 8th Street', 
    25.766089, -80.200631, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Southwest 8th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '436', 'I-95 at Northwest 20th Street', 'I-95 at Northwest 20th Street', 
    25.795592, -80.205744, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 20th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '437', 'I-95 at Northwest 62nd Street', 'I-95 at Northwest 62nd Street', 
    25.832517, -80.206211, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 62nd Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '438', 'I-95 at Northwest 75th Street', 'I-95 at Northwest 75th Street', 
    25.843589, -80.206925, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 75th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '439', 'I-95 at Northwest 125th Street', 'I-95 at Northwest 125th Street', 
    25.888917, -80.209592, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 125th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '440', 'I-95 at US-441', 'I-95 at US-441', 
    25.92204, -80.21288, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at US-441', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '441', 'I-95 at Northwest 168th Street', 'I-95 at Northwest 168th Street', 
    25.92927, -80.2064, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 168th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '442', 'I-95 at Miami Gardens Drive', 'I-95 at Miami Gardens Drive', 
    25.943294, -80.188254, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Miami Gardens Drive', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '443', 'I-95 at Ives Dairy Road', 'I-95 at Ives Dairy Road', 
    25.963476, -80.164973, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Ives Dairy Road', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '444', 'I-95 at Northwest 119th Street', 'I-95 at Northwest 119th Street', 
    25.883406, -80.209328, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 119th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '445', 'I-95 at Northwest 103rd Street', 'I-95 at Northwest 103rd Street', 
    25.868944, -80.208778, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 103rd Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '446', 'I-95 at Northwest 95th Street', 'I-95 at Northwest 95th Street', 
    25.861525, -80.208556, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 95th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '447', 'I-95 at Northeast 2nd Avenue', 'I-95 at Northeast 2nd Avenue', 
    25.937086, -80.198098, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northeast 2nd Avenue', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '448', 'I-95 at SR-112', 'I-95 at SR-112', 
    25.811999, -80.205754, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at SR-112', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '449', 'I-95 at Northwest 29th Street', 'I-95 at Northwest 29th Street', 
    25.803467, -80.206114, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 29th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '450', 'I-95 at Northwest 13th Street', 'I-95 at Northwest 13th Street', 
    25.78645, -80.203156, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 13th Street', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '451', 'I-95 at Opa Locka Boulevard', 'I-95 at Opa Locka Boulevard', 
    25.897914, -80.210022, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Opa Locka Boulevard', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '471', 'I-95SB Right Shoulder at NW 145th St', 'I-95SB Right Shoulder at NW 145th St', 
    25.907811, -80.210357, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95SB Right Shoulder at NW 145th St', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '472', 'I-95 SB NW 119th St', 'I-95 SB NW 119th St', 
    25.883953, -80.209411, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 119th St', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '473', 'I-95 at Northwest 168th Street', 'I-95 at Northwest 168th Street', 
    25.930672, -80.205001, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 168th Street', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '474', 'I-95 at SR-112', 'I-95 at SR-112', 
    25.81585, -80.206438, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at SR-112', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '475', 'I-95 at US-441', 'I-95 at US-441', 
    25.92304, -80.21309, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at US-441', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '476', 'I-95SB Right Shoulder MM 14.17', 'I-95SB Right Shoulder MM 14.17', 
    25.939406, -80.192624, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95SB Right Shoulder MM 14.17', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '479', 'I-95 NB @ NW 69TH ST', 'I-95 NB @ NW 69TH ST', 
    25.8377, -80.2058, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB @ NW 69TH ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '480', 'I-95 NB just South of 95TH ST', 'I-95 NB just South of 95TH ST', 
    25.8579, -80.2078, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB just South of 95TH ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '481', 'I-95 SB Befor NW 95TH ST OFF Ramp', 'I-95 SB Befor NW 95TH ST OFF Ramp', 
    25.865, -80.2087, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB Befor NW 95TH ST OFF Ramp', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '482', 'I-95 NB just south of NW 123RD ST', 'I-95 NB just south of NW 123RD ST', 
    25.8863, -80.2088, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB just south of NW 123RD ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '483', 'I-95 SB Before NW 125TH ST', 'I-95 SB Before NW 125TH ST', 
    25.8915, -80.2098, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB Before NW 125TH ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '484', 'NW 69TH ST NB On Ramp', 'NW 69TH ST NB On Ramp', 
    25.838754, -80.201482, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'NW 69TH ST NB On Ramp', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '485', 'I-95 NB NW before 81st ST', 'I-95 NB NW before 81st ST', 
    25.848426, -80.207281, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB NW before 81st ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '486', 'I-95 NB Right Shoulder', 'I-95 NB Right Shoulder', 
    25.861536, -80.207267, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB Right Shoulder', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '487', 'I-95 NB Off Ramp Shoulder', 'I-95 NB Off Ramp Shoulder', 
    25.867642, -80.204315, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB Off Ramp Shoulder', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '488', 'I-95 NB NW 125th St', 'I-95 NB NW 125th St', 
    25.885944, -80.202856, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB NW 125th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '489', 'I-95 NB NW 135th St', 'I-95 NB NW 135th St', 
    25.899372, -80.209465, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB NW 135th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '490', 'I-95 SB NW 62nd St', 'I-95 SB NW 62nd St', 
    25.832045, -80.206177, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 62nd St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '491', 'I-95 SB NW 79th St', 'I-95 SB NW 79th St', 
    25.846295, -80.207987, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 79th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '492', 'I-95 SB NW 95th St', 'I-95 SB NW 95th St', 
    25.862446, -80.208827, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 95th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '493', 'I-95 SB NW 125th St', 'I-95 SB NW 125th St', 
    25.889576, -80.209701, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 125th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '494', 'I-95 SB NW 135th St', 'I-95 SB NW 135th St', 
    25.898663, -80.210229, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 135th St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '495', 'I-95 SB NW 151st St', 'I-95 SB NW 151st St', 
    25.913417, -80.210797, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB NW 151st St', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '496', 'I-95 NB AT NW 62 ST', 'I-95 NB AT NW 62 ST', 
    25.83317, -80.20192, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB AT NW 62 ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '497', 'I-95 AT NW 81 ST', 'I-95 AT NW 81 ST', 
    25.85096, -80.20308, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 AT NW 81 ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '498', 'I-95 AT NW 95 ST', 'I-95 AT NW 95 ST', 
    25.86363, -80.20358, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 AT NW 95 ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '499', 'I-95 AT NW 103 ST', 'I-95 AT NW 103 ST', 
    25.87225, -80.20416, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 AT NW 103 ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '500', 'I-95 NB AT NW 125 ST', 'I-95 NB AT NW 125 ST', 
    25.888955, -80.2038, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 NB AT NW 125 ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '501', 'I-95 AT NW 135 ST', 'I-95 AT NW 135 ST', 
    25.895326, -80.204916, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 AT NW 135 ST', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '502', 'I-95 AT NE 2 AVE', 'I-95 AT NE 2 AVE', 
    25.92175, -80.19883, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 AT NE 2 AVE', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '503', 'RMS 11 - I-95 SB AT IVES DAIRY', 'RMS 11 - I-95 SB AT IVES DAIRY', 
    25.964565, -80.170733, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'RMS 11 - I-95 SB AT IVES DAIRY', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '504', 'RMS 13 - I-95 SB AT US 441 SB', 'RMS 13 - I-95 SB AT US 441 SB', 
    25.93465, -80.20569, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'RMS 13 - I-95 SB AT US 441 SB', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '505', 'RMS 14 - I-95 SB AT SR-826', 'RMS 14 - I-95 SB AT SR-826', 
    25.926824, -80.21161, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'RMS 14 - I-95 SB AT SR-826', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '567', 'I-95 at Northwest 79th Street', 'I-95 at Northwest 79th Street', 
    25.847042, -80.208064, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 79th Street', '2024-12-12T16:12:05.4265895+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '598', 'I-95 at Northwest 17th Street', 'I-95 at Northwest 17th Street', 
    25.792658, -80.2053, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 17th Street', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '600', 'I-95 SB off Ramp to Miami Gardens', 'I-95 SB off Ramp to Miami Gardens', 
    25.945366, -80.191107, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB off Ramp to Miami Gardens', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '602', 'I-95 SB Befor NW 125TH ST', 'I-95 SB Befor NW 125TH ST', 
    25.892008, -80.209161, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 SB Befor NW 125TH ST', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '603', 'I-95 at Northeast 215th Street', 'I-95 at Northeast 215th Street', 
    25.973198, -80.165402, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northeast 215th Street', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '605', 'I-95 at Northwest 54th Street', 'I-95 at Northwest 54th Street', 
    25.825292, -80.206953, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 54th Street', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '607', 'I-95 at Northwest 35th Street', 'I-95 at Northwest 35th Street', 
    25.808522, -80.208128, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'I-95 at Northwest 35th Street', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '613', 'I-95 at MM 12.65', 'I-95 at MM 12.65', 
    25.928016, -80.211419, 
    'I-95', 'Northbound', 'Southeast', 'Miami-Dade', 
    'I-95 at MM 12.65', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '4331', 'SB I-95 North of Ives Diary Rd', 'SB I-95 North of Ives Diary Rd', 
    25.972086, -80.165904, 
    'I-95', 'Southbound', 'Southeast', 'Miami-Dade', 
    'SB I-95 North of Ives Diary Rd', '2025-03-11T19:49:04.3576723+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1366', 'I-95 @ MM 371.2', 'I-95 @ MM 371.2', 
    30.59759, -81.644584, 
    'I-95', 'Northbound', 'Northeast', 'Nassau', 
    'I-95 @ MM 371.2', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1367', 'I-95 @ SR-200 / A1A', 'I-95 @ SR-200 / A1A', 
    30.618979, -81.650183, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 @ SR-200 / A1A', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1368', 'I-95 N of SR-200', 'I-95 N of SR-200', 
    30.633438, -81.654574, 
    'I-95', 'Northbound', 'Northeast', 'Nassau', 
    'I-95 N of SR-200', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1369', 'I-95 @ MM 375.7', 'I-95 @ MM 375.7', 
    30.660395, -81.663998, 
    'I-95', 'Northbound', 'Northeast', 'Nassau', 
    'I-95 @ MM 375.7', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1370', 'I-95 @ MM 377.6', 'I-95 @ MM 377.6', 
    30.687583, -81.674304, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 @ MM 377.6', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1371', 'I-95 @ US-17', 'I-95 @ US-17', 
    30.711671, -81.671334, 
    'I-95', 'Northbound', 'Northeast', 'Nassau', 
    'I-95 @ US-17', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1696', 'I-95 @ MM 376.7 Weigh Station', 'I-95 @ MM 376.7 Weigh Station', 
    30.673691, -81.669561, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 @ MM 376.7 Weigh Station', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1697', 'I-95 @ SR-200 MH', 'I-95 @ SR-200 MH', 
    30.620001, -81.649489, 
    'I-95', 'Northbound', 'Northeast', 'Nassau', 
    'I-95 @ SR-200 MH', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1699', 'I-95 N of US-17', 'I-95 N of US-17', 
    30.725996, -81.663432, 
    'I-95', 'Northbound', 'Northeast', 'Nassau', 
    'I-95 N of US-17', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1700', 'I-95 @ MM 374.7', 'I-95 @ MM 374.7', 
    30.647046, -81.660009, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 @ MM 374.7', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1706', 'I-95 @ MM 370.3', 'I-95 @ MM 370.3', 
    30.584883, -81.647164, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 @ MM 370.3', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1707', 'I-95 S of SR-200 / A1A', 'I-95 S of SR-200 / A1A', 
    30.608553, -81.646483, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 S of SR-200 / A1A', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1709', 'I-95 S of US-17', 'I-95 S of US-17', 
    30.699948, -81.677073, 
    'I-95', 'Southbound', 'Northeast', 'Nassau', 
    'I-95 S of US-17', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1944', 'I-95 at Linton', 'I-95 at Linton', 
    26.438803, -80.088474, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Linton', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1945', 'I-95 at Atlantic Ave.', 'I-95 at Atlantic Ave.', 
    26.462006, -80.088005, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Atlantic Ave.', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1946', 'I-95 N of Atlantic Ave.', 'I-95 N of Atlantic Ave.', 
    26.475867, -80.087798, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Atlantic Ave.', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1947', 'I-95 N of Linton', 'I-95 N of Linton', 
    26.450003, -80.090038, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Linton', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1948', 'I-95 S of Woolbright', 'I-95 S of Woolbright', 
    26.501722, -80.0785, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Woolbright', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1949', 'I-95 at Woolbright', 'I-95 at Woolbright', 
    26.515265, -80.071946, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Woolbright', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1950', 'I-95 S of Boynton', 'I-95 S of Boynton', 
    26.525722, -80.072469, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Boynton', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1951', 'I-95 N of Boynton', 'I-95 N of Boynton', 
    26.538532, -80.072771, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Boynton', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1952', 'I-95 N of Gateway', 'I-95 N of Gateway', 
    26.556846, -80.069539, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Gateway', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1953', 'I-95 S of Hypoluxo', 'I-95 S of Hypoluxo', 
    26.570063, -80.069064, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Hypoluxo', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1954', 'I-95 N of Lantana', 'I-95 N of Lantana', 
    26.59912, -80.068727, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Lantana', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1955', 'I-95 N of 6th Ave', 'I-95 N of 6th Ave', 
    26.614532, -80.068972, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 N of 6th Ave', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1956', 'I-95 at 10th Ave', 'I-95 at 10th Ave', 
    26.62714, -80.06711, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at 10th Ave', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1957', 'I-95 N of 10th Ave', 'I-95 N of 10th Ave', 
    26.640869, -80.068618, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of 10th Ave', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1958', 'I-95 at Forest Hill', 'I-95 at Forest Hill', 
    26.655762, -80.070031, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 at Forest Hill', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1959', 'I-95 S of Southern', 'I-95 S of Southern', 
    26.665983, -80.070762, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Southern', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1960', 'I-95 N of Southern', 'I-95 N of Southern', 
    26.678847, -80.070075, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Southern', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1961', 'I-95 at Belvedere', 'I-95 at Belvedere', 
    26.691095, -80.066476, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Belvedere', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1962', 'I-95 N of Okeechobee', 'I-95 N of Okeechobee', 
    26.707385, -80.076202, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Okeechobee', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1963', 'I-95 at PB Lakes', 'I-95 at PB Lakes', 
    26.718314, -80.089569, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 at PB Lakes', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1964', 'I-95 N of PB Lakes', 'I-95 N of PB Lakes', 
    26.728686, -80.090906, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of PB Lakes', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1965', 'I-95 S of 45th St.', 'I-95 S of 45th St.', 
    26.743193, -80.090174, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of 45th St.', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1966', 'I-95 at 45th St.', 'I-95 at 45th St.', 
    26.758139, -80.090471, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at 45th St.', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1967', 'I-95 S of Northlake', 'I-95 S of Northlake', 
    26.796, -80.098381, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Northlake', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1968', 'I-95 at Blue Heron', 'I-95 at Blue Heron', 
    26.782453, -80.098786, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Blue Heron', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1969', 'I-95 at Northlake Blvd', 'I-95 at Northlake Blvd', 
    26.80949, -80.097761, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Northlake Blvd', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1970', 'I-95 S of PGA', 'I-95 S of PGA', 
    26.82298, -80.097248, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of PGA', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1971', 'I-95 at PGA', 'I-95 at PGA', 
    26.838652, -80.100543, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at PGA', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1972', 'I-95 S of Blue Heron', 'I-95 S of Blue Heron', 
    26.770688, -80.095407, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Blue Heron', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1973', 'I-95 N of PGA Blvd', 'I-95 N of PGA Blvd', 
    26.849381, -80.107783, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of PGA Blvd', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1974', 'I-95 S of  Donald R', 'I-95 S of  Donald R', 
    26.86397, -80.116865, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of  Donald R', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1975', 'I-95 N of Donald R', 'I-95 N of Donald R', 
    26.889194, -80.131488, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Donald R', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1976', 'I-95 MP 85.1 Northbound', 'I-95 MP 85.1 Northbound', 
    26.901794, -80.137786, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 MP 85.1 Northbound', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1977', 'I-95 S of Indiantown', 'I-95 S of Indiantown', 
    26.917614, -80.144817, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Indiantown', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1978', 'I-95 N of Indiantown Rd', 'I-95 N of Indiantown Rd', 
    26.943683, -80.15367, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 N of Indiantown Rd', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1979', 'I-95 at Indiantown Rd', 'I-95 at Indiantown Rd', 
    26.933952, -80.149818, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Indiantown Rd', '2024-12-12T16:12:05.3988357+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2020', 'I-95 at Yamato', 'I-95 at Yamato', 
    26.394819, -80.092276, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 at Yamato', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2035', 'I-95 NB at MM 63.7', 'I-95 NB at MM 63.7', 
    26.618804, -80.067731, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB at MM 63.7', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2038', 'I-95 NB 1400ft N of SW 18th St', 'I-95 NB 1400ft N of SW 18th St', 
    26.335609, -80.117116, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB 1400ft N of SW 18th St', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2039', 'I-95 N at Palmetto', 'I-95 N at Palmetto', 
    26.350119, -80.118308, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 N at Palmetto', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2040', 'I-95 NB S of Glade Rd', 'I-95 NB S of Glade Rd', 
    26.363207, -80.11975, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB S of Glade Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2041', 'I-95 SB N of Glade Rd', 'I-95 SB N of Glade Rd', 
    26.37068, -80.11805, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB N of Glade Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2042', 'I-95 NB S of Glade Rd', 'I-95 NB S of Glade Rd', 
    26.36702, -80.11851, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB S of Glade Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2043', 'I-95 NB N of Glade Rd', 'I-95 NB N of Glade Rd', 
    26.37708, -80.11439, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB N of Glade Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2044', 'I-95 SB S of Spanish River Blvd', 'I-95 SB S of Spanish River Blvd', 
    26.38267, -80.10965, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB S of Spanish River Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2045', 'I-95 NB S of Spanish River Blvd', 'I-95 NB S of Spanish River Blvd', 
    26.3848, -80.10631, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB S of Spanish River Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2046', 'I-95 NB N of Spanish River Blvd', 'I-95 NB N of Spanish River Blvd', 
    26.38734, -80.10344, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB N of Spanish River Blvd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2047', 'I-95 SB @ Palmetto Park Rd WB On Ramp', 'I-95 SB @ Palmetto Park Rd WB On Ramp', 
    26.352287, -80.11893, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB @ Palmetto Park Rd WB On Ramp', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2048', 'Yamato Rd WB E of I95', 'Yamato Rd WB E of I95', 
    26.39471, -80.09244, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'Yamato Rd WB E of I95', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2049', 'I-95 SB S of Clint Moore Rd', 'I-95 SB S of Clint Moore Rd', 
    26.40192, -80.09031, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB S of Clint Moore Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2050', 'I-95 NB N of Clint Moore Rd', 'I-95 NB N of Clint Moore Rd', 
    26.4086, -80.08965, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB N of Clint Moore Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2051', 'I-95 SB S of Peninsula Corp Dr', 'I-95 SB S of Peninsula Corp Dr', 
    26.41443, -80.09035, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB S of Peninsula Corp Dr', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2052', 'I-95 NB N of Peninsula Corp Dr', 'I-95 NB N of Peninsula Corp Dr', 
    26.42101, -80.08958, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB N of Peninsula Corp Dr', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2053', 'I-95 SB N of Peninsula Corp Dr', 'I-95 SB N of Peninsula Corp Dr', 
    26.42695, -80.09056, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB N of Peninsula Corp Dr', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2054', 'I-95 N  of Palmetto Park Rd', 'I-95 N  of Palmetto Park Rd', 
    26.356375, -80.119446, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 N  of Palmetto Park Rd', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2055', 'I-95 SB N of camino Real', 'I-95 SB N of camino Real', 
    26.345988, -80.118521, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB N of camino Real', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2058', 'I-95 S of Lantana', 'I-95 S of Lantana', 
    26.37068, -80.11805, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 S of Lantana', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5054', 'I-95 NB S of Yamato Rd', 'I-95 NB S of Yamato Rd', 
    26.39047, -80.0985, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB S of Yamato Rd', '2025-07-10T14:17:17.0577454+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5055', 'I-95 SB S of Peninsula Corp Dr', 'I-95 SB S of Peninsula Corp Dr', 
    26.41407, -80.09034, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 SB S of Peninsula Corp Dr', '2025-07-10T14:22:05.2848117+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5056', 'I-95 NB S of Linton Blvd', 'I-95 NB S of Linton Blvd', 
    26.43409, -80.08916, 
    'I-95', 'Northbound', 'Southeast', 'Palm Beach', 
    'I-95 NB S of Linton Blvd', '2025-07-10T14:51:12.8476167+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5074', 'I-95 MP 047.0 Southbound', 'I-95 MP 047.0 Southbound', 
    26.3883, -80.103611, 
    'I-95', 'Southbound', 'Southeast', 'Palm Beach', 
    'I-95 MP 047.0 Southbound', '2025-07-10T18:20:22.6143644+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1101', 'I-95 @ MM 298.9 SB', 'I-95 @ MM 298.9 SB', 
    29.660143, -81.29097, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 298.9 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1243', 'I-95 @ St Johns Cty Rest Area', 'I-95 @ St Johns Cty Rest Area', 
    30.0922, -81.4975, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ St Johns Cty Rest Area', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1244', 'I-95 @ MM 328.1', 'I-95 @ MM 328.1', 
    30.0503, -81.4975, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 328.1', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1245', 'I-95 @ MM 326.7', 'I-95 @ MM 326.7', 
    30.0311, -81.4893, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 326.7', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1246', 'I-95 @ MM 325.2', 'I-95 @ MM 325.2', 
    30.0113, -81.4773, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 325.2', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1247', 'I-95 @ MM 324.4', 'I-95 @ MM 324.4', 
    30.0012, -81.4705, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 324.4', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1248', 'I-95 @ MM 321.7', 'I-95 @ MM 321.7', 
    29.9665, -81.4497, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 321.7', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1249', 'I-95 @ MM 320.3', 'I-95 @ MM 320.3', 
    29.9494, -81.4386, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 320.3', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1250', 'I-95 @ MM 318.3', 'I-95 @ MM 318.3', 
    29.9272, -81.4174, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 318.3', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1251', 'I-95 @ MM 316.0', 'I-95 @ MM 316.0', 
    29.8951, -81.4055, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 316.0', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1252', 'I-95 @ MM 314.1', 'I-95 @ MM 314.1', 
    29.8689, -81.3976, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 314.1', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1253', 'I-95 @ MM 312.4', 'I-95 @ MM 312.4', 
    29.8454, -81.3893, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 312.4', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1254', 'I-95 @ MM 310.1', 'I-95 @ MM 310.1', 
    29.8148, -81.3736, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 310.1', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1255', 'I-95 @ MM 308.9', 'I-95 @ MM 308.9', 
    29.7975, -81.3667, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 308.9', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1256', 'I-95 @ MM 306.9', 'I-95 @ MM 306.9', 
    29.7701, -81.3558, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 306.9', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1257', 'I-95 @ MM 305.9', 'I-95 @ MM 305.9', 
    29.7564, -81.3503, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 305.9', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1258', 'I-95 @ MM 303.5', 'I-95 @ MM 303.5', 
    29.7246, -81.3369, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 303.5', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1259', 'I-95 @ MM 301.6', 'I-95 @ MM 301.6', 
    29.6979, -81.3268, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 301.6', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1260', 'I-95 @ MM 300.3', 'I-95 @ MM 300.3', 
    29.6804, -81.3185, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 300.3', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1261', 'I-95 @ MM 298.5', 'I-95 @ MM 298.5', 
    29.6657, -81.2939, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 298.5', '2024-12-12T16:12:05.3752272+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1473', 'I-95 at Race Track Rd', 'I-95 at Race Track Rd', 
    30.103917, -81.503194, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 at Race Track Rd', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1474', 'I-95 at St Johns County Rest Area', 'I-95 at St Johns County Rest Area', 
    30.086139, -81.497667, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 at St Johns County Rest Area', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1726', 'I-95 @ SR-206', 'I-95 @ SR-206', 
    29.7482, -81.3467, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ SR-206', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1729', 'I-95 @ MM 307.8', 'I-95 @ MM 307.8', 
    29.7837, -81.3612, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 307.8', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1735', 'I-95 @ International Golf Pkwy', 'I-95 @ International Golf Pkwy', 
    29.9869, -81.4626, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ International Golf Pkwy', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1738', 'I-95 @ CR-210', 'I-95 @ CR-210', 
    30.0654, -81.4982, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ CR-210', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1740', 'I-95 @ MM 322.3', 'I-95 @ MM 322.3', 
    29.9743, -81.455, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 322.3', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1742', 'I-95 @ MM 302.5', 'I-95 @ MM 302.5', 
    29.7107, -81.3319, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 302.5', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1747', 'I-95 @ MM 297.4', 'I-95 @ MM 297.4', 
    29.6569, -81.2793, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 297.4', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1749', 'I-95 @ MM 327.6', 'I-95 @ MM 327.6', 
    30.0425, -81.4962, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 327.6', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1752', 'I-95 @ MM 317.0', 'I-95 @ MM 317.0', 
    29.91, -81.41, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 317.0', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1756', 'I-95 @ MM 320.8', 'I-95 @ MM 320.8', 
    29.9549, -81.4432, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 320.8', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1759', 'I-95 @ SR-16', 'I-95 @ SR-16', 
    29.9172, -81.4122, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ SR-16', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1762', 'I-95 @ MM 300.6', 'I-95 @ MM 300.6', 
    29.6842, -81.3204, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 300.6', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1765', 'I-95 @ MM 315.1', 'I-95 @ MM 315.1', 
    29.8825, -81.4017, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 315.1', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1772', 'I-95 @ MM 324.8', 'I-95 @ MM 324.8', 
    30.0064, -81.4744, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 324.8', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1778', 'I-95 @ MM 325.7', 'I-95 @ MM 325.7', 
    30.0185, -81.4817, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 325.7', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1780', 'I-95 @ MM 330.1', 'I-95 @ MM 330.1', 
    30.0786, -81.4988, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 330.1', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1781', 'I-95 @ MM 304.4', 'I-95 @ MM 304.4', 
    29.7361, -81.3421, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 304.4', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1782', 'I-95 @ MM 299.9', 'I-95 @ MM 299.9', 
    29.676438, -81.312861, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 299.9', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1786', 'I-95 @ MM 309.3', 'I-95 @ MM 309.3', 
    29.8044, -81.3689, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 309.3', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1787', 'I-95 @ MM 306.4', 'I-95 @ MM 306.4', 
    29.7643, -81.3534, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 306.4', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1790', 'I-95 @ MM 311.9', 'I-95 @ MM 311.9', 
    29.8383, -81.3858, 
    'I-95', 'Southbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 311.9', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1791', 'I-95 @ MM 313.3', 'I-95 @ MM 313.3', 
    29.8572, -81.394, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 313.3', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1803', 'I-95 @ SR-207', 'I-95 @ SR-207', 
    29.8252, -81.379, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ SR-207', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1806', 'I-95 @ MM 319.3', 'I-95 @ MM 319.3', 
    29.9385, -81.4285, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ MM 319.3', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1811', 'I-95 @ US-1 South', 'I-95 @ US-1 South', 
    29.6622, -81.2872, 
    'I-95', 'Northbound', 'Northeast', 'St. Johns', 
    'I-95 @ US-1 South', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1898', 'I-95 MP 114.5 Northbound', 'I-95 MP 114.5 Northbound', 
    27.22339, -80.400289, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 114.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1899', 'I-95 MP 114.5 Southbound', 'I-95 MP 114.5 Southbound', 
    27.223635, -80.401736, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 114.5 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1900', 'I-95 MP 116.0 Southbound', 'I-95 MP 116.0 Southbound', 
    27.241035, -80.41298, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 116.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1901', 'I-95 MP 119.0 Southbound', 'I-95 MP 119.0 Southbound', 
    27.282791, -80.425537, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 119.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1902', 'I-95 MP 120.0 Northbound', 'I-95 MP 120.0 Northbound', 
    27.295939, -80.416396, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 120.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1903', 'I-95 MP 121.0 Northbound', 'I-95 MP 121.0 Northbound', 
    27.309857, -80.413628, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 121.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1904', 'I-95 MP 122.0 Southbound', 'I-95 MP 122.0 Southbound', 
    27.324487, -80.414629, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 122.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1905', 'I-95 MP 123.5 Northbound', 'I-95 MP 123.5 Northbound', 
    27.346544, -80.413787, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 123.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1906', 'I-95 MP 125.0 Northbound', 'I-95 MP 125.0 Northbound', 
    27.365376, -80.412936, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 125.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1907', 'I-95 MP 126.5 Southbound', 'I-95 MP 126.5 Southbound', 
    27.387676, -80.402944, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 126.5 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1908', 'I-95 MP 127.5 Northbound', 'I-95 MP 127.5 Northbound', 
    27.398291, -80.391132, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 127.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1909', 'I-95 MP 128.0 Northbound', 'I-95 MP 128.0 Northbound', 
    27.405753, -80.388051, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 128.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1910', 'I-95 MP 131.0 Northbound', 'I-95 MP 131.0 Northbound', 
    27.450076, -80.394838, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 131.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1911', 'I-95 MP 132.0 Northbound', 'I-95 MP 132.0 Northbound', 
    27.458152, -80.404611, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 132.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1912', 'I-95 MP 133.0 Northbound', 'I-95 MP 133.0 Northbound', 
    27.465297, -80.418754, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 133.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1913', 'I-95 MP 133.0 Southbound', 'I-95 MP 133.0 Southbound', 
    27.46499, -80.419099, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 133.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1914', 'I-95 MP 134.0 Northbound', 'I-95 MP 134.0 Northbound', 
    27.47545, -80.430781, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 134.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1915', 'I-95 MP 134.0 Southbound', 'I-95 MP 134.0 Southbound', 
    27.475048, -80.431534, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 134.0 Southbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1916', 'I-95 MP 137.0 Northbound', 'I-95 MP 137.0 Northbound', 
    27.515832, -80.447588, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 137.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1917', 'I-95 MP 138.5 Northbound', 'I-95 MP 138.5 Northbound', 
    27.534614, -80.460824, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 138.5 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1918', 'I-95 MP 140.0 Northbound', 'I-95 MP 140.0 Northbound', 
    27.551708, -80.474919, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 140.0 Northbound', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2000', 'I-95 MP 125.0 Southbound', 'I-95 MP 125.0 Southbound', 
    27.365547, -80.414218, 
    'I-95', 'Southbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 125.0 Southbound', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2001', 'I-95 MP 129.0 Northbound', 'I-95 MP 129.0 Northbound', 
    27.418435, -80.388046, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 129.0 Northbound', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '2022', 'I-95 MP 135.5 Northbound', 'I-95 MP 135.5 Northbound', 
    27.495911, -80.439394, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 135.5 Northbound', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5038', 'I-95 MP 116.0 Northbound', 'I-95 MP 116.0 Northbound', 
    27.242358, -80.412308, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 116.0 Northbound', '2025-07-09T14:18:09.5230948+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5039', 'I-95 MP 130.0 Northbound', 'I-95 MP 130.0 Northbound', 
    27.434481, -80.388349, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 130.0 Northbound', '2025-07-09T14:45:13.3116746+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '5057', 'I-95 MP 117.5 Northbound', 'I-95 MP 117.5 Northbound', 
    27.261989, -80.420884, 
    'I-95', 'Northbound', 'Southeast', 'St. Lucie', 
    'I-95 MP 117.5 Northbound', '2025-07-10T14:56:15.2333117+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '680', 'I-95 @ MM 247.7 NB', 'I-95 @ MM 247.7 NB', 
    28.99933, -80.97445, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 247.7 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '702', 'I-95 @ MM 240.8 SB', 'I-95 @ MM 240.8 SB', 
    28.90941, -80.93836, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 240.8 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '703', 'I-95 @ MM 239.8 SB', 'I-95 @ MM 239.8 SB', 
    28.894789, -80.929949, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 239.8 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '704', 'I-95 @ MM 238.9 NB', 'I-95 @ MM 238.9 NB', 
    28.88241, -80.919842, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 238.9 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '705', 'I-95 @ MM 238.9 SB', 'I-95 @ MM 238.9 SB', 
    28.882633, -80.924617, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 238.9 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '706', 'I-95 @ MM 237.8 NB', 'I-95 @ MM 237.8 NB', 
    28.867331, -80.918594, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 237.8 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '707', 'I-95 @ MM 237.8 SB', 'I-95 @ MM 237.8 SB', 
    28.867297, -80.919469, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 237.8 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '708', 'I-95 @ MM 236.9 NB', 'I-95 @ MM 236.9 NB', 
    28.853517, -80.916397, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 236.9 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '709', 'I-95 @ MM 236.9 SB', 'I-95 @ MM 236.9 SB', 
    28.853367, -80.917239, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 236.9 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '710', 'I-95 @ MM 234.8 SB', 'I-95 @ MM 234.8 SB', 
    28.824672, -80.909686, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 234.8 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '711', 'I-95 @ MM 239.8 NB', 'I-95 @ MM 239.8 NB', 
    28.895381, -80.928736, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 239.8 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '724', 'I-95 @ MM 232.9 SB', 'I-95 @ MM 232.9 SB', 
    28.797186, -80.901508, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 232.9 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '725', 'I-95 @ MM 233.9 SB', 'I-95 @ MM 233.9 SB', 
    28.811053, -80.905472, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 233.9 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '726', 'I-95 @ MM 235.8 SB', 'I-95 @ MM 235.8 SB', 
    28.838889, -80.914056, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 235.8 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '727', 'I-95 @ MM 249.1 SB', 'I-95 @ MM 249.1 SB', 
    29.01487, -80.99453, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 249.1 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '728', 'I-95 @ MM 250 SB', 'I-95 @ MM 250 SB', 
    29.0205, -80.998827, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 250 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '729', 'I-95 @ MM 250 NB', 'I-95 @ MM 250 NB', 
    29.0205, -80.98778, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 250 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '730', 'I-95 @ MM 250.8 SB', 'I-95 @ MM 250.8 SB', 
    29.03433, -81.00828, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 250.8 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '731', 'I-95 @ MM 251.3 NB', 'I-95 @ MM 251.3 NB', 
    29.04403, -81.00228, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 251.3 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '732', 'I-95 @ MM 251.4 SB', 'I-95 @ MM 251.4 SB', 
    29.04583, -81.01148, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 251.4 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '733', 'I-95 @ MM 252.2 NB', 'I-95 @ MM 252.2 NB', 
    29.058, -81.00361, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 252.2 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '734', 'I-95 @ MM 252.2 SB', 'I-95 @ MM 252.2 SB', 
    29.058, -81.014325, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 252.2 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '735', 'I-95 @ MM 252.7 SB', 'I-95 @ MM 252.7 SB', 
    29.063, -81.014325, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 252.7 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '736', 'I-95 @ MM 252.7 NB', 'I-95 @ MM 252.7 NB', 
    29.063, -81.00361, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 252.7 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '737', 'I-95 @ MM 253.7 SB', 'I-95 @ MM 253.7 SB', 
    29.07944, -81.02075, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 253.7 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '738', 'I-95 @ MM 253.7 NB', 'I-95 @ MM 253.7 NB', 
    29.07944, -81.01105, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 253.7 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '739', 'I-95 @ MM 254.5 SB', 'I-95 @ MM 254.5 SB', 
    29.09191, -81.02698, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 254.5 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '740', 'I-95 @ MM 255.6 NB', 'I-95 @ MM 255.6 NB', 
    29.103, -81.02261, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 255.6 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '741', 'I-95 @ MM 256.3 NB', 'I-95 @ MM 256.3 NB', 
    29.110625, -81.028246, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 256.3 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '742', 'I-95 @ MM 256.3 SB', 'I-95 @ MM 256.3 SB', 
    29.102676, -81.02962, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 256.3 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '743', 'I-95 @ MM 257.2 NB', 'I-95 @ MM 257.2 NB', 
    29.1228, -81.04055, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 257.2 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '744', 'I-95 @ MM 257.4 SB', 'I-95 @ MM 257.4 SB', 
    29.121373, -81.054382, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 257.4 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '745', 'I-95 @ MM 258.2 SB', 'I-95 @ MM 258.2 SB', 
    29.12856, -81.06421, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 258.2 SB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '746', 'I-95 @ MM 258.2 NB', 'I-95 @ MM 258.2 NB', 
    29.12856, -81.051895, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 258.2 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '747', 'I-95 @ MM 259.1 NB', 'I-95 @ MM 259.1 NB', 
    29.143315, -81.0641, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 259.1 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '748', 'I-95 @ MM 260.1 NB', 'I-95 @ MM 260.1 NB', 
    29.15715, -81.07365, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 260.1 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '759', 'I-95 @ MM 261.1 NB', 'I-95 @ MM 261.1 NB', 
    29.16775, -81.08075, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 261.1 NB', '2024-12-12T16:12:05.3831137+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '763', 'I-95 @ MM 244 NB', 'I-95 @ MM 244 NB', 
    28.95333, -80.9473, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 244 NB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '764', 'I-95 @ MM 261.3 SB', 'I-95 @ MM 261.3 SB', 
    29.17101, -81.0887, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 261.3 SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '766', 'I-95 @ MM 245.2 NB', 'I-95 @ MM 245.2 NB', 
    28.9635, -80.95205, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 245.2 NB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '774', 'I-95 @ MM 261.3 NB', 'I-95 @ MM 261.3 NB', 
    29.17397, -81.08465, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 261.3 NB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '775', 'I-95 @ MM 262.4 SB', 'I-95 @ MM 262.4 SB', 
    29.1844, -81.096, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 262.4 SB', '2024-12-12T16:12:05.4108628+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1025', 'I-95 @ MM 241.8 NB', 'I-95 @ MM 241.8 NB', 
    28.9205, -80.933296, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 241.8 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1026', 'I-95 @ MM 247 SB', 'I-95 @ MM 247 SB', 
    28.987, -80.975839, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 247 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1031', 'I-95 @ MM 247.1 NB', 'I-95 @ MM 247.1 NB', 
    28.98833, -80.967, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 247.1 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1032', 'I-95 @ MM 246.1 NB', 'I-95 @ MM 246.1 NB', 
    28.97616, -80.959303, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 246.1 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1033', 'I-95 @ MM 269.1 SB', 'I-95 @ MM 269.1 SB', 
    29.27149, -81.12519, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 269.1 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1034', 'I-95 @ MM 274.1 NB', 'I-95 @ MM 274.1 NB', 
    29.34783, -81.12678, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 274.1 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1036', 'I-95 @ MM 264.2 SB', 'I-95 @ MM 264.2 SB', 
    29.20716, -81.10295, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 264.2 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1040', 'I-95 @ MM 240.8 NB', 'I-95 @ MM 240.8 NB', 
    28.91008, -80.930056, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 240.8 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1041', 'I-95 @ MM 250.8 NB', 'I-95 @ MM 250.8 NB', 
    29.035347, -80.997347, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 250.8 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1043', 'I-95 @ MM 273.3 NB', 'I-95 @ MM 273.3 NB', 
    29.33566, -81.12681, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 273.3 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1044', 'I-95 @ MM 265.1 SB', 'I-95 @ MM 265.1 SB', 
    29.21857, -81.10678, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 265.1 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1049', 'I-95 @ MM 266 NB', 'I-95 @ MM 266 NB', 
    29.23258, -81.10316, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 266 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1050', 'I-95 @ MM 245.3 SB', 'I-95 @ MM 245.3 SB', 
    28.9625, -80.960633, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 245.3 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1051', 'I-95 @ MM 247.7 SB', 'I-95 @ MM 247.7 SB', 
    28.99833, -80.9832, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 247.7 SB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1052', 'I-95 @ MM 242.7 NB', 'I-95 @ MM 242.7 NB', 
    28.93625, -80.9397, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 242.7 NB', '2024-12-12T16:12:05.4688817+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1056', 'I-95 @ MM 242.7 SB', 'I-95 @ MM 242.7 SB', 
    28.93558, -80.94778, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 242.7 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1057', 'I-95 @ MM 272.2 SB', 'I-95 @ MM 272.2 SB', 
    29.318, -81.13571, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 272.2 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1059', 'I-95 @ MM 271 SB', 'I-95 @ MM 271 SB', 
    29.297, -81.13411, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 271 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1060', 'I-95 @ MM 246.1 SB', 'I-95 @ MM 246.1 SB', 
    28.9745, -80.967693, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 246.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1062', 'I-95 @ MM 267.8 NB', 'I-95 @ MM 267.8 NB', 
    29.258584, -81.114463, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 267.8 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1063', 'I-95 @ MM 248.9 NB', 'I-95 @ MM 248.9 NB', 
    29.012, -80.981512, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 248.9 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1064', 'I-95 @ MM 263 NB', 'I-95 @ MM 263 NB', 
    29.19191, -81.08984, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 263 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1065', 'I-95 @ MM 269.9 NB', 'I-95 @ MM 269.9 NB', 
    29.27783, -81.1188, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 269.9 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1066', 'I-95 @ MM 267 SB', 'I-95 @ MM 267 SB', 
    29.245816, -81.116437, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 267 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1069', 'I-95 @ MM 241.8 SB', 'I-95 @ MM 241.8 SB', 
    28.92008, -80.94145, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 241.8 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1083', 'I-95 @ MM 276.1 SB', 'I-95 @ MM 276.1 SB', 
    29.36266, -81.14113, 
    'I-95', 'Southbound', 'Central', 'Volusia', 
    'I-95 @ MM 276.1 SB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

INSERT INTO cameras (
    camera_id, name, description, latitude, longitude, roadway, direction, 
    region, county, location, install_date, equipment_type
) VALUES (
    '1103', 'I-95 @ MM 278.3 NB', 'I-95 @ MM 278.3 NB', 
    29.407077, -81.1521, 
    'I-95', 'Northbound', 'Central', 'Volusia', 
    'I-95 @ MM 278.3 NB', '2024-12-12T16:12:05.4845249+00:00', 'application/x-mpegURL'
) ON CONFLICT (camera_id) DO UPDATE SET
    updated_at = CURRENT_TIMESTAMP,
    name = EXCLUDED.name,
    description = EXCLUDED.description;

