


CREATE VIEW [dbo].[Item do Pedido de Venda]
AS
SELECT     
	ITM.LPEMP AS Empresa, 
	ITM.LPPED AS [Número do Pedido de Venda], 
	ITM.CPROCOD AS [Código do Produto], 
	GPIMAC_Altamira.dbo.CAPRO.CPRONOM AS Descrição, 
	CAST(ITM.LPQUA AS DECIMAL(10,2)) AS Quantidade, 
	ITM.CCorCod AS Cor,
	CAST(ITM.LPPRE AS MONEY) AS [Preço Unitário], 
	CAST(ITM.LPQUA * ITM.LPPRE AS MONEY) AS [Valor do Item], 
	(ITM.LPIPI / 100) AS [Aliquota de IPI], 
	CAST((ITM.LPQUA * ITM.LPPRE) * (ITM.LPIPI / 100) AS MONEY) AS [Valor do IPI], 
	ITM.Lp1DesDet AS [Descrição Detalhada], 
	ITM.LPSAI AS [Data de Entrega]
FROM         
	GPIMAC_Altamira.dbo.LPV1 AS ITM WITH (NOLOCK) INNER JOIN
	GPIMAC_Altamira.dbo.CAPRO ON ITM.CPROCOD = GPIMAC_Altamira.dbo.CAPRO.CPROCOD




GO
GRANT SELECT
    ON OBJECT::[dbo].[Item do Pedido de Venda] TO [altanet]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "Item do Pedido de Venda"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAPRO (GPIMAC_Altamira.dbo)"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 125
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 37
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
         Width = 4050
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
         Column = 4800
         Alias = 2175
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Item do Pedido de Venda';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Item do Pedido de Venda';

