
CREATE PROCEDURE pr_consulta_produto_composicao_pai

@ic_parametro             int,
@cd_produto_filho         int,
@cd_produto_filho_novo    int,
@cd_versao_produto_filho  int,
@ic_nova_versao_ativa     char(1)

as

declare @cd_produto            int
declare @cd_produto_pai        int
declare @cd_versao_produto_pai int

create table #Temp_Arvore_Produto_Pai
  (cd_chave int null,
   ProdutoPaiComp int null,
   CodigoProduto int null,
   cd_versao_produto_comp int null)

create table #Arvore_Final
  (cd_chave int null,
   cd_produto_pai int null,
   cd_produto int null,
   qt_produto_composicao float null,
   cd_fase_produto int null, 
   cd_ordem_produto_comp int null, 
   nm_fantasia_produto varchar(40) null)

----------------------------------------------------------------------------------------------------

  select
    pc.cd_produto_pai           as 'ProdutoPaiComp',
    pc.cd_produto               as 'CodigoProduto',
    pc.cd_versao_produto_comp   as 'cd_versao_produto_comp' 
  into #Temp_Arvore_Produto
  from 
    Produto_Composicao pc
  where 
    pc.cd_produto = @cd_produto_filho and
    pc.cd_versao_produto_comp = @cd_versao_produto_filho

  select * into #Temp_Arvore_Produto_1
  from #Temp_Arvore_Produto

-------------------------
-- Variáveis auxiliares no loop para buscar a composição dos produtos pertencentes
-- a Composição Primária do Produto Pai
-------------------------

declare @cd_chave int

set @cd_chave = 0

