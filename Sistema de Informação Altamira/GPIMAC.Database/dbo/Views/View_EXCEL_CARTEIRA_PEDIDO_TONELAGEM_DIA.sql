CREATE VIEW dbo.View_EXCEL_CARTEIRA_PEDIDO_TONELAGEM_DIA
AS
SELECT     TOP (100) PERCENT PEDIDOITEM.ENTREGA, CAST(PEDIDO.LPPED AS NVARCHAR) + N' - ' + CLIENTE.CCNOM AS [PEDIDO.CLIENTE], PRODUTO.PESO
FROM         dbo.CACLI AS CLIENTE INNER JOIN
                      dbo.LPV AS PEDIDO ON CLIENTE.CCCGC = PEDIDO.CCCGC INNER JOIN
                          (SELECT     LPEMP AS EMPRESA, LPPED AS PEDIDO, MAX(CASE YEAR(LPSAI) WHEN 1753 THEN 0 ELSE LPSAI END) AS ENTREGA
                            FROM          dbo.LPV1
                            WHERE      (LPSalRed > 0)
                            GROUP BY LPEMP, LPPED) AS PEDIDOITEM ON PEDIDOITEM.EMPRESA = PEDIDO.LPEMP AND PEDIDOITEM.PEDIDO = PEDIDO.LPPED INNER JOIN
                          (SELECT     ORCNUM AS ORCAMENTO, SUM(ORCPES) AS PESO
                            FROM          WBCCAD.dbo.INTEGRACAO_ORCPRD AS ORCPRD
                            WHERE      (GRPCOD > 0)
                            GROUP BY ORCNUM) AS PRODUTO ON PEDIDO.LPWBCCADORCNUM = PRODUTO.ORCAMENTO
ORDER BY PEDIDOITEM.ENTREGA

GO
GRANT SELECT
    ON OBJECT::[dbo].[View_EXCEL_CARTEIRA_PEDIDO_TONELAGEM_DIA] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[48] 4[14] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[57] 2[19] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
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
         Begin Table = "CLIENTE"
            Begin Extent = 
               Top = 111
               Left = 247
               Bottom = 401
               Right = 426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PEDIDO"
            Begin Extent = 
               Top = 17
               Left = 17
               Bottom = 315
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PEDIDOITEM"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 99
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PRODUTO"
            Begin Extent = 
               Top = 6
               Left = 455
               Bottom = 84
               Right = 636
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
      Begin ColumnWidths = 15
         Width = 284
         Width = 2160
         Width = 4545
         Width = 1845
         Width = 2850
         Width = 1500
         Width = 2355
         Width = 2160
         Width = 4380
         Width = 5190
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 8535
         Alias = 3225
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         S', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_EXCEL_CARTEIRA_PEDIDO_TONELAGEM_DIA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_EXCEL_CARTEIRA_PEDIDO_TONELAGEM_DIA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_EXCEL_CARTEIRA_PEDIDO_TONELAGEM_DIA';

