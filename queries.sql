DROP DATABASE IF EXISTS server_configurator;

CREATE DATABASE IF NOT EXISTS server_configurator DEFAULT CHARACTER SET utf8;
USE server_configurator;

DROP TABLE IF EXISTS processor;

CREATE TABLE IF NOT EXISTS processor
(
  processor_id INT UNSIGNED            NOT NULL AUTO_INCREMENT,
  name         VARCHAR(50)             NOT NULL,
  price        DECIMAL(10, 2) UNSIGNED NOT NULL,
  PRIMARY KEY (processor_id)
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS operating_memory;

CREATE TABLE IF NOT EXISTS operating_memory
(
  operating_memory_id INT UNSIGNED            NOT NULL AUTO_INCREMENT,
  value               INT UNSIGNED            NOT NULL,
  type                ENUM ('DDR3', 'DDR4')   NOT NULL,
  subtype             ENUM ('ECC', 'ECC Reg') NOT NULL,
  form_factor         ENUM ('DIMM', 'LRDIMM') NOT NULL DEFAULT 'DIMM',
  price               DECIMAL(10, 2) UNSIGNED NOT NULL,
  PRIMARY KEY (operating_memory_id)
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS box;

CREATE TABLE IF NOT EXISTS box
(
  id    INT UNSIGNED            NOT NULL AUTO_INCREMENT,
  name  VARCHAR(45)             NOT NULL,
  price DECIMAL(10, 2) UNSIGNED NOT NULL,
  PRIMARY KEY (id)
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS motherboard;

CREATE TABLE IF NOT EXISTS motherboard
(
  motherboard_id INT UNSIGNED            NOT NULL AUTO_INCREMENT,
  name           VARCHAR(45)             NOT NULL,
  price          DECIMAL(10, 2) UNSIGNED NOT NULL,
  box_id         INT UNSIGNED            NOT NULL,
  PRIMARY KEY (motherboard_id),
  FOREIGN KEY (box_id)
    REFERENCES box (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS pcie_card;

CREATE TABLE IF NOT EXISTS pcie_card
(
  pcie_card_id INT UNSIGNED                                            NOT NULL AUTO_INCREMENT,
  name         VARCHAR(50)                                             NOT NULL,
  type         ENUM ('Network card', 'Raid controller and NBA', 'GPU') NOT NULL,
  price        DECIMAL(10, 2) UNSIGNED                                 NOT NULL,
  PRIMARY KEY (pcie_card_id)
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS data_storage;

CREATE TABLE IF NOT EXISTS data_storage
(
  data_storage_id INT UNSIGNED                           NOT NULL AUTO_INCREMENT,
  name            VARCHAR(50)                            NOT NULL DEFAULT '',
  type            ENUM ('SSD', 'SATA', 'NVME', 'OPTANE') NOT NULL,
  value           DECIMAL(5, 3) UNSIGNED                 NOT NULL,
  price           DECIMAL(10, 2) UNSIGNED                NOT NULL,
  PRIMARY KEY (data_storage_id)
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS motherboard_operating_memory;

CREATE TABLE IF NOT EXISTS motherboard_operating_memory
(
  motherboard_id      INT UNSIGNED NOT NULL,
  operating_memory_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (motherboard_id, operating_memory_id),
  FOREIGN KEY (motherboard_id)
    REFERENCES motherboard (motherboard_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (operating_memory_id)
    REFERENCES operating_memory (operating_memory_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS motherboard_pcie_card;

CREATE TABLE IF NOT EXISTS motherboard_pcie_card
(
  motherboard_id INT UNSIGNED NOT NULL,
  pcie_card_id   INT UNSIGNED NOT NULL,
  PRIMARY KEY (motherboard_id, pcie_card_id),
  FOREIGN KEY (motherboard_id)
    REFERENCES motherboard (motherboard_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (pcie_card_id)
    REFERENCES pcie_card (pcie_card_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS motherboard_data_storage;

CREATE TABLE IF NOT EXISTS motherboard_data_storage
(
  motherboard_id  INT UNSIGNED NOT NULL,
  data_storage_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (motherboard_id, data_storage_id),
  FOREIGN KEY (motherboard_id)
    REFERENCES motherboard (motherboard_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (data_storage_id)
    REFERENCES data_storage (data_storage_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS install_information;

CREATE TABLE IF NOT EXISTS install_information
(
  id           INT UNSIGNED            NOT NULL AUTO_INCREMENT,
  months_count INT UNSIGNED            NOT NULL,
  discount     DECIMAL UNSIGNED        NOT NULL DEFAULT 0,
  install_cost DECIMAL(10, 2) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS motherboard_processor;

CREATE TABLE IF NOT EXISTS motherboard_processor
(
  motherboard_id INT UNSIGNED NOT NULL,
  processor_id   INT UNSIGNED NOT NULL,
  PRIMARY KEY (motherboard_id, processor_id),
  FOREIGN KEY (motherboard_id)
    REFERENCES motherboard (motherboard_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (processor_id)
    REFERENCES processor (processor_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8;

INSERT INTO processor (name, price)
VALUES ('Intel E3-1230 (4x3.2 GHz HT)', 1177),
       ('Intel E3-1230v6 (4x3.6 GHz  HT)', 1498),
       ('Intel E3-1270v6 (4x3.8 GHz  HT)', 2140),
       ('Intel Silver 4114 (10x2.2 GHz  HT)', 3210),
       ('Intel E5-1650 (6x3.5 GHz  HT)', 3210),
       ('Intel E5-1650v3 (6x3.5 GHz  HT)', 3531),
       ('Intel E5-1650v4 (6x3.60 GHz  HT)', 3745),
       ('AMD EPYC 7351P (16x2.4 GHz )', 4173),
       ('Intel W-2133 (6x3.6 GHz )', 4280),
       ('AMD EPYC 7401P (24x2.0 GHz )', 10165),
       ('Intel E5-2680v4 (14x2.40 GHz  HT)', 10272),
       ('Intel Gold 6140 (18x2.3 GHz  HT)', 11235),
       ('Intel E5-2630v3 (8x2.4 GHz  HT)', 2996);

INSERT INTO operating_memory (value, type, subtype, form_factor, price)
VALUES (4, 'ddr3', 'ECC', DEFAULT, 288.90),
       (8, 'ddr3', 'ECC', DEFAULT, 374.50),
       (16, 'ddr3', 'ECC', DEFAULT, 749),
       (32, 'ddr3', 'ECC', DEFAULT, 1498),
       (8, 'ddr4', 'ECC', DEFAULT, 642),
       (16, 'ddr4', 'ECC', DEFAULT, 1177),
       (32, 'ddr4', 'ECC', DEFAULT, 2354),
       (64, 'ddr4', 'ECC', DEFAULT, 4708),
       (8, 'ddr4', 'ECC Reg', DEFAULT, 642),
       (16, 'ddr4', 'ECC Reg', DEFAULT, 1177),
       (32, 'ddr4', 'ECC Reg', DEFAULT, 2247),
       (64, 'ddr4', 'ECC Reg', 'LRDIMM', 4815),
       (128, 'ddr4', 'ECC Reg', DEFAULT, 8988),
       (256, 'ddr4', 'ECC Reg', DEFAULT, 17976),
       (512, 'ddr4', 'ECC Reg', 'LRDIMM', 38520),
       (1024, 'ddr4', 'ECC Reg', 'LRDIMM', 77040);

INSERT INTO box (name, price)
VALUES ('813MTQ-350CB (1U)', 3531),
       ('ASUS ESC8000 G3', 22042);

INSERT INTO motherboard (name, price, box_id)
VALUES ('X9SCL-F', 856, 1),
       ('X11SSL-F', 1070, 1),
       ('X11SPi-TF', 2461, 1),
       ('X9SRI-F', 1605, 1),
       ('X10SRi', 1605, 1),
       ('H11SSL-i-B', 1926, 1),
       ('X11SRM-F', 1605, 1),
       ('ASUS Z10PG-D24', 0, 2);

INSERT INTO pcie_card (name, type, price)
VALUES ('1GE (2 ports)', 'Network card', 1070),
       ('10GE (2 ports)', 'Network card', 1070),
       ('HBA (no RAID) 16 ports', 'Raid controller and NBA', 1926),
       ('RAID controller 8 ports + Cache protection', 'Raid controller and NBA', 3638),
       ('RAID controller 16 ports + Cache protection', 'Raid controller and NBA', 4387),
       ('RAID controller 16 ports + SSD Cache', 'Raid controller and NBA', 5885),
       ('GPU GTX 1080 8 Gb GDDR5X', 'GPU', 7169);

INSERT INTO data_storage (name, type, value, price)
VALUES ('PCI-E NVMe', 'nvme', 1.6, 6634),
       ('Intel Optane SSD DC P4800X', 'nvme', 0.75, 9095),
       (DEFAULT, 'ssd', 0.24, 695.50),
       (DEFAULT, 'ssd', 0.48, 1284),
       (DEFAULT, 'sata', 1, 428),
       (DEFAULT, 'sata', 2, 642),
       (DEFAULT, 'sata', 6, 1231),
       ('Intel Optane SSD DC P4800X with IMDT', 'optane', 0.375, 10700);

INSERT INTO motherboard_operating_memory
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (2, 5),
       (2, 6),
       (2, 7),
       (2, 8),
       (3, 9),
       (3, 10),
       (3, 11),
       (3, 12),
       (3, 13),
       (3, 14),
       (3, 15),
       (4, 1),
       (4, 2),
       (4, 3),
       (5, 9),
       (5, 10),
       (5, 11),
       (5, 12),
       (5, 13),
       (5, 14),
       (5, 15),
       (6, 9),
       (6, 10),
       (6, 11),
       (6, 12),
       (6, 13),
       (6, 14),
       (6, 15),
       (7, 9),
       (7, 10),
       (7, 11),
       (7, 12),
       (7, 13),
       (7, 14),
       (8, 9),
       (8, 10),
       (8, 11),
       (8, 12),
       (8, 13),
       (8, 14),
       (8, 15),
       (8, 16);

INSERT INTO motherboard_pcie_card (motherboard_id, pcie_card_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (1, 5),
       (1, 6),
       (2, 1),
       (2, 2),
       (2, 3),
       (2, 4),
       (2, 5),
       (2, 6),
       (3, 1),
       (3, 2),
       (3, 3),
       (3, 4),
       (3, 5),
       (3, 6),
       (4, 1),
       (4, 2),
       (4, 3),
       (4, 4),
       (4, 5),
       (4, 6),
       (5, 1),
       (5, 2),
       (5, 3),
       (5, 4),
       (5, 5),
       (5, 6),
       (6, 1),
       (6, 2),
       (6, 3),
       (6, 4),
       (6, 5),
       (6, 6),
       (7, 1),
       (7, 2),
       (7, 3),
       (7, 4),
       (7, 5),
       (7, 6),
       (8, 1),
       (8, 2),
       (8, 3),
       (8, 4),
       (8, 5),
       (8, 6),
       (8, 7);

INSERT INTO motherboard_data_storage (motherboard_id, data_storage_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (1, 4),
       (1, 5),
       (1, 6),
       (1, 7),
       (2, 1),
       (2, 2),
       (2, 3),
       (2, 4),
       (2, 5),
       (2, 6),
       (2, 7),
       (3, 1),
       (3, 2),
       (3, 3),
       (3, 4),
       (3, 5),
       (3, 6),
       (3, 7),
       (4, 1),
       (4, 2),
       (4, 3),
       (4, 4),
       (4, 5),
       (4, 6),
       (4, 7),
       (3, 8),
       (4, 8),
       (5, 1),
       (5, 2),
       (5, 3),
       (5, 4),
       (5, 5),
       (5, 6),
       (5, 7),
       (5, 8),
       (6, 1),
       (6, 2),
       (6, 3),
       (6, 4),
       (6, 5),
       (6, 6),
       (6, 7),
       (6, 8),
       (7, 1),
       (7, 2),
       (7, 3),
       (7, 4),
       (7, 5),
       (7, 6),
       (7, 7),
       (7, 8),
       (8, 1),
       (8, 2),
       (8, 3),
       (8, 4),
       (8, 8);

INSERT INTO install_information (months_count, discount, install_cost)
VALUES (1, 0, 6000),
       (6, 7, 0),
       (12, 15, 0),
       (24, 15, 0);

INSERT INTO motherboard_processor (motherboard_id, processor_id)
VALUES (1, 1),
       (2, 2),
       (2, 3),
       (3, 4),
       (4, 5),
       (5, 6),
       (5, 7),
       (6, 8),
       (7, 9),
       (6, 10),
       (5, 11),
       (3, 12),
       (8, 13);





