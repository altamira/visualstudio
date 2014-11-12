

CREATE VIEW [dbo].[View_GESTAO_PedidoVenda]
AS
SELECT     dbo.VE_Pedidos.vepe_Pedido AS Numero, dbo.VE_Pedidos.vepe_Projeto AS Projeto, dbo.VE_Pedidos.vepe_Orcamento AS Orcamento, 
                      dbo.VE_Pedidos.vepe_PedidoCliente AS PedidoCompra, dbo.VE_Pedidos.vepe_TipoPedido AS TipoPedido, dbo.VE_Pedidos.vepe_DataPedido AS DataPedido, 
                      dbo.VE_Pedidos.vepe_DataEntrega AS DataEntrega, dbo.VE_ClientesNovo.vecl_Codigo AS CNPJ, dbo.VE_ClientesNovo.vecl_Inscricao AS Inscricao, 
                      dbo.VE_ClientesNovo.vecl_Abreviado AS NomeFantasia, dbo.VE_ClientesNovo.vecl_Nome AS RazaoSocial, dbo.VE_ClientesNovo.vecl_Endereco AS Endereco, 
                      dbo.VE_ClientesNovo.vecl_Bairro AS Bairro, dbo.VE_ClientesNovo.vecl_Cidade AS Cidade, dbo.VE_ClientesNovo.vecl_Estado AS Estado, 
                      dbo.VE_ClientesNovo.vecl_Cep AS CEP, dbo.VE_ClientesNovo.vecl_Contato AS Contato, dbo.VE_ClientesNovo.vecl_Departamento AS Departamento, 
                      dbo.VE_ClientesNovo.vecl_DDD AS DDD, dbo.VE_ClientesNovo.vecl_Telefone AS Telefone, dbo.VE_ClientesNovo.vecl_Email AS Email, 
                      dbo.VE_ClientesNovo.vecl_TipoPessoa AS TipoPessoa, dbo.VE_ClientesNovo.vecl_CobEndereco AS CobrancaEndereco, 
                      dbo.VE_ClientesNovo.vecl_CobBairro AS CobrancaBairro, dbo.VE_ClientesNovo.vecl_CobCidade AS CobrancaCidade, 
                      dbo.VE_ClientesNovo.vecl_CobEstado AS CobrancaEstado, dbo.VE_ClientesNovo.vecl_CobCep AS CobrancaCEP, 
                      dbo.VE_ClientesNovo.vecl_CobDDD AS CobrancaDDD, dbo.VE_ClientesNovo.vecl_CobTelefone AS CobrancaTelefone, 
                      dbo.VE_ClientesNovo.vecl_CobEmail AS CobrancaEmail, dbo.VE_Representantes.verp_Codigo AS Representante, 
                      dbo.VE_Representantes.verp_RazaoSocial AS NomeRepresentante, dbo.VE_Pedidos.vepe_Comissao AS Comissao, 
                      dbo.VE_Pedidos.vepe_EntEndereco AS EntregaEndereco, dbo.VE_Pedidos.vepe_EntBairro AS EntregaBairro, dbo.VE_Pedidos.vepe_EntCidade AS EntregaCidade, 
                      dbo.VE_Pedidos.vepe_EntEstado AS EntregaEstado, dbo.VE_Pedidos.vepe_EntCEP AS EntregaCEP, dbo.VE_Pedidos.vepe_EntDDD AS EntregaDDD, 
                      dbo.VE_Pedidos.vepe_EntTelefone AS EntregaTelefone, dbo.VE_Pedidos.vepe_EntCGC AS EntregaCNPJ, dbo.VE_Pedidos.vepe_EntInscricao AS EntregaInscricao, 
                      dbo.VE_Acabamento.veac_Descricao AS Acabamento, dbo.VE_Montagem.vemo_Descricao AS Montagem, dbo.VE_Pedidos.vepe_TipoEmbalagem AS Embalagem, 
                      dbo.VE_Transporte.vett_Descricao AS TipoTransporte, dbo.VE_Transportadoras.vetr_Nome AS Transportadora, dbo.VE_Montador.vemo_Descricao AS Montador, 
                      dbo.VE_Pedidos.vepe_Observacao AS Observacao, dbo.VE_Pedidos.vepe_AliqICMS AS ICMS, dbo.VE_Pedidos.vepe_ValorVenda AS ValorVenda, 
                      dbo.VE_Pedidos.vepe_ValorServico AS ValorServico, dbo.VE_Pedidos.vepe_ValorIPI AS ValorIPI, dbo.VE_Pedidos.vepe_Peso AS Peso, 
                      dbo.VE_Pedidos.vepe_ValorTabela AS ValorTabela, dbo.VE_Pedidos.vepe_DataSaida AS DataSaida, dbo.VE_Pedidos.vepe_DataMontagem AS DataMontagem
FROM         dbo.VE_Pedidos INNER JOIN
                      dbo.VE_ClientesNovo ON dbo.VE_Pedidos.vepe_Cliente = dbo.VE_ClientesNovo.vecl_Codigo INNER JOIN
                      dbo.VE_Representantes ON dbo.VE_Pedidos.vepe_Representante = dbo.VE_Representantes.verp_Codigo LEFT OUTER JOIN
                      dbo.VE_Montagem ON dbo.VE_Pedidos.vepe_TipoMontagem = dbo.VE_Montagem.vemo_Codigo LEFT OUTER JOIN
                      dbo.VE_Transportadoras ON dbo.VE_Pedidos.vepe_Transportadora = dbo.VE_Transportadoras.vetr_Codigo LEFT OUTER JOIN
                      dbo.VE_Acabamento ON dbo.VE_Pedidos.vepe_TipoAcabamento = dbo.VE_Acabamento.veac_Codigo LEFT OUTER JOIN
                      dbo.VE_Transporte ON dbo.VE_Pedidos.vepe_TipoTransporte = dbo.VE_Transporte.vett_Codigo LEFT OUTER JOIN
                      dbo.VE_Montador ON dbo.VE_Pedidos.vepe_Montador = dbo.VE_Montador.vemo_Codigo
--WHERE     (dbo.VE_Pedidos.vepe_Pedido = 67651)



GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[31] 2[10] 3) )"
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
         Begin Table = "VE_Pedidos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 197
               Right = 267
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "VE_ClientesNovo"
            Begin Extent = 
               Top = 162
               Left = 519
               Bottom = 346
               Right = 739
            End
            DisplayFlags = 280
            TopColumn = 29
         End
         Begin Table = "VE_Representantes"
            Begin Extent = 
               Top = 0
               Left = 719
               Bottom = 119
               Right = 909
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VE_Transportadoras"
            Begin Extent = 
               Top = 57
               Left = 633
               Bottom = 176
               Right = 823
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VE_Montagem"
            Begin Extent = 
               Top = 162
               Left = 766
               Bottom = 281
               Right = 956
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VE_Acabamento"
            Begin Extent = 
               Top = 209
               Left = 443
               Bottom = 328
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VE_Transporte"
            Begin Extent = 
               Top = 213
               Left = 519
               Bottom = 332
               Right = 70', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_GESTAO_PedidoVenda';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'9
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VE_Montador"
            Begin Extent = 
               Top = 216
               Left = 130
               Bottom = 335
               Right = 320
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
      Begin ColumnWidths = 55
         Width = 284
         Width = 1500
         Width = 1905
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1770
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 4275
         Width = 3570
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
         Width = 3045
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
         Width = 2235
         Width = 1500
         Width = 2670
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
         Column = 2025
         Alias = 2535
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_GESTAO_PedidoVenda';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_GESTAO_PedidoVenda';