while exists (Select 'x' from #Temp_Arvore_Produto_1)
begin
  select top 1 
    @cd_produto            = isnull(codigoproduto,0),
    @cd_produto_pai        = isnull(ProdutoPaiComp,0),
    @cd_versao_produto_pai = IsNull(cd_versao_produto_comp,0)
  from 
    #Temp_Arvore_Produto_1

  insert into #Temp_Arvore_Produto_Pai
  select
    ( select count('x') 
      from Produto_Composicao x
      where x.cd_produto_pai = pc.cd_produto_pai and
            x.cd_versao_produto_comp = @cd_versao_produto_pai ) as 'cd_chave',
    pc.cd_produto_pai                   as 'ProdutoPaiComp',
    pc.cd_produto                       as 'CodigoProduto',
    isnull(pc.cd_versao_produto_comp,0) as 'cd_versao_produto'
  from 
    Produto_Composicao pc
  where 
    pc.cd_produto = @cd_produto_pai and
    pc.cd_versao_produto_comp = @cd_versao_produto_pai

  delete from #Temp_Arvore_Produto_1
  where
    @cd_produto            = isnull(codigoproduto,0)  and
    @cd_produto_pai        = isnull(ProdutoPaiComp,0) and
    @cd_versao_produto_pai = IsNull(cd_versao_produto_comp,0)

end

-------------------------
-- Loop da Composição Geral (1)
-------------------------
while exists(select 'x' from #Temp_Arvore_Produto_Pai)
begin
  select top 1 
    @cd_produto  = isnull(ProdutoPaiComp,0),
    @cd_chave = cd_chave
  from 
    #Temp_Arvore_Produto_Pai

  insert into #Arvore_Final
    select @cd_chave, * from dbo.fn_composicao_produto_versao(@cd_produto,@cd_versao_produto_filho)

  delete from #Temp_Arvore_Produto_Pai
  where
    ProdutoPaiComp=@cd_produto
end

-------------------------
-- Loop da Composição Geral (2) Caso o loop acima não retornar nada
-------------------------
if not exists(select 'x' from #Arvore_Final)
begin
  while exists(select 'x' from #Temp_Arvore_Produto)
  begin
    select top 1 
      @cd_produto  = isnull(ProdutoPaiComp,0)
    from 
      #Temp_Arvore_Produto

    insert into #Arvore_Final
      select @cd_chave, * from dbo.fn_composicao_produto_versao(@cd_produto,@cd_versao_produto_filho)
   
    delete from #Temp_Arvore_Produto
    where
      ProdutoPaiComp=@cd_produto
  end
end

select 
  af.cd_chave,
  af.cd_produto + cd_chave         as 'cd_chave_produto',
  af.cd_produto_pai + cd_chave         as 'cd_chave_produto_pai',
  af.cd_produto_pai,
  af.cd_produto,
  af.qt_produto_composicao,
  af.cd_fase_produto, 
  af.cd_ordem_produto_comp, 
  af.nm_fantasia_produto,
  dbo.fn_mascara_produto(p.cd_produto) as 'MascaraComp',
  p.nm_fantasia_produto as 'NomeFantasiaComp',
  p.nm_produto as 'DescricaoComp',
  fp.nm_fase_produto,  
  af.qt_produto_composicao as 'QtdeProdutoComp',
  um.sg_unidade_medida,
  p.qt_leadtime_produto as 'qt_leadtime',
  p.qt_leadtime_compra
into #Temp
from 
  #Arvore_Final af
left outer join Produto p on
  af.cd_produto=p.cd_produto
left outer join Fase_Produto fp on
  af.cd_fase_produto=fp.cd_fase_produto
left outer join Unidade_Medida um on
  p.cd_unidade_medida=um.cd_unidade_medida
order by af.cd_produto_pai,
         af.cd_ordem_produto_comp

drop table #Temp_Arvore_Produto
drop table #Temp_Arvore_Produto_1
drop table #Temp_Arvore_Produto_Pai
drop table #Arvore_Final

-------------------------------------
if @ic_parametro = 1 --Consulta reversa de Composição do Produto
--------------------------------------
  select * from #Temp

-------------------------------------
else if @ic_parametro = 2 --Cria nova versão para o produto
--------------------------------------
begin
  select cd_produto_pai
  into #Temp_Pai
  from #Temp
  where
    cd_chave_produto=cd_chave_produto_pai  

  while exists (select 'x' from #Temp_Pai)
  begin
    set @cd_produto_pai = (select top 1 cd_produto_pai  
                           from #Temp_Pai)
    set @cd_versao_produto_pai = ((select max(cd_versao_produto_comp)
                                  from Produto_Composicao
                                  where
                                    cd_produto_pai=@cd_produto_pai)+1)

    select pc.* 
    into #Produto_Composicao_Temp
    from #Temp t
    left outer join Produto_Composicao pc on
      t.cd_produto = pc.cd_produto
    where
      isnull(pc.cd_produto,'')<>''

    insert into Produto_Composicao
    (cd_produto_pai,
     cd_produto,
     cd_item_produto,
     qt_item_produto,
     qt_produto_composicao,
     qt_peso_liquido_produto,
     qt_peso_bruto_produto,
     cd_ordem_produto,
     cd_fase_produto,
     cd_materia_prima,
     cd_bitola,
     cd_usuario,
     dt_usuario,
     nm_obs_produto_composicao,
     ic_calculo_peso_produto,
     pc_composicao_produto,
     ic_montagemg_produto,
     ic_montagemq_produto,
     ic_tipo_montagem_produto,
     cd_versao_produto_comp,
     cd_ordem_produto_comp,
     cd_produto_composicao,
     cd_versao_produto,
     nm_produto_comp)
     select
       cd_produto_pai,
       cd_produto,
       cd_item_produto,
       qt_item_produto,
       qt_produto_composicao,
       qt_peso_liquido_produto,
       qt_peso_bruto_produto,
       cd_ordem_produto,
       cd_fase_produto,
       cd_materia_prima,
       cd_bitola,
       cd_usuario,
       dt_usuario,
       nm_obs_produto_composicao,
       ic_calculo_peso_produto,
       pc_composicao_produto,
       ic_montagemg_produto,
       ic_montagemq_produto,
       ic_tipo_montagem_produto,
       @cd_versao_produto_pai,
       cd_ordem_produto_comp,
       cd_produto_composicao,
       cd_versao_produto,
       nm_produto_comp
     from
       #Produto_Composicao_Temp 
  
    --Substitui antigo produto selecionado pelo novo
    update Produto_Composicao set cd_produto= @cd_produto_filho_novo
    where 
      cd_produto_pai = @cd_produto_pai and
      cd_produto = @cd_produto_filho and
      cd_versao_produto_comp = @cd_versao_produto_pai

  -- Ativa a nova versão criada para o produto
    if @ic_nova_versao_ativa='S'
    begin
    update Produto set cd_versao_produto=@cd_versao_produto_pai
      where
        cd_produto=@cd_produto_pai
    end

    delete from #Temp_Pai 
    where
      cd_produto_pai = @cd_produto_pai

    drop table #Produto_Composicao_Temp 
  end

  -- Ativa a nova versão criada para o produto
  if @ic_nova_versao_ativa='S'
  begin
    update Produto set cd_versao_produto=@cd_versao_produto_pai
    where
      cd_produto=@cd_produto_filho_novo
  end
end

