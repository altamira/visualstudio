CREATE VIEW dbo.View_LPVSPr01
AS
SELECT     dbo.LPV1.LPEMP, dbo.LPV1.LPPED, dbo.CAPROEPSPR.CPBCod AS LPCPbCod, dbo.CAPROEPSPR.CPBCorCod AS LPCPBCorCod, SUM(ROUND(dbo.CAPROEPSPR.CPBQtd, 3)) AS LPCPbNec, 
                      SUM(ROUND(ROUND(dbo.CAPROEPSPR.CPBQtd, 3) * SUBPRODUTO.CPROPES, 3)) AS LPCPbPesTot
FROM         dbo.CAPROEPSPR INNER JOIN
                      dbo.CAPROEP ON dbo.CAPROEPSPR.CPROCOD = dbo.CAPROEP.CPROCOD AND dbo.CAPROEPSPR.CPRO1EP = dbo.CAPROEP.CPRO1EP INNER JOIN
                      dbo.LPV1 ON dbo.CAPROEPSPR.CPROCOD = dbo.LPV1.CPROCOD INNER JOIN
                      dbo.CAPRO AS SUBPRODUTO ON dbo.CAPROEPSPR.CPBCod = SUBPRODUTO.CPROCOD
WHERE     (dbo.CAPROEP.CPRO1EPPad = 1) AND (dbo.LPV1.LPWBCCADORCITM > 0) AND (dbo.LPV1.LPWBCCADGRPCOD > 0)
GROUP BY dbo.LPV1.LPEMP, dbo.LPV1.LPPED, dbo.CAPROEPSPR.CPBCod, dbo.CAPROEPSPR.CPBCorCod

GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LPVSPr01] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[16] 2[36] 3) )"
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
         Begin Table = "CAPROEPSPR"
            Begin Extent = 
               Top = 4
               Left = 603
               Bottom = 240
               Right = 793
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAPROEP"
            Begin Extent = 
               Top = 6
               Left = 1089
               Bottom = 248
               Right = 1279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LPV1"
            Begin Extent = 
               Top = 0
               Left = 297
               Bottom = 241
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SUBPRODUTO"
            Begin Extent = 
               Top = 84
               Left = 894
               Bottom = 253
               Right = 1084
            End
            DisplayFlags = 280
            TopColumn = 6
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2775
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 10260
         Alias = 2265
         Table = 2730
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
      ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LPVSPr01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LPVSPr01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LPVSPr01';

