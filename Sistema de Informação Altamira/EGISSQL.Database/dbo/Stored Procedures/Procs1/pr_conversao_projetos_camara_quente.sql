

/****** Object:  Stored Procedure dbo.pr_conversao_projetos_camara_quente    Script Date: 13/12/2002 15:08:25 ******/
--pr_conversao_projetos_camara_quente
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Conversao de projetos de Câmara Quente
--Data             : 15.05.2001
--Atualizado       : 29.05.2001
--                 : 21.06.2001 Atualizaçao de planilha atualizada PROJETOCQ3
--                              e inclusao de coluna DATA e PRODUTO
-----------------------------------------------------------------------------------
CREATE procedure pr_conversao_projetos_camara_quente
as
select
       b.pedido,
       a.item,
       a.qt,
       a.almoxit,
       a.codigoit,
       a.descricao,
       a.dtentr,
       a.dtentrpcp,
       c.projetista,
       c.cq,
       c.descricao as 'descrproj',
       c.dataproj,
       d.cd_projetista    
into #AuxProj 
from 
  sap.dbo.cadiped a, sap.dbo.cadped b, [temp-ti].dbo.Projetocq3 c, Projetista d
where
--a.dtdel is not null      and
  a.almoxit  = '52'        and
  a.codigoit = '0100000'   and
  a.pedidoit = b.pedido    and
  convert(varchar(15),b.pedido)   = c.cd_pedido and
  c.projetista = d.nm_fantasia_projetista
order by
  c.cq
-- a.pedidoit 
select * 
into #AuxProj1
from #AuxProj
order by cq desc
declare @cd_projeto         int
declare @cd_pedido          int
declare @cd_item_pedido     int
declare @cd_interno_projeto char(15)
declare @cd_projetista      int
declare @ds_projeto         varchar(100)
declare @dt_inicio_projeto  datetime
set @cd_projeto = 1
set @cd_pedido  = 0
while exists ( select * from #AuxProj1)
begin
  -- Seleciona o 1o. registro do select da Tabela #AuxProj
  select @cd_pedido          = pedido,
         @cd_item_pedido     = item,
         @cd_interno_projeto = cq,
         @cd_projetista      = cd_projetista, 
         @dt_inicio_projeto  = dataproj,
         @ds_projeto         = descrproj
  from
    #AuxProj1
  --Inserçao na Tabela de Projetos
  insert into Projeto ( cd_projeto,cd_interno_projeto,dt_inicio_projeto,dt_fim_projeto,
                        dt_info_cliente_projeto,dt_info_processo_projeto,ic_padrao_projeto,
                        cd_pedido_venda,cd_item_pedido_venda,nm_produto_cliente,dt_entrada_projeto,
                        qt_espessura_projeto,
                        qt_largura_projeto,qt_comprimento_projeto,ic_revisado_projeto,
                        ds_projeto,cd_status_projeto,cd_tipo_projeto,cd_projetista,
                        cd_material_plastico,ic_desenho_projeto,ic_simulacao_injecao,
                        nm_caminho_simulacao,nm_comp_material_plastico,cd_pedido_venda_molde,
                        cd_item_pedido_molde,ic_cancelamento_projeto,ic_garantia_projeto,
                        cd_consulta,cd_usuario,dt_usuario)
  values (@cd_projeto,@cd_interno_projeto,@dt_inicio_projeto,Null,
          Null,Null,'N',
          @cd_pedido,@cd_item_pedido,@ds_projeto,@dt_inicio_projeto,
          Null,        
          Null,Null,'N',
          @ds_projeto,4,2,@cd_projetista,        
          1,'N','N',
          Null,Null,Null,
          Null,'N','N',
          Null,1,getdate() )
  set @cd_projeto = @cd_projeto + 1
  delete from #Auxproj1
  where
     @cd_pedido = pedido 
end


