USE [test]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parts](
	[PartPkey] [int] IDENTITY(1,1) NOT NULL,
	[PartCategoryID] [int] NULL,
	[PartFootprintID] [int] NULL,
	[PartManID] [int] NULL,
	[PartName] [varchar](250) NULL,
	[PartDescription] [varchar](250) NULL,
	[PartComment] [text] NULL,
	[StockLevel] [int] NULL,
	[MinStockLevel] [int] NULL,
	[Price] [decimal](18, 4) NULL,
	[DateCreated] [datetime] NULL,
	[DateUpdated] [datetime] NULL,
	[Condition] [tinyint] NULL,
	[StorageLocationID] [int] NULL,
	[MPN] [varchar](250) NULL,
	[BarCode] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Footprint](
	[FootprintPkey] [int] IDENTITY(1,1) NOT NULL,
	[FootprintName] [varchar](50) NULL,
	[FootprintDescription] [varchar](250) NULL,
	[FootprintImage] [varchar](50) NULL,
	[FootprintCategory] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Manufacturer](
	[mpkey] [int] IDENTITY(1,1) NOT NULL,
	[ManufacturerName] [varchar](250) NULL,
	[ManufacturerAddress] [varchar](250) NULL,
	[ManufacturerURL] [varchar](250) NULL,
	[ManufacturerPhone] [varchar](250) NULL,
	[ManufacturerEmail] [varchar](250) NULL,
	[ManufacturerLogo] [varchar](250) NULL,
	[ManufacturerComment] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PartCategory](
	[PCpkey] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NULL,
	[PCName] [varchar](250) NULL,
	[PCDescription] [varchar](250) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StorageLocation](
	[StoragePkey] [int] IDENTITY(1,1) NOT NULL,
	[StorageName] [varchar](250) NULL,
	[StorageSortOrder] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [View_PartsData]
AS
SELECT        dbo.Parts.PartPkey, dbo.Parts.PartCategoryID, dbo.Parts.PartFootprintID, dbo.Parts.PartManID, dbo.Parts.PartName, dbo.Parts.PartDescription, dbo.Parts.PartComment, dbo.Parts.StockLevel, dbo.Parts.MinStockLevel, 
                         dbo.Parts.Price, dbo.Parts.DateCreated, dbo.Parts.DateUpdated, dbo.Parts.Condition, dbo.Parts.StorageLocationID, dbo.StorageLocation.StorageName, dbo.Manufacturer.ManufacturerName, dbo.Footprint.FootprintName, 
                         dbo.Footprint.FootprintImage, dbo.Manufacturer.ManufacturerLogo, dbo.PartCategory.PCName, dbo.Parts.MPN, dbo.Parts.BarCode
FROM            dbo.Parts INNER JOIN
                         dbo.Manufacturer ON dbo.Parts.PartManID = dbo.Manufacturer.mpkey INNER JOIN
                         dbo.StorageLocation ON dbo.Parts.StorageLocationID = dbo.StorageLocation.StoragePkey INNER JOIN
                         dbo.Footprint ON dbo.Parts.PartFootprintID = dbo.Footprint.FootprintPkey INNER JOIN
                         dbo.PartCategory ON dbo.Parts.PartCategoryID = dbo.PartCategory.PCpkey
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FootprintCategory](
	[FCPkey] [int] IDENTITY(1,1) NOT NULL,
	[FCName] [varchar](50) NULL,
	[FCDescription] [varchar](250) NULL,
	[ParentCategory] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [View_FootprintsCats]
AS
SELECT        dbo.Footprint.FootprintPkey, dbo.Footprint.FootprintName, dbo.Footprint.FootprintDescription, dbo.Footprint.FootprintImage, dbo.Footprint.FootprintCategory, dbo.FootprintCategory.FCName, 
                         dbo.FootprintCategory.ParentCategory, dbo.FootprintCategory.FCPkey, dbo.FootprintCategory.FCDescription
FROM            dbo.Footprint INNER JOIN
                         dbo.FootprintCategory ON dbo.Footprint.FootprintCategory = dbo.FootprintCategory.FCPkey
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PartAttachment](
	[PApkey] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](250) NULL,
	[DisplayName] [varchar](250) NULL,
	[MIMEType] [varchar](250) NULL,
	[DateCreated] [datetime] NULL,
	[PartID] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PartParameter](
	[PPpkey] [int] IDENTITY(1,1) NOT NULL,
	[PartID] [int] NULL,
	[ParamName] [varchar](250) NULL,
	[ParamDescription] [varchar](250) NULL,
	[ParamValue] [varchar](50) NULL,
	[normalizedValue] [varchar](50) NULL,
	[maximumValue] [varchar](50) NULL,
	[normalizedMaxValue] [varchar](50) NULL,
	[minimumValue] [varchar](50) NULL,
	[normalizedMinValue] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PartSuppliers](
	[SupPkey] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [varchar](250) NULL,
	[URL] [varchar](250) NULL,
	[PartID] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users](
	[UserPkey] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[UserPass] [varchar](300) NULL
) ON [PRIMARY]
GO
ALTER TABLE [Footprint] ADD  CONSTRAINT [DF_Footprint_FootprintCategory]  DEFAULT ((0)) FOR [FootprintCategory]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PartStockLevelHistory](
	[HistoryPkey] [int] IDENTITY(1,1) NOT NULL,
	[PartPkey] [int] NULL,
	[StockLevel] [int] NULL,
	[DateChanged] [datetime] NULL
) ON [PRIMARY]
GO



