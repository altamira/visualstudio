
-------------------------------------------------------------------------------
--sp_helptext pr_ajusta_item_nota_mov_estoque_req_faturamento
-------------------------------------------------------------------------------
--pr_ajusta_item_nota_mov_estoque_req_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajusta o Item da Nota de Saida quando não Movimenta Estoque
--                   REQUISIÇÃO DE FATURAMENTO
--                   ( Até localizar o Problema no faturamento - SFT )
--Data             : 29.09.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ajusta_item_nota_mov_estoque_req_faturamento
@cd_nota_saida int = 0
as

if @cd_nota_saida > 0
begin

  update
    nota_saida_item
  set
    cd_requisicao_faturamento = 0
  where
    cd_nota_saida = @cd_nota_saida

end


