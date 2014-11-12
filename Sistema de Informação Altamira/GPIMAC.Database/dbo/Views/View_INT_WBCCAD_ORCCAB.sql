CREATE VIEW dbo.View_INT_WBCCAD_ORCCAB
AS
SELECT     WBCCAD.dbo.INTEGRACAO_ORCCAB.idIntegracao_OrcCab AS INT_ORCCAB_ID, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCNUM AS INT_ORCCAB_OrcNum, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.SITCOD AS INT_ORCCAB_SitCod, dbo.View_INT_WBCCAD_ORCSIT.INT_ORCSIT_SitCod AS INT_ORCCAB_SitCod2, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCALTDTH AS INT_ORCCAB_SitDtHAlt, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALVND AS INT_ORCCAB_OrcValVnd, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALLST AS INT_ORCCAB_OrcValLST, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALINV AS INT_ORCCAB_OrcValINV, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALLUC AS INT_ORCCAB_OrcValLUC, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALEXP AS INT_ORCCAB_OrcValEXP, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALCOM AS INT_ORCCAB_OrcValCOM, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCPERCOM AS INT_ORCCAB_OrcPerCom, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.REPCOD AS INT_ORCCAB_RepCod, WBCCAD.dbo.INTEGRACAO_ORCCAB.CLICOD AS INT_ORCCAB_CliCod, 
                      ISNULL(WBCCAD.dbo.INTEGRACAO_ORCCAB.CLICOD, 0) AS INT_ORCCAB_CliCodVal, WBCCAD.dbo.INTEGRACAO_ORCCAB.CLINOM AS INT_ORCCAB_CliNom, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.CLICONCOD AS INT_ORCCAB_CliConCod, ISNULL(WBCCAD.dbo.INTEGRACAO_ORCCAB.CLICONCOD, 0) 
                      AS INT_ORCCAB_CliConCodVal, WBCCAD.dbo.INTEGRACAO_ORCCAB.CLICON AS INT_ORCCAB_CliConNom, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALTRP AS INT_ORCCAB_OrcValTRP, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALEMB AS INT_ORCCAB_OrcValEmb, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCVALMON AS INT_ORCCAB_OrcValMon, WBCCAD.dbo.INTEGRACAO_ORCCAB.PGTCOD AS INT_ORCCAB_PgtCod, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.TIPMONCOD AS INT_ORCCAB_TipMonCod, WBCCAD.dbo.INTEGRACAO_ORCCAB.PRZENT AS INT_ORCCAB_OrcPrzEnt, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCBAS1 AS INT_ORCCAB_OrcBas1, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCBAS2 AS INT_ORCCAB_OrcBas2, 
                      WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCBAS3 AS INT_ORCCAB_OrcBas3, WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCPGT AS INT_ORCCAB_OrcPgt
FROM         WBCCAD.dbo.INTEGRACAO_ORCCAB INNER JOIN
                      dbo.View_INT_WBCCAD_ORCSIT ON WBCCAD.dbo.INTEGRACAO_ORCCAB.ORCNUM = dbo.View_INT_WBCCAD_ORCSIT.INT_ORCSIT_OrcNum

GO
GRANT SELECT
    ON OBJECT::[dbo].[View_INT_WBCCAD_ORCCAB] TO [interclick]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[18] 2[20] 3) )"
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
         Begin Table = "INTEGRACAO_ORCCAB (WBCCAD.dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 342
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "View_INT_WBCCAD_ORCSIT"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 309
               Right = 462
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
      Begin ColumnWidths = 9
         Width = 284
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
         Column = 5385
         Alias = 4740
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCCAB';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_INT_WBCCAD_ORCCAB';

