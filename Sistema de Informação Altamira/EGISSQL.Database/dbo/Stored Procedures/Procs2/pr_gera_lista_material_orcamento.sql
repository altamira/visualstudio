
create procedure pr_gera_lista_material_orcamento

@cd_interno_projeto   varchar(30),
@cd_item_projeto      int,
@cd_usuario           int

as

-- Pega o nro. do PV pelo Projeto
declare @cd_pedido_venda      int
declare @cd_item_pedido_venda int
declare @cd_projeto           int

select top 1
       @cd_projeto           = cd_projeto,  
       @cd_pedido_venda      = cd_pedido_venda,
       @cd_item_pedido_venda = cd_item_pedido_venda
from projeto 
where cd_interno_projeto = rtrim(@cd_interno_projeto)

-- Pega o nro. da consulta pelo PV
declare @cd_consulta      int
declare @cd_item_consulta int

select top 1 
       @cd_consulta = cd_consulta,
       @cd_item_consulta = cd_item_consulta
from pedido_venda_item
where cd_pedido_venda      = @cd_pedido_venda and
      cd_item_pedido_venda = @cd_item_pedido_venda

-- Busca o projetista logado no sistem
declare @cd_projetista int

select top 1 @cd_projetista = cd_projetista
from EgisAdmin.dbo.Usuario
where cd_usuario = @cd_usuario

-- Apaga todos os registros antes de incluir
delete from Projeto_Composicao_Material
where cd_projeto = @cd_projeto

--
-- Criação das tabelas temporárias
--

-- Tabela dos produtos-filho

select
  b.cd_produto                 as cd_produto_filho,
  b.qt_produto_composicao      as qt_produto,
  cd_ordem =
 (case when a.cd_item_comp_orcamento<10 then '0'+cast(a.cd_item_comp_orcamento as char(1)) 
  else cast(a.cd_item_comp_orcamento as char(2)) end) + '0',
  p.nm_fantasia_produto as nm_fantasia_componente,
  p.nm_produto          as nm_produto_orcamento,
  cast(null as varchar(1000)) as ds_produto_orcamento
--
into #TmpFilho
--
from Consulta_Item_Componente a
--
inner join Produto_Composicao b on
a.cd_produto = b.cd_produto_pai

inner join Produto p on
b.cd_produto = p.cd_produto and
b.cd_versao_produto_comp = p.cd_versao_produto

where a.cd_consulta      = @cd_consulta and
      a.cd_item_consulta = @cd_item_consulta

-- Tabela dos produtos do orçamento (pai)

select
  a.cd_produto             as cd_produto,
  a.qt_item_comp_orcamento as qt_produto,
  cd_ordem =
 (case when a.cd_item_comp_orcamento<10 then '0'+cast(a.cd_item_comp_orcamento as char(1)) 
  else cast(a.cd_item_comp_orcamento as char(2)) end),
  a.nm_fantasia_componente,
  a.nm_produto_orcamento,
  substring(a.ds_produto_orcamento,1,1000) as ds_produto_orcamento
--
into #TmpPai
--
from Consulta_Item_Componente a
--
where a.cd_consulta      = @cd_consulta and
      a.cd_item_consulta = @cd_item_consulta

select * into #TmpOrcamento from #TmpPai
UNION
select * from #TmpFilho

select
  @cd_projeto                as cd_projeto,
  @cd_item_projeto           as cd_item_projeto,
  identity(int,1,1)          as cd_projeto_material,
  cast(null as int)          as cd_desenho_projeto,
  a.cd_produto               as cd_produto,
  a.qt_produto               as qt_projeto_material,     -- Quantidade
  cast(isnull(a.nm_fantasia_componente,a.nm_produto_orcamento) as varchar(50))
			     as nm_esp_projeto_material, -- Descrição de produto especial
  cast(null as varchar(40))  as nm_obs_projeto_material,
  cast(a.ds_produto_orcamento as text)
			     as ds_projeto_material,     -- Descritivo
  cast('N' as char(1))       as ic_fabricado_projeto,    -- Fabricado
  cd_fornecedor =
 (case when p.ic_compra_produto = 'S' then
   (select top 1 fp.cd_fornecedor
    from fornecedor_produto fp
    where fp.cd_produto = a.cd_produto) else null end),
  cast(null as int)          as cd_requisicao_compra,
  pc.cd_mat_prima            as cd_materia_prima,
  @cd_usuario                as cd_usuario,
  GetDate()                  as dt_usuario,
  cast(pcomp.nm_marca_produto as varchar(30)) 
			     as nm_marca_material,
  isnull(p.cd_unidade_medida,12)
			     as cd_unidade_medida,
  cd_tipo_produto_projeto =
 (case when p.ic_compra_produto = 'S' then 1 else 2 end), 
  cast(0 as int)	     as cd_processo,
  cast(null as varchar(30))  as nm_fornec_prod_projeto,    -- Nome do fornecedor no projeto
  cast(null as int)          as cd_item_requisicao_compra,
  @cd_projetista             as cd_projetista,
  null 			     as nm_desenho_material,
  null 			     as nm_caminho_desenho,        -- Arquivo de desenho
  null 			     as cd_requisicao_interna,
  null 			     as cd_item_req_interna,
  cast('N' as char(1))       as ic_reposicao_material,
  cast(null as datetime)     as dt_liberacao_material,
  cast(null as int)          as cd_projetista_liberacao,   -- Projetista que liberou material
  cast(null as int)          as cd_selecionado,            -- Selecionado para liberação
  cast('N' as char(1))       as ic_desgaste_material,
  cast(null as int)	     as qt_dia_desgaste_material,
  cast(null as datetime)     as dt_vencimento_desgaste,
  cast('N' as char(1))       as ic_compra_prod_material,   -- Permite a compra ou produção material
  null 			     as qt_hora_desgaste_material, -- Quantidade de horas que produto desgasta
  null 			     as cd_ref_item_material,      -- Código referência item na lista material
  null 		             as qt_saldo_atual_produto,
  cast('S' as char(1))       as ic_ativo_material          -- Item da lista ativo
--
into #ConsultaOrcamento
--
from #TmpOrcamento a
--
left outer join Produto p on
a.cd_produto = p.cd_produto

left outer join Produto_Custo pc on
a.cd_produto = pc.cd_produto

left outer join Produto_Compra pcomp on
a.cd_produto = pcomp.cd_produto

order by a.cd_ordem

--
insert into Projeto_Composicao_Material
select * from #ConsultaOrcamento
--

