
-------------------------------------------------------------------------------
--sp_helptext pr_limpeza_tabela_basicas_nova_empresa
-------------------------------------------------------------------------------
--pr_limpeza_tabela_basicas_nova_empresa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Limpeza das tabelas básicas para início de uma nova empresa
--                   Somente as  tabelas de Movimentação
--
--Data             : 11.05.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_limpeza_tabela_basicas_nova_empresa
as

--Proposta Comercial

delete from Consulta_Item_Lote
delete from Consulta_Itens_Desconto
delete from Consulta_Item_Perda
delete from Consulta_Item_Orcamento_Furo
delete from Consulta_Historico
delete from Consulta_Item_REPNET
delete from Consulta_Cond_Pagto
delete from Consulta_Item_Orcamento_Categoria
delete from Consulta_Exportacao
delete from Consulta_Item_Composicao
delete from Consulta_Negociacao
delete from Consulta_Item_Servico_Externo
delete from Consulta_Caract_Tecnica_CQ
delete from Consulta_Item_Orcamento
delete from Consulta_Item_Orcamento_Alojamento
delete from Consulta_Dinamica_Item
delete from Consulta_Item_Observacao
delete from Consulta_Parcela
delete from Consulta_Item_Orcamento_Servico_Manual
delete from Consulta_Item_Texto
delete from Consulta_Item_Orcamento_Proposta
delete from Consulta_Itens_Acessorio
delete from Consulta_Item_Orcamento_Refrigeracao
delete from Consulta_Item_Embalagem
delete from Consulta_Contato
delete from Consulta_Item_Orcamento_Bucha_Coluna
delete from Consulta_Documento
delete from Consulta_Itens_Grade
delete from Consulta_Item_Componente
delete from Consulta_Item_Estampo
delete from Consulta_Dinamica
delete from Consulta_Item_Orcamento_Furo_Adicional
delete from Consulta_Itens
delete from Consulta

--Pedido de Venda

delete from Pedido_Venda_Item_Historico_Custo
delete from Pedido_Venda_Impressao
delete from Pedido_Venda_Estrutura_Venda
delete from Pedido_Venda_Item_Lote
delete from Pedido_Venda_Item_Especial
delete from Pedido_Venda_Item_Separacao
delete from Pedido_Venda_Item_Observacao
delete from Pedido_Venda_Parcela
delete from Pedido_Venda_Item_SMO
delete from Pedido_Venda_Historico
delete from Pedido_Venda_Cond_Pagto
delete from Pedido_Venda_Item_Embalagem
delete from Pedido_Venda_Item_Grade
delete from Pedido_Venda_SMO
delete from Pedido_Venda_Agrupamento
delete from Pedido_Venda_Documento
delete from Pedido_Venda_Item_Acessorio
delete from Pedido_Venda_Composicao
delete from pedido_venda_programacao
delete from Pedido_Venda_Item_Desconto
delete from Pedido_Venda_Exportacao
delete from Pedido_Venda_Item
delete from Pedido_Venda

--Nota de Saída

delete from Nota_Saida_Classificacao
delete from Nota_Saida_Complemento
delete from Nota_Saida_Cond_Pagto
delete from Nota_Saida_Contabil
delete from Nota_Saida_Credito
delete from Nota_Saida_Devolucao
delete from Nota_Saida_Endereco_Entrega
delete from Nota_Saida_Entrada
delete from Nota_Saida_Entrada_Item
delete from Nota_Saida_Entrega
delete from Nota_Saida_Imposto
delete from nota_saida_item_devolucao
delete from Nota_Saida_Item_Lote
delete from Nota_Saida_Item_Registro
delete from Nota_Saida_Item

--Nota_Saida_LayOut

delete from Nota_Saida_Parcela
delete from Nota_Saida_Registro
delete from Nota_Saida

--Documentos a Receber

delete from Documento_Receber_Centro_Custo
delete from Documento_Receber_Contabil
delete from Documento_Receber_Desconto
delete from Documento_Receber_Historico
delete from Documento_Receber_Pagamento
delete from Documento_Receber_Plano_Financ
delete from Documento_Receber

--Cotação

delete from cotacao_item
delete from cotacao

--Prestacao de Contas

delete from Prestacao_Conta_Diaria
delete from Prestacao_Conta_Moeda
delete from Prestacao_Conta_Quilometragem
delete from Prestacao_Conta_Composicao
delete from Prestacao_Conta_Contabil
delete from Prestacao_Conta_Aprovacao
delete from Prestacao_Conta

--Solicitacao de Adiantamento

delete from Solicitacao_Adiantamento_Aprovacao
delete from Solicitacao_Adiantamento_Moeda
delete from Solicitacao_Adiantamento_Baixa
delete from Solicitacao_Adiantamento_Contabil
delete from Solicitacao_Adiantamento

--Solicitação de Pagmento

delete from Solicitacao_Pagamento_Contabil
delete from Solicitacao_Pagamento_Confidencial
delete from Solicitacao_Pagamento_Aprovacao
delete from Solicitacao_Pagamento_Composicao
delete from Solicitacao_Pagamento_Baixa
delete from Solicitacao_Pagamento

--Autorização de Pagamento

delete from Autorizacao_Pagamento_Contabil
delete from Autorizacao_Pagamento

--Plano Financeiro

delete from plano_financeiro_saldo
delete from plano_financeiro_movimento

--Requisição Interna / Requisição de Compra / etc..

delete from Requisicao_Compra_Aprovacao
delete from Requisicao_Compra_Fornecedor
delete from Requisicao_Compra_Item
delete from Requisicao_Compra

delete from Requisicao_Fabricacao_Item
delete from Requisicao_Fabricacao

