CREATE VIEW dbo.View_PesosPedido67880
AS
SELECT     dbo.ORDFABLAN.OrdEmp AS Empresa, dbo.ORDFABLAN.OrdCod AS OP, dbo.ORDFABLAN.Ordpecli AS PedidoVenda, dbo.ORDFABLAN.OrdpecliIt AS ItemPedidoVenda, 
                      dbo.ORDFABLAN.CPROCOD AS ProdutoFinal, dbo.ORDFABLAN3.CPBCod AS Componente, CAPRO_1.CPRONOM AS DescricaoComponente,
                          (SELECT     SUM(CPROPES) AS Peso
                            FROM          dbo.CAPRO
                            WHERE      (CPROCOD = dbo.ORDFABLAN3.CPBCod)) AS PesoUnit, dbo.ORDFABLAN3.OrdCPBQtd,
                          (SELECT     SUM(CPROPES) AS Peso
                            FROM          dbo.CAPRO AS CAPRO_2
                            WHERE      (CPROCOD = dbo.ORDFABLAN3.CPBCod)) * dbo.ORDFABLAN3.OrdCPBQtd * dbo.ORDFABLAN.OrdQtd AS PesoTotal
FROM         dbo.CAPRO AS CAPRO_1 INNER JOIN
                      dbo.ORDFABLAN3 ON CAPRO_1.CPROCOD = dbo.ORDFABLAN3.CPBCod RIGHT OUTER JOIN
                      dbo.ORDFABLAN ON dbo.ORDFABLAN3.OrdEmp = dbo.ORDFABLAN.OrdEmp AND dbo.ORDFABLAN3.OrdCod = dbo.ORDFABLAN.OrdCod
WHERE     (dbo.ORDFABLAN.Ordpecli = 68073)

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[47] 4[34] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[35] 3) )"
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
         Configuration = "(H (1[60] 2) )"
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
         Left = -134
      End
      Begin Tables = 
         Begin Table = "CAPRO_1"
            Begin Extent = 
               Top = 79
               Left = 932
               Bottom = 268
               Right = 1122
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ORDFABLAN3"
            Begin Extent = 
               Top = 54
               Left = 512
               Bottom = 238
               Right = 702
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ORDFABLAN"
            Begin Extent = 
               Top = 10
               Left = 133
               Bottom = 274
               Right = 323
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
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2340
         Width = 5520
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 13770
         Alias = 2130
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PesosPedido67880';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PesosPedido67880';

