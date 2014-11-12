
-------------------------------------------------------------------------------
--sp_helptext pr_ajuste_movimento_terceiro_negativo
-------------------------------------------------------------------------------
--pr_ajuste_movimento_terceiro_negativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Ajuste do Movimento de Terceiro Negativo
--Data             : 02.Setembro.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ajuste_movimento_terceiro_negativo
@cd_produto           int         = 0,
@cd_usuario           int         = 0

as

print 'foi realizado dentro do proprio relatório de movimento de terceiros'
print 'comentei o trecho lá, no parametro - 5'


--   declare @qt_nota_entrada float
-- 
--   select
--     @qt_nota_entrada = isnull(qt_movimento_terceiro,0)
-- 
--   from
--     movimento_produto_terceiro with (nolock)
-- 
--   where
--     cd_movimento_produto_terceiro = @cd_movimento_origem 
-- 
-- --   --Atualizando o Saldo
-- -- 
-- --   select 
-- --     mp.cd_movimento_produto_terceiro     as Codigo,
-- --     mp.ic_tipo_movimento                 as ic_tipo_movimento,
-- --     mp.cd_nota_saida                     as NotaSaida,
-- --     mp.dt_movimento_terceiro             as DataSaida,
-- --     mp.cd_item_nota_fiscal               as itemSaida,
-- --     isnull( mp.qt_movimento_terceiro,0 ) as QtdeSaida,
-- --     ic_perda_item_nota_saida             as Perda,
-- --     mp.cd_movimento_origem,
-- --     @qt_nota_entrada                     as 'Entrada',
-- --     0.00                                 as 'Saldo'
-- --   into
-- --     #GeraSaldo
-- -- 
-- --   from 
-- --     movimento_produto_terceiro mp with (nolock) 
-- --     left join Nota_Saida_Item nsi on nsi.cd_nota_saida      = mp.cd_nota_saida and
-- --                                      nsi.cd_item_nota_saida = mp.cd_item_nota_fiscal
-- --   where
-- --     mp.cd_movimento_origem = @cd_movimento_origem and
-- --     mp.ic_tipo_movimento   = 'S'
-- --     and isnull(mp.ic_movimento_terceiro,'S')='S'
-- -- 
-- --   declare @cd_movimento_produto_terceiro int
-- --   declare @qt_movimento_terceiro         float
-- --   declare @qt_saldo                      float
-- -- 
-- --   set @cd_movimento_produto_terceiro = 0
-- --   set @qt_saldo                      = @qt_nota_entrada
-- -- 
-- --   while exists ( select top 1 Codigo from #GeraSaldo )   
-- --   begin
-- --     select top 1
-- --       @cd_movimento_produto_terceiro = Codigo,
-- --       @qt_movimento_terceiro         = QtdeSaida
-- --     from
-- --       #GeraSaldo
-- -- 
-- --     set @qt_saldo = @qt_saldo - @qt_movimento_terceiro
-- -- 
-- -- --    select @qt_saldo
-- -- 
-- --     if @qt_saldo<0
-- --     begin
-- --       --Deleta o Movimento de Terceiro
-- --       delete from movimento_produto_terceiro 
-- --       where
-- --         cd_movimento_produto_terceiro = @cd_movimento_produto_terceiro 
-- --     end
-- -- 
-- --     delete from #GeraSaldo
-- --     where
-- --       Codigo = @cd_movimento_produto_terceiro
-- --   end
-- 
--   select 
--     mp.cd_movimento_produto_terceiro     as Codigo,
--     mp.ic_tipo_movimento                 as ic_tipo_movimento,
--     mp.cd_nota_saida                     as NotaSaida,
--     mp.dt_movimento_terceiro             as DataSaida,
--     mp.cd_item_nota_fiscal               as itemSaida,
--     isnull( mp.qt_movimento_terceiro,0 ) as QtdeSaida,
--     ic_perda_item_nota_saida             as Perda,
--     mp.cd_movimento_origem,
--     @qt_nota_entrada                     as 'Entrada',
--     0.00                                 as 'Saldo'
-- 
--   from 
--     movimento_produto_terceiro mp with (nolock) 
--     left join Nota_Saida_Item nsi on nsi.cd_nota_saida      = mp.cd_nota_saida and
--                                      nsi.cd_item_nota_saida = mp.cd_item_nota_fiscal
--   where
--     mp.cd_movimento_origem = @cd_movimento_origem and
--     mp.ic_tipo_movimento   = 'S'
--     and isnull(mp.ic_movimento_terceiro,'S')='S'
-- 
-- end


