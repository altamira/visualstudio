
CREATE VIEW [dbo].[View_INT_WBCCAD_ORCPRD]
AS
SELECT     idIntegracao_OrcPrd AS INT_ORCPRD_ID, ORCNUM AS INT_ORCPRD_OrcNum, GRPCOD AS INT_ORCPRD_GrpCod, SUBGRPCOD AS INT_ORCPRD_SGrCod, 
                      ORCITM AS INT_ORCPRD_Itm, PRDCOD AS INT_ORCPRD_PrdCod, CASE WHEN CHARINDEX('#', PrdCod) > 0 THEN substring(PrdCod, 01, (CHARINDEX('#', PrdCod) 
                      - 1)) ELSE PrdCod END AS INT_ORCPRD_PrdCod_SDimens, CORCOD AS INT_ORCPRD_CorCod, PRDDSC AS INT_ORCPRD_PrdNom, ORCQTD AS INT_ORCPRD_Qtd, 
                      ORCTOT AS INT_ORCPRD_ValTot, ORCPES AS INT_ORCPRD_PesTot
FROM         WBCCAD.dbo.INTEGRACAO_ORCPRD


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_ORCPRD] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[15] 4[49] 2[6] 3) )"
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
         Begin Table = "INTEGRACAO_ORCPRD (WBCCAD.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 303
               Right = 291
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
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3150
         Width = 4035
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 6570
         Alias = 6165
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRD';

