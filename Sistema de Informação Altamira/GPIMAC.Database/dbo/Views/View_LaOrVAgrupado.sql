



CREATE VIEW [dbo].[View_LaOrVAgrupado]
AS
SELECT    * /*VwLo0Emp, VwLo0Ped, VwLo0Rev, VwLo0Sta, VwLo0Origem, VwLo0Dat, VwLo0DatVal, VwLo0Fei, VwPc0Cod, VwPc0Fan, VwPc0Nom, VwPc0LogTipCod, VwPc0End, 
                      VwPc0EndNum, VwPc0EndCpl, VwPc0Bai, VwPc0Cep, VwPc0Cid, VwPc0UfCod, VwPc0TelDdd, VwPc0TelNum, VwPc0TelRam, VwPc0FaxDdd, VwPc0FaxNum, 
                      VwPc0FaxRam, VwLo0Pc1Cod, VwPc1Nom, VwPc1Dep, VwPc1Cgo, VwPc1TelDdd, VwPc1TelNum, VwPc1TelRam, VwPc1FaxDdd, VwPc1FaxNum, VwPc1FaxRam, 
                      VwPc1CelDdd, VwPc1CelNum, VwPc1Eml, VwLo0CvCod, VwLo0CvNom, VwLo0CvTip, VwLo0CpCod, VwLo0CpNom, VwLo0Obs, VwLo0Ref, VwLo0ImpDsc, 
                      VwLo0TipVend, CAST('1753-01-01' AS datetime) AS VwLo0SitDat, CAST(' ' AS char(50)) AS VwLo0SitDes, CAST(0 AS int) AS VwLo0LpPPed*/
FROM         dbo.View_LaOrVAgrupadoAux01
UNION
--SELECT * FROM dbo.View_LaOrvAgrupadoWBCCAD
SELECT * FROM dbo.LAORVAUX





GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LaOrVAgrupado] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[49] 4[40] 2[5] 3) )"
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
         Begin Table = "View_LaOrVAgrupadoAux01"
            Begin Extent = 
               Top = 21
               Left = 124
               Bottom = 334
               Right = 314
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
      Begin ColumnWidths = 46
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3630
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3270
         Alias = 2895
         Table = 4350
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filt', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LaOrVAgrupado';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'er = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LaOrVAgrupado';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LaOrVAgrupado';

