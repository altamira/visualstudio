﻿-- =============================================
-- Script Template
-- =============================================

PRINT 'Inserting [Location].[Country]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Location].[Country] ON

INSERT INTO [$(DatabaseName)].[Location].[Country] ([Id], [Name], [ISOCountryCodeCh2], [ISOCountryCodeCh3], [CallingCode], [Flag]) VALUES (1, 'BRASIL', 'BR', 'BRA', 55, 0x89504E470D0A1A0A0000000D49484452000000160000000F0806000000E06D3F6800000006624B474400FF00FF00FFA0BDA7930000000774494D4507D90711133321050263EA0000023849444154388DB5934D4893711CC73FCFD3B674CEB9399D2FEDC515630789062A75D243E821223C65970E75B08B4111245E224FE6208AEA1043BA08D10B744A3A8897300CF4A08ECAB5D23659CE9973B5B5779F7550672F8F6B107D8FFF97CFFFCBF7FBFB0BDCE9C8F31F24967A5025E65189A57B2809DCAE8932ED9861DA3143BB26FAEF608322CB886581319B87CDA086CDA086319B8711CB020645B6285821B7280067AB430C1D58E4ED9C8913F7CFB316A900C0688873EDC204F347A619081E6434528F5C407F3876942518B7CFE2B67A59F5EBB9EE3E4D2CA12BEC87D7355C769D646D5987DBEA65DC3E8BA32C21636E7B2ACA4589AB7501AE180385929E7AEEF16E438B52A5A0BA424B4EC811F245187B384F47EB076EF53F07202309DC0C5B70AD5A484AE26E14A2008F6D6FE8D2467E79F5C983297C811A2A2BD5C4625BAE8E1DB7D2E7EA62EE8512D802ABC43C03F57E5AD431BA170F23E5B7A390F2D0B3D4CC50C84A46120A609B3941A3494F3A9DC568D4535BABE5F5849FD11B53B43877E3C9480243212B3D4BCD48F9DF324E4A22832B4DB4795B998C570170AEFB155F23DF28572B89C5BF934AE73099F4D4359473B4E1360093F12ADABCAD0CAE341562902DCF9B52D3E973D2EB7760B46C307CE919FBF7854925B3C46349B4BA247DA7DCD498A3F4FA1D74FA9C7853EABDCB9393419165B8F12367746BBCFF54832080DDFA8547D15AFA3F1F623DA7DCEB6A71F08EDA3551EE9A7D005C5CB6F332AEFBCB8D12C14061047F2EB798647F9E9C4A05EEE807575CCD57E5147B760000000049454E44AE426082)
GO
INSERT INTO [$(DatabaseName)].[Location].[Country] ([Id], [Name], [ISOCountryCodeCh2], [ISOCountryCodeCh3], [CallingCode], [Flag]) VALUES (2, 'ESTADOS UNIDOS', 'US', 'USA', 1, 0x89504E470D0A1A0A0000000D49484452000000160000000C080600000066F94DC600000006624B474400FF00FF00FFA0BDA7930000000774494D4507DA071D060702CAE04DE20000013549444154388DB5D2314EC26018C6F1FF872D488162B124F0A118492FE0A28309839B8BF10CCC5EC02B182FE0EA253C813131DE002406A4430B41810269A1757135FA99F04CEFF0E497777844AB759374DA2E8E230141B7EB72785801049EF7413D2FB8683FA11A2D0C231C47629A3926D3398D86A4542AE07963A4B4D1331ACDDB7B7578E84FA9562D8260C17412609A06B3D99CD16842AD66337A7DE3E5EA5A1D2E978B005856014D4B11AD62CC629EEA6A8DAEEB58FB159CCB73753893D1E9F77DD2E90C4992E00E466CA504000377C8C16E96E1E3B33ABC5C864859C230D204F305529630CD1CBE3FA65AB188160B8C7A4D1D3EB135E2382695CC200B711223A24FF6760422092998DBCA2880D6CC45DFE7FA87CA8A796FA00EDBA7C7FFFAE857B873A7BED1BF4404BDF76423F0C3D1D946E02F2EBC686857C1D9E80000000049454E44AE426082)
GO

SET IDENTITY_INSERT [$(DatabaseName)].[Location].[Country] OFF
