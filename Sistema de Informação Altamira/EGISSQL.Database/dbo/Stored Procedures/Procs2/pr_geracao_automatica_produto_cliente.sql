
--sp_helptext pr_geracao_automatica_produto_cliente

-------------------------------------------------------------------------------
--pr_geracao_automatica_produto_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática da Tabela Produto_Cliente ( Kardex )
--                   com base na tabela de Nota_Saida e Nota_Saida_Item
--                   Realmente o que foi faturamento para o Cliente
--
--Data             : 11.12.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_automatica_produto_cliente
@cd_cliente        int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@cd_usuario        int      = 0,
@ic_atualiza_preco char(1)  ='N',
@ic_zera_tabela    char(1)  ='N'
as

--select * from produto_cliente
--select * from nota_saida
--select * from nota_saida_item

--Zera a Tabela Produto_cliente

if @ic_zera_tabela = 'S'
begin
  delete from produto_cliente
end

--Montagem de uma Tabela Auxiliar para evitar Duplicidade / consistência

select
  n.cd_cliente,
  i.cd_produto,
  max(i.nm_fantasia_produto)                as nm_fantasia_prod_cliente,
  max(i.vl_unitario_item_nota)              as vl_produto_cliente,
  max(n.dt_nota_saida)                      as dt_preco_produto_cliente

into
  #AuxProdutoCliente
  
from
  Nota_Saida n
  inner join Nota_Saida_Item i   on i.cd_nota_saida = n.cd_nota_saida                                 
  inner join Operacao_Fiscal opf on opf.cd_operacao_fiscal = n.cd_operacao_fiscal

where
  n.cd_cliente    = case when @cd_cliente = 0 then n.cd_cliente else @cd_cliente end and
  n.dt_nota_saida between @dt_inicial and @dt_final                                  and
  n.dt_cancel_nota_saida is null                                                     and
  --Somente as Operações Comerciais 
  isnull(opf.ic_comercial_operacao,'N')='S'                                          and
  --Verifica Existe Produto
  isnull(i.cd_produto,0)>0                                                           and 

  --Verifica Existe Cliente/Produto já Cadastrado
  
  not exists ( select cd_cliente from Produto_Cliente pc
               where
               pc.cd_cliente = n.cd_cliente and
               pc.cd_produto = i.cd_produto )
group by
  n.cd_cliente,
  i.cd_produto

--Montagem da Tabela Auxiliar

select
  cd_cliente,
  cd_produto,
  nm_fantasia_prod_cliente,
  'N'                                  as ic_proposta_prod_cliente,
  'N'                                  as ic_ped_vend_prod_cliente,
  'N'                                  as ic_nf_produto_cliente,
  cast(null as varchar(30))            as nm_produto_cliente,
  'N'                                  as ic_desc_produto_cliente,
  null                                 as nm_obs_produto_cliente,
  @cd_usuario                          as cd_usuario,
  getdate()                            as dt_usuario,
  1                                    as cd_moeda,
  case when @ic_atualiza_preco='N' 
  then 0.00
  else
      vl_produto_cliente end           as vl_produto_cliente,
  dt_preco_produto_cliente,
  null                                 as cd_termo_comercial,
  null                                 as cd_tabela_preco,
  null                                 as cd_aplicacao_markup,
  null                                 as qt_minimo_produto_cliente

into
  #Produto_Cliente
from
  #AuxProdutoCliente

--select * from operacao_fiscal

select * from #Produto_Cliente
order by
  cd_cliente,
  cd_produto

insert into
  Produto_cliente
select
  *
from
  #Produto_Cliente

