CREATE VIEW dbo.[Pré-Cliente]
AS
SELECT     Pc0Cod AS Código, Pc0Cnpj AS CNPJ, Pc0IE AS [Inscrição Estadual], Pc0Fan AS [Nome Fantasia], Pc0Nom AS [Razão Social], Pc0End AS Endereço, Pc0Bai AS Bairro, 
                      Pc0Cep AS CEP, Pc0Cid AS Cidade, Pc0TelDdd AS [DDD do Telefone], Pc0TelNum AS [Número do Telefone], Pc0TelRam AS [Ramal do Telefone], 
                      Pc0FaxDdd AS [DDD do Fax], Pc0FaxNum AS [Número do Fax], Pc0FaxRam AS [Ramal do Fax], Pc0CvCod AS [Código do Representante], Pc0Url AS URL, 
                      Pc0Eml AS Email, Pc0Ind AS Indicação, Pc0Obs AS Observação, Pc0Pc1 AS [Último Contato], Pc0UfCod AS Estado, Pc0Prf AS [Cliente Preferencial], 
                      Pc0VisPer AS [Periodicidade das Visitas], Pc0LogTipCod AS [Código do Tipo de Logradouro do Pré-Cliente], Pc0EndNum AS [Número do Endereço], 
                      Pc0EndCpl AS [Complemento do Endereço], PC0Cla AS Classificação, Pc0Tip AS Tipo
FROM         GPIMAC_Altamira.dbo.CAPCL

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[12] 3) )"
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
         Begin Table = "CAPCL (GPIMAC_Altamira.dbo)"
            Begin Extent = 
               Top = 9
               Left = 33
               Bottom = 207
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 21
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
         Column = 1440
         Alias = 3690
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Pré-Cliente';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Pré-Cliente';

