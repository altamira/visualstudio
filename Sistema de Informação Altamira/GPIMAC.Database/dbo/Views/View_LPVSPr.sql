CREATE VIEW [dbo].[View_LPVSPr]
AS
SELECT     dbo.View_LPVSPr01.LPEMP, dbo.View_LPVSPr01.LPPED, dbo.View_LPVSPr01.LPCPbCod, SUBPRODUTO.CPRONOM AS LPCPbNom, 
                      SUBPRODUTO.CPROUNI AS LPCPbUni, SUBPRODUTO.CPROPES AS LPCPbPes, dbo.View_LPVSPr01.LPCPBCorCod, dbo.View_LPVSPr01.LPCPbNec, 
                      dbo.View_LPVSPr01.LPCPbPesTot, dbo.LPV.Lp0SaiRed AS LPCPbSai
FROM         dbo.View_LPVSPr01 INNER JOIN
                      dbo.CAPRO AS SUBPRODUTO ON dbo.View_LPVSPr01.LPCPbCod = SUBPRODUTO.CPROCOD INNER JOIN
                      dbo.LPV ON dbo.View_LPVSPr01.LPEMP = dbo.LPV.LPEMP AND dbo.View_LPVSPr01.LPPED = dbo.LPV.LPPED

GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LPVSPr] TO [interclick]
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
         Begin Table = "View_LPVSPr01"
            Begin Extent = 
               Top = 12
               Left = 103
               Bottom = 203
               Right = 293
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SUBPRODUTO"
            Begin Extent = 
               Top = 18
               Left = 687
               Bottom = 213
               Right = 877
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LPV"
            Begin Extent = 
               Top = 79
               Left = 473
               Bottom = 198
               Right = 663
            End
            DisplayFlags = 280
            TopColumn = 34
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
         Column = 3765
         Alias = 2475
         Table = 4725
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LPVSPr';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LPVSPr';

