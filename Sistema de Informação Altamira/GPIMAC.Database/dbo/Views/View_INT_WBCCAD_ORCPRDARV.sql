
CREATE VIEW [dbo].[View_INT_WBCCAD_ORCPRDARV]
AS
SELECT     INT_ORCPRDARV_COD, INT_ORCPRDARV_LPEMP, INT_ORCPRDARV_LPPED, INT_ORCPRDARV_LPSEQ, INT_ORCPRDARV_ORCNUM, INT_ORCPRDARV_GRPCOD, INT_ORCPRDARV_SUBGRPCOD, 
                      INT_ORCPRDARV_ORCITM, INT_ORCPRDARV_PRDCOD, INT_ORCPRDARV_PRDCOD_CDIMENS, INT_ORCPRDARV_PRDDSC, CASE SUBSTRING(LTRIM(RTRIM(INT_ORCPRDARV_PRDCOD)), 01, 03) 
                      WHEN 'ATR' THEN 'S' WHEN 'ALP' THEN 'S' ELSE 'N' END AS INT_ORCPRDARV_PRD_EACO, CASE SUBSTRING(LTRIM(RTRIM(INT_ORCPRDARV_PRDCOD)), 01, 03) 
                      WHEN 'TPO' THEN 'S' ELSE 'N' END AS INT_ORCPRDARV_PRD_ETINTA, INT_ORCPRDARV_NIVEL, INT_ORCPRDARV_CORCOD, INT_ORCPRDARV_ORCQTD, INT_ORCPRDARV_ORCTOT, 
                      INT_ORCPRDARV_ORCPES
FROM         dbo.View_INT_WBCCAD_ORCPRDARV_AUX01


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_ORCPRDARV] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[16] 4[47] 2[21] 3) )"
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
         Begin Table = "View_INT_WBCCAD_ORCPRDARV_AUX01"
            Begin Extent = 
               Top = 6
               Left = 100
               Bottom = 309
               Right = 386
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
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3180
         Width = 3330
         Width = 1500
         Width = 4095
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 10260
         Alias = 5085
         Table = 3390
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRDARV';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCPRDARV';

