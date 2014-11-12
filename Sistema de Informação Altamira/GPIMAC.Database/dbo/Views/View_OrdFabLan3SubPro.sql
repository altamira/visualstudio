
CREATE VIEW [dbo].[View_OrdFabLan3SubPro]
AS
SELECT     dbo.ORDFABLAN3.OrdEmp, dbo.ORDFABLAN3.OrdCod, dbo.ORDFABLAN3.CPBCod, dbo.CAPROEPSPR.CPBCod AS CPBSubCod, 
                      CAPRO_CPBSUBPRO.CPRONOM AS CPBSubNom, dbo.CAPROEPSPR.CPBQtd AS CPBSubQtd, CAPRO_CPBSUBPRO.CPROUNI AS CPBSubUni, 
                      ROUND(dbo.ORDFABLAN3.OrdCPBQtd * dbo.CAPROEPSPR.CPBQtd, 3) AS CPBSubNec, dbo.CAPROEPSPR.CPBLrcGer AS CPBSubLrcGer, 
                      dbo.CAPROEPSPR.CPBLrcGerEmp AS CPBSubLrcGerEmp, dbo.CAPROEPSPR.CPBLrcGerNum AS CPBSubLrcGerNum, 
                      dbo.CAPROEPSPR.CPBLrcGerSeq AS CPBSubLrcGerSeq
FROM         dbo.CAPROEP INNER JOIN
                      dbo.CAPROEPSPR ON dbo.CAPROEP.CPROCOD = dbo.CAPROEPSPR.CPROCOD AND dbo.CAPROEP.CPRO1EP = dbo.CAPROEPSPR.CPRO1EP INNER JOIN
                      dbo.CAPRO AS CAPRO_CPBSUBPRO ON dbo.CAPROEPSPR.CPBCod = CAPRO_CPBSUBPRO.CPROCOD RIGHT OUTER JOIN
                      dbo.ORDFABLAN3 ON dbo.CAPROEPSPR.CPROCOD = dbo.ORDFABLAN3.CPBCod
WHERE     (dbo.CAPROEP.CPRO1EPPad = 1)


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_OrdFabLan3SubPro] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[34] 2[6] 3) )"
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
         Begin Table = "CAPROEP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAPROEPSPR"
            Begin Extent = 
               Top = 11
               Left = 365
               Bottom = 255
               Right = 555
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAPRO_CPBSUBPRO"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 331
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ORDFABLAN3"
            Begin Extent = 
               Top = 133
               Left = 588
               Bottom = 252
               Right = 778
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2700
         Alias = 2430
         Table = 3075
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_OrdFabLan3SubPro';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_OrdFabLan3SubPro';

