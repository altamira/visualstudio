
CREATE   PROCEDURE pr_liberacao_desconto_proposta

-------------------------------------------------------------------------------
--pr_controle_desconto
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                           	   2004
-------------------------------------------------------------------------------
--Stored Procedure          : Microsoft SQL Server 2000
--Autor(es)                 : Daniel Carrasco Neto
--Banco de Dados            : Egissql
--Objetivo                  : Listar as Propostas com Desconto para
--                            Liberação
--Data                      : 01/02/2005
-------------------------------------------------------------------------------
@ic_parametro as int, --1 liberados, 2 não liberados, 3 Todos
@dt_inicial as DateTime,
@dt_final   as DateTime,
@cd_consulta as int

AS

SELECT     
  0 as Sel,
  c.cd_vendedor, 
  ci.pc_desconto_item_consulta, 
  ci.dt_desconto_item_consulta, 
  ci.cd_usuario_lib_desconto, 
  ve.nm_fantasia_vendedor AS nm_fantasia_ve, 
  vi.nm_fantasia_vendedor AS nm_fantasia_vi, 
  c.cd_vendedor_interno, 
  cli.nm_fantasia_cliente, 
  ci.dt_item_consulta, 
  ci.cd_consulta, 
  ci.cd_item_consulta, 
  ci.qt_item_consulta, 
  ci.vl_lista_item_consulta, 
  ci.vl_unitario_item_consulta, 
  p.nm_fantasia_produto, 
  p.nm_produto, 
  ci.cd_usuario, 
  ci.dt_usuario,
  ci.dt_fechamento_consulta,
  isNull(ci.ic_desconto_consulta_item,'S') as ic_desconto_consulta_item
FROM         
  Consulta c inner join
  Consulta_Itens ci ON c.cd_consulta = ci.cd_consulta left outer join
  Vendedor vi ON c.cd_vendedor_interno = vi.cd_vendedor left outer join
  Vendedor ve ON c.cd_vendedor = ve.cd_vendedor left outer join
  Cliente cli ON c.cd_cliente = cli.cd_cliente left outer join
  Produto p on p.cd_produto = ci.cd_produto
		
where
  ci.dt_item_consulta between ( case when @cd_consulta = 0 then
                                    @dt_inicial else
                                  ci.dt_item_consulta end ) and 
                              ( case when @cd_consulta = 0 then
                                    @dt_final else
                                  ci.dt_item_consulta end ) and
  ci.dt_fechamento_consulta  is null and 
  ci.dt_perda_consulta_itens is null and

  --Liberado
   IsNull(ci.dt_desconto_item_consulta,'') = (case when @ic_parametro = 2 then 
                                              ''
                                              else IsNull(ci.dt_desconto_item_consulta,'') 
                                              end)  and
                                           

   isNull(ci.ic_desconto_consulta_item,'S') = ( case when @ic_parametro = 2 then 
                                                  'S'
                                                else 'N' 
                                                end ) and

  ci.pc_desconto_item_consulta > 0 and
  ci.cd_consulta = ( case when @cd_consulta = 0 then
                        ci.cd_consulta else
                        @cd_consulta end ) 
order by 
  ci.dt_item_consulta,
  ci.cd_consulta,
  ci.cd_item_consulta

