
create procedure pr_montagem_produto_previsao

------------------------------------------------------------------------
--pr_montagem_produto_previsao
------------------------------------------------------------------------
--GBS - Global Business Solution	               2004
--Stored Procedure	: Microsoft SQL Server         2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Montagem dos Produtos na Tabela de Previsão
--                        que não tiveram vendas
--Data			: 16/11/2004
--Alteração             : 22/11/2004 - Revisão
------------------------------------------------------------------------
@cd_usuario int,
@dt_inicial datetime,
@dt_final   datetime

as

declare @cd_fase_produto   int
declare @cd_vendedor       int
declare @cd_cliente        int
declare @cd_previsao_venda int


--Início o Número da Previsão de Vendas

select @cd_previsao_venda = isnull(max(cd_previsao_venda ),0) from previsao_venda


set @cd_fase_produto = 0

--Busca a Fase de Produto

set @cd_fase_produto=isnull(@cd_fase_produto,
                            (SELECT cd_fase_produto
                             FROM Parametro_Comercial
                             WHERE cd_empresa = dbo.fn_empresa() ) )



--Montagem da Tabela Auxiliar de Vendedor/Cliente

select 
  a.cd_vendedor,
  a.cd_cliente

into 
  #AuxVendedorCliente
from 
  previsao_venda a
Group by
  a.cd_vendedor,
  a.cd_cliente

--Mostra a tabela auxiliar de Vendedor/Cliente  
--select * from #AuxVendedorCliente

select 
  a.cd_vendedor,
  a.cd_cliente,
  a.cd_produto

into 
  #AuxPrevisaoProduto 
from 
  previsao_venda a


--Mostra a Tabela Montada

--   select
--   * 
--   from 
--     #AuxPrevisaoProduto
--   order by
--     cd_vendedor,
--     cd_cliente,
--     cd_produto


--Montagem da Tabela Auxiliar de Vendedor/Cliente e os Produtos não Vendidos

while exists ( select top 1 * from #AuxVendedorCliente )
begin

  select
    top 1
    @cd_vendedor = cd_vendedor,
    @cd_cliente  = cd_cliente
  from
    #AuxVendedorCliente

  --Processamento : Montagem da Tabela Auxiliar

  select
    identity(int,1,1)        as cd_previsao_venda,
    @cd_vendedor             as cd_vendedor,
    @cd_cliente              as cd_cliente,
    p.cd_produto             as cd_produto 
  into
    #AuxProdutoNaoVendido  
  from
    produto p, status_produto spr  
  where
    p.cd_status_produto = spr.cd_status_produto and
   isnull(spr.ic_permitir_venda,'N')='S'        and 
   isnull(p.ic_comercial_produto,'N')='S'       and
    p.cd_produto not in ( select cd_produto from #AuxPrevisaoProduto where cd_vendedor = @cd_vendedor and cd_cliente = @cd_cliente )

  
--  select * from #AuxProdutoNaoVendido  

  --Geração da Previsão com a Tabela de Produtos não vendidos

  insert 
    Previsao_Venda (
      cd_previsao_venda,
      dt_inicio_previsao_venda,
      dt_final_previsao_venda,
      cd_vendedor,
      cd_cliente,
      cd_produto,
      cd_fase_produto,
      cd_usuario,
      dt_usuario )
 
  select 
      cd_previsao_venda + @cd_previsao_venda,
      @dt_inicial,
      @dt_final,
      cd_vendedor,
      cd_cliente,
      cd_produto,
      @cd_fase_produto,
      @cd_usuario,
      getdate()

 from #AuxProdutoNaoVendido


  --Deleta a tabela temporária

  drop table #AuxProdutoNaoVendido

  --Deleta o Registro

  delete
  from 
    #AuxVendedorCliente 
  where 
    cd_vendedor = @cd_vendedor and
    cd_cliente  = @cd_cliente

  --Busca o Número para Gravação da Previsão de Venda
  select @cd_previsao_venda = isnull(max(cd_previsao_venda ),0) from previsao_venda


end


