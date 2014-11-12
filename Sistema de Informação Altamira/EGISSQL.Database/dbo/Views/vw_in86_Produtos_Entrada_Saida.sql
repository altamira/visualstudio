
create  VIEW vw_in86_Produtos_Entrada_Saida
--vw_in86_Produtos_Entrada_Saida
---------------------------------------------------------
--GBS - Global Business Solution	                   2004
--Stored Procedure	: Microsoft SQL Server           2004
--Autor(es)		      : André Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Selecionar os Itens das notas de Entrada e Saida.
--                    View Auxiliar  
--Data			        : 24/03/2004
---------------------------------------------------
as

-- PRODUTOS DAS ENTRADAS

select distinct
  case when isnull(nei.cd_produto,0)>=0 then
         'P' + cast(p.cd_produto as char(16))
       else
         'S' + cast(s.cd_servico as char(16))
       end                                as 'cd_produto_servico',
  p.cd_produto                            as 'cd_produto',
  s.cd_servico                            as 'cd_servico',  
  nei.ic_tipo_nota_entrada_item           as 'Serv/Prod', 

  case when isnull(nei.cd_produto,0)>=0 then
         p.nm_produto
       else
         s.nm_servico
       end                                as 'Produto_Servico',

  case when isnull(nei.cd_produto,0)>=0 then
         p.dt_usuario
       else
         s.dt_usuario 
       end                                as 'Data_Atualizacao' 

from 

  Nota_Entrada_Item  nei
  
  left outer join produto p on
    p.cd_produto = nei.cd_produto

  left outer join servico s on
    s.cd_servico = nei.cd_servico

union 

-- PRODUTOS DAS SAÍDA
select distinct
  Case When ( Isnull( nsi.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nsi.cd_servico, 0 ) = 0 ) then
                'G' + cast(gp.cd_grupo_produto as char(16))
              Else
                'S' + cast(s.cd_servico as char(16))
              End
       Else
         'P' + cast(p.cd_produto as char(16))
       End                                              as 'cd_produto_servico',
  nsi.cd_produto                                        as 'cd_produto',
  nsi.cd_servico                                        as 'cd_servico',   
  nsi.ic_tipo_nota_saida_item                           as 'Serv/Prod', 

  Case When ( Isnull( nsi.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nsi.cd_servico, 0 ) = 0 ) then
                gp.nm_fantasia_grupo_produto
              Else
                s.nm_servico
              End
       Else
         p.nm_produto
       End                                              as 'Produto_Servico',

  Case When ( Isnull( nsi.cd_produto, 0 ) = 0 ) then
         Case When ( Isnull( nsi.cd_servico, 0 ) = 0 ) then
                gp.dt_usuario
              Else
                s.dt_usuario
              End
       Else
         p.dt_usuario
       End                                              as 'Produto_Servico'

from 
  Nota_saida_Item nsi

  left outer join produto p on
    p.cd_produto = nsi.cd_produto

  left outer join servico s on
    s.cd_servico = nsi.cd_servico

  left outer join grupo_produto gp on
    gp.cd_grupo_produto = nsi.cd_grupo_produto

