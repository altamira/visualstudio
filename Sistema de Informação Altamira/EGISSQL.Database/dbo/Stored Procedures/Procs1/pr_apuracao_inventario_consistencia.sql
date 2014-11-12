CREATE PROCEDURE pr_apuracao_inventario_consistencia
---------------------------------------------------------------------------------------------------
--pr_apuracao_inventario_consistencia
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	        2005
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Clelson Luiz Camargo
--Banco de Dados   : SQL 
--Objetivo         : Centralizar a consistencia para apuração do inventário
--Data             : 03/03/2005
--Atualizado       : 
----------------------------------------------------------------------------------------------------------
@ic_parametro int, -- Qual a consulta
@dt_inicial   datetime, -- data inical
@dt_final     datetime -- data final
as

declare
 @cd_mes int,
 @cd_ano int

set @cd_ano = datepart(yy, @dt_final)
set @cd_mes = datepart(mm, @dt_final)
 
----------------------------------------------------------------------------------------------------------
if @ic_parametro = 0 -- Notas fiscais não emitidas
 exec pr_verifica_nota_saida_emitida 0, @dt_inicial, @dt_final

----------------------------------------------------------------------------------------------------------
else if @ic_parametro = 1 -- Fechameto de Estoque realizado
  select *
  from fechamento_mensal
  where
   cd_mes = @cd_mes and 
   cd_ano = @cd_ano and
   IsNull(ic_sce,'N') = 'N'

----------------------------------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Produtos com saldo negativo
 exec pr_produto_fechamento_saldo_negativo @cd_mes, @cd_ano, @dt_final

----------------------------------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Divergências no fechamento
 exec pr_diferenca_fechamento_produto 0, @dt_final

----------------------------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Notas Fiscais Sem Invoice
 exec pr_consulta_nota_importacao_sem_invoice_di @dt_inicial, @dt_final

----------------------------------------------------------------------------------------------------------
else if @ic_parametro = 5 -- Notas Fiscais Sem Complementar
 exec pr_consulta_nota_importacao_sem_nf_complementar @dt_inicial, @dt_final

----------------------------------------------------------------------------------------------------------
