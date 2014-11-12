
CREATE VIEW [dbo].[View_CaPlCDetalhado]
AS
SELECT     
	LTRIM(RTRIM(Caplc0Cod)) AS VwCaPlCDet0Cod, 
	LTRIM(RTRIM(Caplc0Tip)) AS VwCaPlCDet0Tip,
	LTRIM(RTRIM(CaPlc0Sel)) AS VwCaPlCDet0Sel,
    (SELECT     TOP (1) LTRIM(RTRIM(Caplc0Nom))
     FROM          dbo.CAPLC AS PLC
     WHERE      (LEFT(LTRIM(RTRIM(Caplc0Cod)), 4) = LEFT(LTRIM(RTRIM(CAPLC.Caplc0Cod)), 4)) ORDER BY Caplc0Cod ASC) AS VwCaPlCDet0Grupo,
    (SELECT     TOP (1) LTRIM(RTRIM(Caplc0Nom)) 
     FROM          dbo.CAPLC AS PLC
     WHERE      (LEFT(LTRIM(RTRIM(Caplc0Cod)), 7) = LEFT(LTRIM(RTRIM(CAPLC.Caplc0Cod)), 7)) ORDER BY Caplc0Cod ASC) AS VwCaPlCDet0Subgrupo, 
     LTRIM(RTRIM(Caplc0Nom)) AS VwCaPlCDet0Conta,
     LTRIM(RTRIM(Caplc0Des)) AS VwCaPlCDet0DesDet
FROM         dbo.CAPLC AS CAPLC




GO
GRANT SELECT
    ON OBJECT::[dbo].[View_CaPlCDetalhado] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[21] 4[26] 2[35] 3) )"
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
         Begin Table = "CAPLC"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 165
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 1
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
         Column = 2565
         Alias = 2790
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_CaPlCDetalhado';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_CaPlCDetalhado';