delete from Requisicao_Faturamento_Item
delete from Requisicao_Faturamento

delete from Requisicao_Interna_Item
delete from Requisicao_Interna

delete from Requisicao_Manutencao_Composicao
delete from Requisicao_Manutencao

delete from Requisicao_Treinamento_Composicao
delete from Requisicao_Treinamento

delete from Requisicao_Vaga_Composicao
delete from Requisicao_Vaga

delete from Requisicao_Viagem_Aprovacao
delete from Requisicao_Viagem_Composicao
delete from Requisicao_Viagem_Prestacao
delete from Requisicao_Viagem

--Pedido de Compra

delete from Pedido_Compra_Aprovacao
delete from Pedido_Compra_Follow
delete from Pedido_Compra_Historico
delete from Pedido_Compra_Item
delete from Pedido_Compra

--Nota de Entrada

delete from Nota_Entrada_Contabil
delete from Nota_entrada_Imposto
delete from Nota_Entrada_Parcela
delete from Nota_Entrada_Peps
delete from Nota_Entrada_Registro
delete from Nota_Entrada_Retencao_Imposto
delete from Nota_Entrada_Item_Registro
delete from Nota_Entrada_Item
delete from Nota_Entrada

--Contas a Pagar

delete from Documento_Pagar_Centro_Custo
delete from Documento_Pagar_Cod_Barra
delete from Documento_Pagar_Contabil
delete from Documento_Pagar_Doc
delete from Documento_Pagar_Imposto
delete from Documento_Pagar_Pagamento
delete from Documento_Pagar_Plano_Financ
delete from Documento_Pagar

--Movimento Financeiro

delete from conta_banco_lancamento

--Movimentação Estoque

delete from movimento_composicao
delete from movimento_estoque
delete from movimento

--Processo de Produção

delete from Processo_Producao_Adicao
delete from Processo_Producao_Apontamento
delete from Processo_Producao_Embalagem
delete from Processo_Producao_Fase_Apontamento
delete from Processo_Producao_Ferramenta
delete from Processo_Producao_Guia_Fio
delete from Processo_Producao_Inspecao
delete from Processo_Producao_Parada
delete from Processo_Producao_Pedido
delete from Processo_Producao_Revisao
delete from Processo_Producao_Teste
delete from Processo_Producao_Texto
delete from Processo_Producao_Componente
delete from Processo_Producao_Composicao
delete from Processo_Producao_Composicao_Placa
delete from Processo_Producao

--Movimento de caixa

delete from Movimento_Caixa_Composicao
delete from Movimento_Caixa_Item
delete from Movimento_Caixa_Parcela
delete from Movimento_Caixa_Pedido
delete from Movimento_Caixa

--Pedido de Importação

delete from Pedido_Importacao_CartaCredito
delete from Pedido_Importacao_Despesa
delete from Pedido_Importacao_Documento
delete from Pedido_Importacao_Entreposto
delete from Pedido_Importacao_Frete
delete from Pedido_Importacao_Historico
delete from Pedido_Importacao_Item
delete from Pedido_Importacao_Proforma
delete from Pedido_Importacao_Seguro
delete from Pedido_Importacao_Texto
delete from Pedido_Importacao

--Pedido de Exportação


delete from Pedido_Exportacao_Contabil
delete from Pedido_Exportacao_Documento
delete from Pedido_Exportacao_Financeiro

--Embarque

delete from Embarque_Comissao
delete from Embarque_Contabil
delete from Embarque_Despesa
delete from Embarque_Financeiro
delete from Embarque_Importacao
delete from Embarque_Importacao_Comissao
delete from Embarque_Importacao_Contabil
delete from Embarque_Importacao_Despesa
delete from Embarque_Importacao_Financeiro
delete from Embarque_Importacao_Item
delete from Embarque_Importacao_Parcela
delete from Embarque_Item
delete from Embarque_Parcela
delete from Embarque

--Invoice

delete from Invoice_Item
delete from Invoice

--DI

delete from Di_Despesa
delete from Di_Item
delete from Di_Siscomex
delete from Di

--Cheque

delete from Cheque_Pagar
delete from cheque_receber_composicao
delete from Cheque_receber
delete from Cheque_Terceiro

--Contrato

delete from Contrato_Cambio
delete from Contrato_Cobranca

delete from Contrato_Concessao_Cancelado
delete from Contrato_Concessao_Composicao
delete from Contrato_Concessao_Objeto
delete from Contrato_Concessao_Status
delete from Contrato_Concessao

delete from Contrato_Forn_It_Mes_Liberacao
delete from Contrato_Fornecimento_Item_Mes
delete from Contrato_Fornecimento_Item
delete from Contrato_Fornecimento

delete from Contrato_Imovel
delete from Contrato_Manutencao_Composicao
delete from Contrato_Manutencao
delete from Contrato_Pagar
delete from Contrato_Plano
delete from Contrato_Plano_Composicao
delete from Contrato_Radio
delete from Contrato_Servico_Composicao
delete from Contrato_Servico_Reajuste
delete from Contrato_Servico

delete from fechamento_mensal

--Lote

delete from Lote_Contabil
delete from Lote_Contabil_Movimento
delete from Lote_Contabil_Padrao
delete from Lote_Numeracao
delete from Lote_Produto_Item
delete from Lote_Produto
delete from Lote_Produto_Saida
delete from Lote_Produto_Saldo
delete from Lote_Receber

--Nota de crédito

delete from Nota_credito_item
delete from Nota_credito

--Nota de Débito

delete from Nota_Debito_Contabil
delete from Nota_Debito_Despesa
delete from Nota_Debito_Despesa_Composicao
delete from Nota_Debito