SET IDENTITY_INSERT PartCategory ON
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (2, 0, 'Active Components' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (36, 10, 'Amplifiers & Comparators' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (111, 57, 'ARM' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (110, 57, 'ATMEGA' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (41, 10, 'Audio Processing & Control' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (23, 4, 'Battery Holders' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (33, 5, 'Bearings' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (82, 73, 'Bipolar Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (31, 5, 'Bolts' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (74, 68, 'Bridge Rectifier Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (6, 0, 'Cables' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (14, 3, 'Capactiors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (42, 10, 'Clock,Timing & Frequency Management' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (43, 10, 'CODECs / Encoders / Decoders' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (92, 8, 'Communications & Networking Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (44, 10, 'Configurable Mixed Signal ICs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (19, 4, 'Connectors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (28, 5, 'Cooling' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (15, 3, 'Crystals, Oscillators & Resonators' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (75, 68, 'Current Regulator Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (45, 10, 'Data & Signal Conversion' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (46, 10, 'Digital Potentiometers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (47, 10, 'Digital Signal Controllers - DSC' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (48, 10, 'Digital Signal Processors - DSP' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (68, 67, 'Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (95, 11, 'Displays' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (49, 10, 'Drivers & Interfaces' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (4, 0, 'Electromechanical Parts' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (69, 67, 'Electron Tubes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (76, 68, 'Fast Recovery Rectifier Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (96, 11, 'Fibre Optic Components' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (50, 10, 'Filters - Active' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (51, 10, 'FPGAs / CPLDs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (22, 4, 'Fuses' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (52, 10, 'GALs / PALs & SPLDs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (83, 73, 'IGBT Arrays & Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (84, 73, 'IGBT Single Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (18, 3, 'Inductors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (97, 11, 'Infrared Emitters & Receivers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (70, 67, 'Intelligent Power Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (93, 8, 'Interface Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (54, 10, 'Isolated Feedback Generators' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (85, 73, 'JFET Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (98, 11, 'Laser Components & Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (100, 11, 'LED Accessories' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (99, 11, 'LEDs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (35, 10, 'Logic' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (103, 8, 'MCU Modules' , 'Microntroller Breakout Modules')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (5, 0, 'Mechanical Parts' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (55, 10, 'Memory' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (56, 10, 'Memory Controllers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (27, 5, 'Mica Washers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (57, 10, 'Microcontrollers - MCU' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (58, 10, 'Microprocessors - MPU' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (86, 73, 'Miscellaneous Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (8, 0, 'Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (87, 73, 'MOSFET Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (25, 4, 'Motors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (59, 10, 'Network Controllers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (30, 5, 'Nuts' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (101, 11, 'Optocouplers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (11, 0, 'Optoelectronics & Displays' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (9, 0, 'Other' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (12, 2, 'Others' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (3, 0, 'Passive Components' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (102, 11, 'Photodetectors & Photointerrupters' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (17, 3, 'Photoresistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (104, 57, 'PIC10' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (105, 57, 'PIC12' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (106, 57, 'PIC16' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (107, 57, 'PIC18' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (108, 57, 'PIC24 / DSPIC' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (109, 57, 'PIC32' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (16, 3, 'Potentiometers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (60, 10, 'Power Management ICs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (71, 67, 'Power Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (32, 5, 'Pullleys' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (21, 4, 'Relays' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (13, 3, 'Resistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (61, 10, 'RF' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (77, 68, 'RF / Pin Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (88, 73, 'RF FET Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (91, 8, 'RF Modules' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (89, 73, 'RF Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (78, 68, 'Schottky Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (29, 5, 'Screws' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (67, 2, 'Semiconductors - Discretes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (10, 2, 'Semiconductors - ICs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (53, 10, 'Sensor ICs' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (79, 68, 'Small Signal Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (34, 5, 'Spacers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (7, 0, 'Speakers and Sounders' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (62, 10, 'Special Function' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (80, 68, 'Standard Recovery Rectifier Diodes' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (20, 4, 'Switches' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (63, 10, 'Switches, Multiplexers & Demultiplexers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (72, 67, 'Thyristors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (64, 10, 'Touch Screen Controllers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (24, 4, 'Transformers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (73, 67, 'Transistors' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (65, 10, 'TV Tuners' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (90, 73, 'Unijunction Transistors - UJT' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (66, 10, 'Video Processing' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (26, 5, 'Washers' , '')
GO
INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (81, 68, 'Zener Diodes' , '')
GO
SET IDENTITY_INSERT PartCategory OFF
GO
SET IDENTITY_INSERT FootprintCategory ON
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (18, 'Axial', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (2, 'BGA', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (3, 'CBGA', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (7, 'CERDIP', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (5, 'DFN', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (6, 'DIP', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (4, 'FCBGA', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (20, 'Other', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (8, 'PDIP', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (9, 'QFN', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (10, 'SOIC', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (11, 'SOT', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (12, 'SSOP', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (13, 'SSOT', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (19, 'TO', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (14, 'TQFP', '' , 0)
GO
INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (15, 'TSOP', '' , 0)
GO
SET IDENTITY_INSERT FootprintCategory OFF
GO
SET IDENTITY_INSERT Footprint ON
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (68, 'Axial Component', '' , '/docs/footprints/axial.svg', 18)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (1, 'CBGA-32', '32-Lead Ceramic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (20, 'CerDIP-14', '14-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (21, 'CerDIP-16', '16-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (22, 'CerDIP-18', '18-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (23, 'CerDIP-20', '20-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (24, 'CerDIP-24 Narrow', '24-Lead Ceramic Dual In-Line Package - Narrow Body' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (25, 'CerDIP-24 Wide', '24-Lead Ceramic Dual In-Line Package - Wide Body' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (26, 'CerDIP-28', '28-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (27, 'CerDIP-40', '40-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (19, 'CerDIP-8', '8-Lead Ceramic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (62, 'DFN 8', '' , '/docs/footprints/dfn.svg', 5)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (70, 'DIP Module', '' , '/docs/footprints/dip.svg', 20)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (2, 'FCBGA-576', '576-Ball Ball Grid Array, Thermally Enhanced' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (61, 'HTSSOP 16', '' , '', 12)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (3, 'PBGA-119', '119-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (4, 'PBGA-169', '169-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (5, 'PBGA-225', '225-Ball Plastic a Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (6, 'PBGA-260', '260-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (7, 'PBGA-297', '297-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (8, 'PBGA-304', '304-Lead Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (9, 'PBGA-316', '316-Lead Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (10, 'PBGA-324', '324-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (11, 'PBGA-385', '385-Lead Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (12, 'PBGA-400', '400-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (13, 'PBGA-484', '484-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (14, 'PBGA-625', '625-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (15, 'PBGA-676', '676-Ball Plastic Ball Grid Array' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (29, 'PDIP-14', '14-Lead Plastic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (30, 'PDIP-16', '16-Lead Plastic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (31, 'PDIP-18', '18-Lead Plastic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (32, 'PDIP-20', '20-Lead Plastic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (33, 'PDIP-24', '24-Lead Plastic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (34, 'PDIP-28 Narrow', '28-Lead Plastic Dual In-Line Package, Narrow Body' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (35, 'PDIP-28 Wide', '28-Lead Plastic Dual In-Line Package, Wide Body' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (40, 'PDIP-40', '' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (28, 'PDIP-8', '8-Lead Plastic Dual In-Line Package' , '/docs/footprints/dip.svg', 6)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (44, 'QFN 16', '' , '/docs/footprints/qfn.svg', 9)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (60, 'QFN 40', '' , '/docs/footprints/qfn.svg', 9)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (59, 'QFN 43', '' , '/docs/footprints/qfn.svg', 9)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (16, 'SBGA-256', '256-Ball Ball Grid Array, Thermally Enhanced' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (17, 'SBGA-304', '304-Ball Ball Grid Array, Thermally Enhanced' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (18, 'SBGA-432', '432-Ball Ball Grid Array, Thermally Enhanced' , '/docs/footprints/bga.svg', 2)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (45, 'SOIC-14', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (37, 'SOIC-16', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (42, 'SOIC-16 300mil', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (41, 'SOIC-18 300mil', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (50, 'SOIC-20 300mil', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (49, 'SOIC-24 300mil', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (38, 'SOIC-28 300mil', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (36, 'SOIC-8', '' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (54, 'SOIC-N-EP-8', '8-Lead Standard Small Outline Package, with Expose Pad' , '/docs/footprints/soic.svg', 10)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (56, 'SOT-23', '' , '/docs/footprints/sot.svg', 11)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (57, 'SOT-5', '' , '/docs/footprints/sot.svg', 11)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (51, 'SOT505-1', '' , '/docs/footprints/sot.svg', 11)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (55, 'SSOP-14', '' , '/docs/footprints/sot.svg', 12)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (46, 'SSOP-5', '' , '/docs/footprints/sot.svg', 12)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (48, 'SSOT-3', '' , '/docs/footprints/sot.svg', 12)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (47, 'SSOT-5', '' , '/docs/footprints/sot.svg', 12)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (43, 'SSOT-6', '' , '/docs/footprints/sot.svg', 11)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (69, 'TO-3', '' , '', 19)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (72, 'TQFP-100', '' , '/docs/footprints/tqfp.svg', 14)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (73, 'TQFP-32', '' , '/docs/footprints/tqfp.svg', 14)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (39, 'TQFP-44', '' , '/docs/footprints/tqfp.svg', 14)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (71, 'TQFP-64', '' , '/docs/footprints/tqfp.svg', 14)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (58, 'TSOP-14', '' , '/docs/footprints/soic.svg', 15)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (52, 'TSOP-16', '' , '/docs/footprints/soic.svg', 15)
GO
INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (53, 'TSOP-20', '' , '/docs/footprints/soic.svg', 15)
GO
SET IDENTITY_INSERT Footprint OFF
GO
SET IDENTITY_INSERT [dbo].[Manufacturer] ON 
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (1, N'Microchip / Amtel', N'', N'https://www.microchip.com/', N'123456', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (5, N'Other', N'', N'', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (6, N'ADI (Analog Devices Inc.)', N'', N'https://www.analog.com/en/index.html', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (7, N'NXP Semiconductors ', N'', N'https://www.nxp.com/', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (8, N'Maxim Integrated ', N'', N'https://www.maximintegrated.com/en.html', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (9, N'Linear Technology / Analog Devices ', N'', N'', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (10, N'STMicroelectronics ', N'', N'https://www.st.com/content/st_com/en.html', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (11, N'Texas Instruments ', N'', N'http://www.ti.com/', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (12, N'Vishay ', N'', N'', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (14, N'Arduino', N'', N'', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (15, N'National Semiconductor', N'', N'', N'', N'', N'', N'Acquired by Texas Instruments')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (16, N'Samsung', N'', N'', N'', N'', N'', N'')
GO
INSERT [dbo].[Manufacturer] ([mpkey], [ManufacturerName], [ManufacturerAddress], [ManufacturerURL], [ManufacturerPhone], [ManufacturerEmail], [ManufacturerLogo], [ManufacturerComment]) VALUES (17, N'Cypress', N'', N'', N'', N'', N'', N'')
GO
SET IDENTITY_INSERT [dbo].[Manufacturer] OFF
GO