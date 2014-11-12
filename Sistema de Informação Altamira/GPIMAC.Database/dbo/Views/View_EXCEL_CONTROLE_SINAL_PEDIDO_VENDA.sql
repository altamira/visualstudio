CREATE VIEW dbo.View_EXCEL_CONTROLE_SINAL_PEDIDO_VENDA
AS
SELECT     TOP (50) PEDIDOVENDA.LPENT AS DATAPEDIDO, CAST(PEDIDOVENDA.LPPED AS NVARCHAR(10)) + ' - ' + CLIENTE.CCNOM AS ROTULO, 
                      PEDIDOVENDA.LPPED AS PEDIDO, CLIENTE.CCNOM AS CLIENTE, PEDIDOVENDA.LPTSARED * (PARCELA.CCPg1Por / 100) AS SINAL, PEDIDOVENDA.LPTSARED, 
                      ITEMS.IPI, PEDIDOVENDA.LPTSARED + ITEMS.IPI AS TOTAL_PEDIDO, LTRIM(RTRIM(PEDIDOVENDA.LpObsPgto)) AS CONDICAOPAGTO, 
                      CASE WHEN CONDICAOPAGTO.CCPG0Si1Par = 'N' THEN 'Cobrar o valor do Imposto na 1a parcela' ELSE 'Diluir o valor dos impostos nas parcelar' END AS FORMAPAGTO
FROM         dbo.LPV AS PEDIDOVENDA INNER JOIN
                          (SELECT     LPPED, SUM((LPQUA * LPPRE) * (LPIPI / 100)) AS IPI
                            FROM          dbo.LPV1
                            GROUP BY LPPED) AS ITEMS ON PEDIDOVENDA.LPPED = ITEMS.LPPED INNER JOIN
                      dbo.CACPG AS CONDICAOPAGTO ON PEDIDOVENDA.LPPAG = CONDICAOPAGTO.CPCOD INNER JOIN
                      dbo.CACPG1 AS PARCELA ON CONDICAOPAGTO.CPCOD = PARCELA.CPCOD INNER JOIN
                      dbo.CACLI AS CLIENTE ON CLIENTE.CCCGC = PEDIDOVENDA.CCCGC
WHERE     (PARCELA.CCPg1Dia = 0)
ORDER BY DATAPEDIDO DESC, PEDIDO DESC

GO
GRANT SELECT
    ON OBJECT::[dbo].[View_EXCEL_CONTROLE_SINAL_PEDIDO_VENDA] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[24] 3) )"
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
         Begin Table = "PEDIDOVENDA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 23
         End
         Begin Table = "PARCELA"
            Begin Extent = 
               Top = 6
               Left = 257
               Bottom = 262
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CLIENTE"
            Begin Extent = 
               Top = 6
               Left = 476
               Bottom = 114
               Right = 657
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CONDICAOPAGTO"
            Begin Extent = 
               Top = 6
               Left = 695
               Bottom = 114
               Right = 876
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ITEMS"
            Begin Extent = 
               Top = 114
               Left = 476
               Bottom = 192
               Right = 657
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
         Width = 1500
         Width = 1590
         Width = 1500
         Width = 1500
         Width = 23760
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_EXCEL_CONTROLE_SINAL_PEDIDO_VENDA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'         Column = 1440
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
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_EXCEL_CONTROLE_SINAL_PEDIDO_VENDA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_EXCEL_CONTROLE_SINAL_PEDIDO_VENDA';

