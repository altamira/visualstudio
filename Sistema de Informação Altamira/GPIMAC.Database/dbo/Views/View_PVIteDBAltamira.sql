
CREATE VIEW [dbo].[View_PVIteDBAltamira]
AS
SELECT
	ISNULL(CAST(              vetx_Pedido                        							AS INT             ), 0  ) AS VwPVGes0Num, 
	ISNULL(CAST(              vetx_Item                          							AS SMALLINT        ), 0  ) AS VwPVGes1Ite, 
	ISNULL(CAST(              vetx_ClassificacaoFiscal           							AS CHAR(01 )       ), '' ) AS VwPVGes1CFCod, 
	ISNULL(CAST(              vetx_CodigoTributario              							AS SMALLINT        ), 0  ) AS VwPVGes1CT, 
	ISNULL(CAST(              vetx_Origem                        							AS SMALLINT        ), 0  ) AS VwPVGes1OR, 
	ISNULL(CAST(              vetx_Texto                         							AS VARCHAR(5000 )  ), '' ) AS VwPVGes1Des, 
	ISNULL(CAST(              vetx_Unidade                       							AS CHAR(02)        ), '' ) AS VwPVGes1Un, 
	ISNULL(CAST(              vetx_Quantidade												AS DECIMAL(11,04 ) ), 0  ) AS VwPVGes1Qtd, 
	ISNULL(CAST(              vetx_Peso                          							AS MONEY           ), 0  ) AS VwPVGes1Pes, 
	ISNULL(CAST(              vetx_IPI														AS SMALLMONEY      ), 0  ) AS VwPVGes1Ipi, 
	ISNULL(CAST(              vetx_Valor													AS MONEY           ), 0  ) AS VwPVGes1ValUni, 
	ISNULL(CAST(       ROUND((vetx_Quantidade * vetx_Valor), 2 )                            AS MONEY           ), 0  ) AS VwPVGes1ValTot,
	ISNULL(CAST(ROUND((ROUND((vetx_Quantidade * vetx_Valor), 2 ) * (vetx_IPI / 100 ) ), 2 ) AS MONEY           ), 0  ) AS VwPVGes1ValIpi
FROM         DBALTAMIRA.dbo.VE_TextosPedidos


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_PVIteDBAltamira] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[31] 2[20] 3) )"
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
         Begin Table = "View_GESTAO_PedidoVendaItem (DBALTAMIRA.dbo)"
            Begin Extent = 
               Top = 23
               Left = 330
               Bottom = 298
               Right = 520
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
         Column = 1440
         Alias = 2385
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PVIteDBAltamira';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_PVIteDBAltamira';

