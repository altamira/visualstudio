
CREATE VIEW [dbo].[View_INT_WBCCAD_ORCPRDARV_AUX01]
AS
SELECT     TOP (100) PERCENT WBCCAD.dbo.INTEGRACAO_ORCPRDARV.idIntegracao_OrcPrdArv AS INT_ORCPRDARV_COD, 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCNUM AS INT_ORCPRDARV_ORCNUM, WBCCAD.dbo.INTEGRACAO_ORCPRDARV.GRPCOD AS INT_ORCPRDARV_GRPCOD, 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.SUBGRPCOD AS INT_ORCPRDARV_SUBGRPCOD, WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCITM AS INT_ORCPRDARV_ORCITM, 
                      LTRIM(RTRIM(WBCCAD.dbo.INTEGRACAO_ORCPRDARV.PRDCOD)) AS INT_ORCPRDARV_PRDCOD, ISNULL(LTRIM(RTRIM(dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_PrdCod)), 
                      LTRIM(RTRIM(WBCCAD.dbo.INTEGRACAO_ORCPRDARV.PRDCOD))) AS INT_ORCPRDARV_PRDCOD_CDIMENS, WBCCAD.dbo.INTEGRACAO_ORCPRDARV.PRDDSC AS INT_ORCPRDARV_PRDDSC, 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCPRDARV_NIVEL AS INT_ORCPRDARV_NIVEL, WBCCAD.dbo.INTEGRACAO_ORCPRDARV.CORCOD AS INT_ORCPRDARV_CORCOD, 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCQTD AS INT_ORCPRDARV_ORCQTD, WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCTOT AS INT_ORCPRDARV_ORCTOT, 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCPES AS INT_ORCPRDARV_ORCPES, ISNULL(dbo.LPV.LPEMP, '') AS INT_ORCPRDARV_LPEMP, ISNULL(dbo.LPV.LPPED, 0) 
                      AS INT_ORCPRDARV_LPPED, ISNULL(dbo.LPV1.LPSEQ, 0) AS INT_ORCPRDARV_LPSEQ
FROM         dbo.View_INT_WBCCAD_ORCPRD RIGHT OUTER JOIN
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV LEFT OUTER JOIN
                      dbo.LPV1 INNER JOIN
                      dbo.LPV ON dbo.LPV1.LPEMP = dbo.LPV.LPEMP AND dbo.LPV1.LPPED = dbo.LPV.LPPED AND dbo.LPV.LPEtSitRed <> 'CANCELADO' ON 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.GRPCOD = dbo.LPV1.LPWBCCADGRPCOD AND WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCITM = dbo.LPV1.LPWBCCADORCITM AND 
                      WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCNUM = dbo.LPV.LPWBCCADORCNUM ON 
                      dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_SGrCod = WBCCAD.dbo.INTEGRACAO_ORCPRDARV.SUBGRPCOD AND 
                      dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_GrpCod = WBCCAD.dbo.INTEGRACAO_ORCPRDARV.GRPCOD AND 
                      dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_OrcNum = WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCNUM AND 
                      dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_Itm = WBCCAD.dbo.INTEGRACAO_ORCPRDARV.ORCITM AND 
                      dbo.View_INT_WBCCAD_ORCPRD.INT_ORCPRD_PrdCod_SDimens = WBCCAD.dbo.INTEGRACAO_ORCPRDARV.PRDCOD
ORDER BY INT_ORCPRDARV_COD


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_ORCPRDARV_AUX01] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[41] 2[33] 3) )"
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
         Begin Table = "View_INT_WBCCAD_ORCPRD"
            Begin Extent = 
               Top = 1
               Left = 445
               Bottom = 241
               Right = 704
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "INTEGRACAO_ORCPRDARV (WBCCAD.dbo)"
            Begin Extent = 
               Top = 4
               Left = 27
               Bottom = 269
               Right = 289
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LPV1"
            Begin Extent = 
               Top = 448
               Left = 732
               Bottom = 568
               Right = 922
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LPV"
            Begin Extent = 
               Top = 275
               Left = 587
               Bottom = 395
               Right = 777
            End
            DisplayFlags = 280
            TopColumn = 56
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4410
         Alias = 6150
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 13', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRDARV_AUX01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'50
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRDARV_AUX01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRDARV_AUX01';

