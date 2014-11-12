
CREATE VIEW [dbo].[Relatório das Últimas Atualizações de Situação do Orçamento]
AS
SELECT     
	CONVERT(NVARCHAR(10), Orçamento.[Data do Cadastro], 103) AS [Data do Orçamento],
	ISNULL(CONVERT(NVARCHAR(10), Informações.[Data da Última Atualização], 103), '') AS [Data da Última Atualização],
	ISNULL(Orçamento.Número, '') AS Numero, 
	ISNULL(Orçamento.[Nome Fantasia], '') AS [Nome Fantasia], 
	ISNULL(dbo.Orçamento.Total, '') AS Total, 
	ISNULL(Representante.Nome, '') AS Representante,
	ISNULL((SELECT TOP 1 REPLACE(REPLACE(Observações, CHAR(13), ''), CHAR(10), '') 
	FROM [Histórico da Situação do Orçamento] AS Historico WITH (NOLOCK)
	WHERE HISTORICO.[Número do Orçamento] = Orçamento.Número
	ORDER BY Historico.[Última Atualização] DESC), '') AS [Observações],
	--CASE WHEN Historico.Observações IS NULL THEN '' ELSE Historico.Observações END AS [Observações], 
	CASE 
		WHEN Informações.[Principais Tipos de Materiais] IS NULL OR Informações.[Outros Tipos de Materiais] IS NULL 
		THEN '' ELSE Informações.[Principais Tipos de Materiais] + ' ' + LTRIM(RTRIM(Informações.[Outros Tipos de Materiais])) END AS [Tipo de Material], 
	ISNULL(CAST(Informações.[Probabilidade de Fechamento] / 100 AS FLOAT), '') AS [Probabilidade de Fechamento], 
	CASE 
		WHEN Informações.[Nome dos Principais Concorrentes] IS NULL OR Informações.[Nome de Outros Concorrentes] IS NULL 
		THEN '' ELSE Informações.[Nome dos Principais Concorrentes] + ' ' + Informações.[Nome de Outros Concorrentes] END AS Concorrentes,
	ISNULL(Informações.[Data do Próximo Contato], CAST(' ' AS NVARCHAR(10))) AS [Data do Próximo Contato], 
	ISNULL(Orçamento.[Situação Atual], '') AS [Situação]
FROM        
	dbo.Orçamento WITH (NOLOCK) INNER JOIN 
	Representante.Representante WITH (NOLOCK) ON Orçamento.[Código do Representante] = Representante.[Código] LEFT JOIN 
	dbo.[Informações Adicionais do Orçamento] AS Informações WITH (NOLOCK) ON Orçamento.Número = Informações.[Número do Orçamento]
WHERE     
	--(CAST(Informações.[Data da Última Atualização] AS DATE) >= CAST(DATEADD(WEEK, -1, GETDATE()) AS DATE))
	(CAST(Orçamento.[Data do Cadastro] AS DATE) >= CAST('2012-01-01' AS DATE)) --CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE))
	AND (Orçamento.[Situação Atual] <> 'Fechado' AND Orçamento.[Situação Atual] <> 'Perdido' AND Orçamento.[Situação Atual] <> 'Cancelado' AND Orçamento.[Situação Atual] <> 'Declinado')

























GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[24] 2[20] 3) )"
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
         Begin Table = "Histórico da Situação do Orçamento"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Informações Adicionais do Orçamento"
            Begin Extent = 
               Top = 4
               Left = 262
               Bottom = 176
               Right = 513
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Orçamento"
            Begin Extent = 
               Top = 83
               Left = 582
               Bottom = 202
               Right = 883
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 12435
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 4140
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Relatório das Últimas Atualizações de Situação do Orçamento';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'Relatório das Últimas Atualizações de Situação do Orçamento';

