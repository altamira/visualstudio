
-------------------------------------------------------------------------------
--pr_calculo_markup_produto_estampo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo do Orçamento dos Produto Estampados
--Data             : 29.04.2007
--Alteração        : 30.04.2007
--                 : 07.05.2007
--                 : 06.12.2007 - Verificação dos Cálculos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_calculo_markup_produto_estampo
@cd_produto_estampo  int      = 0,
@cd_usuario          int      = 0
as

--select * from produto_estampo

declare @vl_total                  decimal(25,6)
declare @cd_aplicacao_markup       int

--Busca o Markup da tabela de parâmetros

select
  @cd_aplicacao_markup = isnull(cd_aplicacao_markup,@cd_aplicacao_markup)
from
  parametro_orcamento_estampo
where
  cd_empresa = dbo.fn_empresa()

select
  @vl_total            = case when isnull(vl_orcamento_produto,0)>0 then
                              vl_orcamento_produto else vl_produto end  * qt_producao,
  @cd_aplicacao_markup = case when isnull(cd_aplicacao_markup,0)>0 then cd_aplicacao_markup
                                                                    else @cd_aplicacao_markup end
from
  produto_estampo 
where
   cd_produto_estampo = @cd_produto_estampo

--Verifica se Existe o Registro na Tabela de Markup
 
select
  @cd_produto_estampo                               as cd_produto_estampo,
  identity(int,1,1)                                 as cd_item_markup,  
  fm.cd_tipo_markup                                 as cd_tipo_markup,
  a.cd_aplicacao_markup                             as cd_aplicacao_markup,
  fm.pc_formacao_markup                             as pc_item_markup,
  @vl_total * (isnull(fm.pc_formacao_markup,0)/100) as vl_item_markup,
  cast('' as varchar(40))                           as nm_obs_item_markup,
  @cd_usuario                                       as cd_usuario,
  getdate()                                         as dt_usuario
into
  #Produto_Estampo_Markup

from
  aplicacao_markup a            with (nolock)
  inner join formacao_markup fm with (nolock) on fm.cd_aplicacao_markup = a.cd_aplicacao_markup
  inner join tipo_markup     tm with (nolock) on tm.cd_tipo_markup      = fm.cd_tipo_markup
where
  @cd_produto_estampo   > 0 and
  a.cd_aplicacao_markup = @cd_aplicacao_markup
order by
  fm.pc_formacao_markup desc

--select * from #produto_estampo_markup

if not exists( select top 1 cd_produto_estampo from produto_estampo_markup where cd_produto_estampo = @cd_produto_estampo )
begin
  print 'nao existe'

  insert into 
    produto_estampo_markup
  select
    * 
  from 
    #produto_estampo_markup
    
end
  
--Apresentação dos Dados

select
  pem.cd_produto_estampo,
  pem.cd_item_markup,
  fm.cd_tipo_markup,
  a.cd_aplicacao_markup,
  a.nm_aplicacao_markup                             as Aplicacao,  
  tm.nm_tipo_markup                                 as Descricao,
  case when isnull(pem.pc_item_markup,0)>0
  then
    pem.pc_item_markup
  else
    fm.pc_formacao_markup
  end                                               as Percentual,
  
  @vl_total * 
  (  
  case when isnull(pem.pc_item_markup,0)>0
  then
    pem.pc_item_markup
  else
    isnull(fm.pc_formacao_markup,0)
  end
  /100)                                             as Valor,

  pem.nm_obs_item_markup                           

from
  produto_estampo_markup pem    with (nolock)
  inner join aplicacao_markup a with (nolock) on a.cd_aplicacao_markup  = pem.cd_aplicacao_markup
  inner join formacao_markup fm with (nolock) on fm.cd_aplicacao_markup = pem.cd_aplicacao_markup and
                                                 fm.cd_tipo_markup      = pem.cd_tipo_markup                                                 
  inner join tipo_markup     tm with (nolock) on tm.cd_tipo_markup      = fm.cd_tipo_markup
where
  pem.cd_produto_estampo = @cd_produto_estampo and
  a.cd_aplicacao_markup  = @cd_aplicacao_markup
order by
  fm.pc_formacao_markup desc


--select * from formacao_markup
--select * from produto_estampo_markup
--delete from produto_estampo_markup

