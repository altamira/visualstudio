


CREATE VIEW [dbo].[View_ATDAgrupado]
AS
SELECT     
	dbo.ATD.Atd0Cod AS VwAtd0Cod, 
	'GPIMAC' AS VwAtd0Origem, 
	dbo.ATD.Atd0Dat AS VwAtd0Dat, 
	dbo.ATD.Atd0DtH AS VWAtd0DtH, 
	dbo.ATD.Atd0Aut AS VwAtd0Aut, 
	dbo.ATD.Atd0Pc0Cod AS VwAtd0Pc0Cod, 
	dbo.CAPCL.Pc0LogTipCod AS VwAtd0Pc0LogTipCod, 
	dbo.CAPCL.Pc0End AS VwAtd0Pc0End, 
	dbo.CAPCL.Pc0EndNum AS VwAtd0Pc0EndNum, 
	dbo.CAPCL.Pc0EndCpl AS VwAtd0Pc0EndCpl, 
	dbo.CAPCL.Pc0Bai AS VwAtd0Pc0Bai, 
	dbo.CAPCL.Pc0Cep AS VwAtd0Pc0Cep, 
	dbo.CAPCL.Pc0Cid AS VwAtd0Pc0Cid, 
	dbo.CAPCL.Pc0UfCod AS VwAtd0Pc0UfCod, 
	dbo.CAPCL.Pc0Fan AS VwAtd0Pc0Fan, 
	dbo.CAPCL.Pc0Nom AS VwAtd0Pc0Nom, 
	dbo.ATD.Atd0Pc1Cod AS VwAtd0Pc1Cod, 
	dbo.CAPCL1.Pc1Nom AS VwAtd0Pc1Nom, 
	dbo.CAPCL1.Pc1TelDdd AS VwAtd0Pc1TelDdd, 
	dbo.CAPCL1.Pc1TelNum AS VwAtd0Pc1TelNum, 
	dbo.CAPCL1.Pc1TelRam AS VwAtd0Pc1TelRam, 
	dbo.CAPCL1.Pc1FaxDdd AS VwAtd0Pc1FaxDdd, 
	dbo.CAPCL1.Pc1FaxNum AS VwAtd0Pc1FaxNum, 
	dbo.CAPCL1.Pc1FaxRam AS VwAtd0Pc1FaxRam, 
	dbo.CAPCL1.Pc1CelDdd AS VwAtd0Pc1CelDdd, 
	dbo.CAPCL1.Pc1CelNum AS VwAtd0Pc1CelNum, 
	dbo.CAPCL1.Pc1Dep AS VwAtd0Pc1Dep, 
	dbo.CAPCL1.Pc1Cgo AS VwAtd0Pc1Cgo, 
	dbo.CAPCL1.Pc1Eml AS VwAtd0Pc1Eml, 
	dbo.ATD.Atd0CvCod AS VwAtd0CvCod, 
	dbo.CAREP.CVNOM AS VwAtd0CvNom, 
	dbo.ATD.Atd0TpA0Cod AS VwAtd0TpA0Cod, 
	dbo.CATPA.CTpA0Nom AS VwAtd0TpA0Nom, 
	dbo.ATD.Atd0StA0Cod AS VwAtd0StA0Cod, 
	dbo.CASTA.CStA0Nom AS VwAtd0StA0Nom, 
	dbo.ATD.Atd0MdA0Cod AS VwAtd0MdA0Cod, 
	dbo.CAMDA.CMdA0Nom AS VwAtd0MdA0Nom, 
	dbo.ATD.Atd0Obs AS VwAtd0Obs, 
	dbo.ATD.Atd0SmsTxt AS VwAtd0SmsTxt, 
	dbo.ATD.Atd0SmsEnv AS VwAtd0SmsEnv, 
	dbo.ATD.Atd0SmsOkUsu AS VwAtd0SmsOkUsu, 
	dbo.ATD.Atd0SmsOkDtH AS VwAtd0SmsOkDtH, 
	dbo.ATD.Atd0SmsOk AS VwAtd0SmsOk
FROM         
	dbo.CAPCL WITH (NOLOCK) INNER JOIN
	dbo.ATD WITH (NOLOCK) ON dbo.CAPCL.Pc0Cod = dbo.ATD.Atd0Pc0Cod INNER JOIN
	dbo.CAPCL1 WITH (NOLOCK) ON dbo.ATD.Atd0Pc1Cod = dbo.CAPCL1.Pc1Cod AND dbo.ATD.Atd0Pc0Cod = dbo.CAPCL1.Pc0Cod INNER JOIN
	dbo.CASTA WITH (NOLOCK) ON dbo.ATD.Atd0StA0Cod = dbo.CASTA.CSta0Cod INNER JOIN
	dbo.CATPA WITH (NOLOCK) ON dbo.ATD.Atd0TpA0Cod = dbo.CATPA.CTpA0Cod INNER JOIN
	dbo.CAMDA WITH (NOLOCK) ON dbo.ATD.Atd0MdA0Cod = dbo.CAMDA.CMdA0Cod INNER JOIN
	dbo.CAREP WITH (NOLOCK) ON dbo.ATD.Atd0CvCod = dbo.CAREP.CVCOD
UNION
SELECT * FROM ATDAUX


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_ATDAgrupado] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[40] 2[5] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CAPCL"
            Begin Extent = 
               Top = 0
               Left = 233
               Bottom = 201
               Right = 423
            End
            DisplayFlags = 344
            TopColumn = 11
         End
         Begin Table = "ATD"
            Begin Extent = 
               Top = 0
               Left = 24
               Bottom = 275
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAPCL1"
            Begin Extent = 
               Top = 43
               Left = 234
               Bottom = 252
               Right = 424
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "CASTA"
            Begin Extent = 
               Top = 43
               Left = 433
               Bottom = 132
               Right = 623
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "CATPA"
            Begin Extent = 
               Top = 0
               Left = 434
               Bottom = 89
               Right = 624
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "CAMDA"
            Begin Extent = 
               Top = 89
               Left = 433
               Bottom = 178
               Right = 623
            End
            DisplayFlags = 344
            TopColumn = 2
         End
         Begin Table = "CAREP"
            Begin Extent = 
               Top = 6
               Left = 661
               Bottom = 208
               Right = 851
            End
            DisplayFlags = 280
            TopColum', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_ATDAgrupado';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'n = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 39
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2280
         Alias = 1935
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_ATDAgrupado';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_ATDAgrupado';

