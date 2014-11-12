CREATE VIEW dbo.View_PesoQtdeComponenteWBCCADPorPedido
AS
SELECT     TOP (100) PERCENT dbo.LPV.LPPED, dbo.CAPROEPSPR.CPROCOD, dbo.CAPROEPSPR.CPRO1EP, dbo.CAPROEPSPR.CPBCod, 
                      SUM(dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_Qtd) AS QtdeTotal, SUM(dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_PesTot) AS PesoTotal
FROM         dbo.CAPROEPSPR INNER JOIN
                      dbo.LPV1 ON dbo.CAPROEPSPR.CPROCOD = dbo.LPV1.CPROCOD INNER JOIN
                      dbo.LPV ON dbo.LPV1.LPEMP = dbo.LPV.LPEMP AND dbo.LPV1.LPPED = dbo.LPV.LPPED LEFT OUTER JOIN
                      dbo.View_INT_WBCCAD_ORCPRD ON dbo.LPV1.LPWBCCADORCITM = dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_Itm AND 
                      dbo.LPV.LPWBCCADORCNUM = dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_OrcNum AND 
                      dbo.CAPROEPSPR.CPBCod = dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_PrdCod
WHERE     (dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_GrpCod > 0) AND (dbo.LPV.LPENT <= CONVERT(DATETIME, '2012-03-07 00:00:00', 102))
GROUP BY dbo.CAPROEPSPR.CPBCod, dbo.LPV.LPPED, dbo.CAPROEPSPR.CPROCOD, dbo.CAPROEPSPR.CPRO1EP, dbo.LPV1.LPSalRed
HAVING      (dbo.LPV1.LPSalRed > 0)
ORDER BY QtdeTotal DESC

GO
GRANT SELECT
    ON OBJECT::[dbo].[View_PesoQtdeComponenteWBCCADPorPedido] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[26] 2[27] 3) )"
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
               Top = 6
               Left = 38
               Bottom = 125
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LPV1"
            Begin Extent = 
               Top = 6
               Left = 282
               Bottom = 125
               Right = 488
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LPV"
            Begin Extent = 
               Top = 6
               Left = 526
               Bottom = 125
               Right = 732
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "View_INT_WBCCAD_ORCPRD"
            Begin Extent = 
               Top = 6
               Left = 770
               Bottom = 188
               Right = 984
            End
            DisplayFlags = 280
            TopColumn = 3
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 4185
         Alias = 900
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
     ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PesoQtdeComponenteWBCCADPorPedido';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PesoQtdeComponenteWBCCADPorPedido';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PesoQtdeComponenteWBCCADPorPedido';

