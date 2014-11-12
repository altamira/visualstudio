
-------------------------------------------------------------------------------
--sp_helptext pr_gera_laudo_nota_entrada
-------------------------------------------------------------------------------
--pr_gera_laudo_nota_entrada
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Laudo de Produto conforme as Notas Fiscais de 
--                   Entrada
--Data             : 08.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_laudo_nota_entrada
@cd_fornecedor        int = 0,
@cd_nota_entrada      int = 0,
@cd_serie_nota_fiscal int = 0,
@cd_operacao_fiscal   int = 0,
@cd_usuario           int = 0
as

--nota entrada
--select * from nota_entrada

--item da nota_entrada\
--select * from nota_entrada_item

--select * from origem_laudo

--laudo
------------------------------------------------------------------------------
--Verifica se Existe o Laudo
------------------------------------------------------------------------------

declare @cd_laudo int
set @cd_laudo = 0

if @cd_nota_entrada>0 and @cd_fornecedor>0
begin

  --Verifica se Existe o Laudo Gerado---------------------------------------------------------------

  
select
  0                                         as cd_laudo,
  ne.dt_receb_nota_entrada                  as dt_laudo,
  ( select top 1 cd_origem_laudo 
    from 
      origem_laudo 
    where isnull(ic_laudo_entrada,'N')='S') as cd_origem_laudo,
  ne.cd_fornecedor,
  ne.cd_nota_entrada,
  nei.cd_item_nota_entrada,
  null as cd_processo,
  null as cd_amostra,
  nei.cd_produto,
  nei.cd_unidade_medida,
  nei.qt_item_nota_entrada      as qt_laudo,
  nei.cd_lote_item_nota_entrada as cd_lote,
  ne.dt_receb_nota_entrada      as dt_fabricacao,
  ne.dt_receb_nota_entrada      as dt_validade,
  null as cd_tecnico,
  cast('' as varchar)           as ds_laudo,
  @cd_usuario                   as cd_usuario,
  getdate()                     as dt_usuario,
  nei.nm_produto_nota_entrada   as nm_produto_laudo,
  nei.cd_fase_produto,
  cast('' as varchar)           as   ds_cabecalho,
  cast('' as varchar)           as ds_rodape,
  ne.cd_serie_nota_fiscal,
  ne.cd_operacao_fiscal,
--select * from origem_produto
  p.cd_origem_produto,
  1    as   cd_metodo_inspecao,
  null as cd_tipo_inspecao,
  null as cd_inspetor,
  null as cd_cliente,
  null as cd_pedido_venda,
  null as cd_item_pedido_venda,
  null              as cd_fabricante,
  identity(int,1,1) as cd_interface,
  null              as qt_amostra_laudo,
  null              as qt_aprovado_laudo,
  null              as qt_rejeitado_laudo

into
  #Laudo

from
  Nota_Entrada ne
  inner join Nota_Entrada_Item nei on nei.cd_fornecedor        = ne.cd_fornecedor        and
                                      nei.cd_nota_entrada      = ne.cd_nota_entrada      and
                                      nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                                      nei.cd_operacao_fiscal   = ne.cd_operacao_fiscal  
  inner join produto p             on p.cd_produto             = nei.cd_produto

--select top 1 ic_inspecao_produto,* from produto        
--select * from produto_inspecao

where
  isnull(nei.cd_laudo,0)   = 0                     and --Não pode existir Laudo Gerado
  ne.cd_fornecedor        = @cd_fornecedor        and
  ne.cd_nota_entrada      = @cd_nota_entrada      and
  ne.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
  ne.cd_operacao_fiscal   = @cd_operacao_fiscal   and
  isnull(p.ic_inspecao_produto,'N') = 'S' --Inspeção do Produto

--select * from nota_entrada

select * from #laudo

if exists( select top 1 cd_laudo from #Laudo )
begin
  select 
    @cd_laudo = max( cd_laudo ) + 1
  from
    Laudo

  if @cd_laudo is null or @cd_laudo = 0
  begin
    set @cd_laudo = 1
  end

  update
    #Laudo
  set
    cd_laudo = @cd_laudo + cd_interface


  --select * from #Laudo

  insert into
    Laudo
  select
    *
  from
    #Laudo

  
  --Atualiza o Laudo Gerado na Nota Fiscal

  update
    nota_entrada_item
  set
    cd_laudo = l.cd_laudo
  from
    nota_entrada_item nei
    inner join #Laudo l on
                           nei.cd_fornecedor        = l.cd_fornecedor        and
                           nei.cd_nota_entrada      = l.cd_nota_entrada      and
                           nei.cd_serie_nota_fiscal = l.cd_serie_nota_fiscal and
                           nei.cd_operacao_fiscal   = l.cd_operacao_fiscal   and 
                           nei.cd_item_nota_entrada = l.cd_item_nota_entrada


  where
    isnull(nei.cd_laudo,0)=0

end

end

--select * from laudo
-- update nota_entrada_item set cd_laudo = 0
