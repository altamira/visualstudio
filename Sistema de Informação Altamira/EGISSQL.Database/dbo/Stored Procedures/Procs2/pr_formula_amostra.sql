
CREATE PROCEDURE pr_formula_amostra
@ic_parametro int,
@cd_cliente int,
@cd_amostra int,
@nm_vendedor_externo varchar(40)


as

begin
-----------------------------  Realiza Pesquisa por Cliente -----------------------------------------
if @ic_parametro = 1
-----------------------------------------------------------------------------------------------------
  Begin
   Select
     a.*,
     am.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno',
     ap.nm_amostra_produto,
     ap.ds_amostra_produto,
     fp.nm_fase_produto

    From 
      Amostra a left outer join 
      Cliente cli on (a.cd_cliente = cli.cd_cliente) left outer join 
      Cliente_Contato co on (a.cd_contato = co.cd_contato)and(co.cd_cliente = cli.cd_cliente) left outer join
      Status_Amostra sa on (a.cd_status_amostra = sa.cd_status_amostra)left outer join
      Resposta_Cliente rc on (a.cd_resposta_cliente = rc.cd_resposta_cliente) left outer join
      Tecnico t on (a.cd_tecnico = t.cd_tecnico)left outer join
      Vendedor ve on (a.cd_vendedor_externo = ve.cd_vendedor)left outer join
      Vendedor v on (a.cd_vendedor_interno = v.cd_vendedor)left outer join
      EgisAdmin.dbo.usuario u on (a.cd_usuario_solicitante = u.cd_usuario)left outer join
      Amostra_Material am on (a.cd_amostra = am.cd_amostra)left outer join
      Amostra_Produto ap on (a.cd_amostra = ap.cd_amostra)left outer join
      Fase_produto fp on (am.cd_fase_produto = fp.cd_fase_produto)
    
      where 
      cli.cd_cliente = @cd_cliente

  end

--***-

else
-------------------------  Realiza Pesquisa por Codigo Amostra---------------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     a.*,
     am.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno',
     ap.nm_amostra_produto,
     ap.ds_amostra_produto

    From 
      Amostra a left outer join 
      Cliente cli on (a.cd_cliente = cli.cd_cliente) left outer join 
      Cliente_Contato co on (a.cd_contato = co.cd_contato)and(co.cd_cliente = cli.cd_cliente) left outer join
      Status_Amostra sa on (a.cd_status_amostra = sa.cd_status_amostra)left outer join
      Resposta_Cliente rc on (a.cd_resposta_cliente = rc.cd_resposta_cliente) left outer join
      Tecnico t on (a.cd_tecnico = t.cd_tecnico)left outer join
      Vendedor ve on (a.cd_vendedor_externo = ve.cd_vendedor)left outer join
      vendedor v on (a.cd_vendedor_interno = v.cd_vendedor)left outer join
      EgisAdmin.dbo.usuario u on (a.cd_usuario_solicitante = u.cd_usuario)left outer join
      Amostra_Material am on (a.cd_amostra = am.cd_amostra)left outer join
      Amostra_Produto ap on (a.cd_amostra = ap.cd_amostra)

  end

--***-

else
-----------------------------  Realiza Pesquisa Geral------------------------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     a.*,
     am.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno',
     ap.nm_amostra_produto,
     ap.ds_amostra_produto

    From 
      Amostra a left outer join 
      Cliente cli on (a.cd_cliente = cli.cd_cliente) left outer join 
      Cliente_Contato co on (a.cd_contato = co.cd_contato)and(co.cd_cliente = cli.cd_cliente) left outer join
      Status_Amostra sa on (a.cd_status_amostra = sa.cd_status_amostra)left outer join
      Resposta_Cliente rc on (a.cd_resposta_cliente = rc.cd_resposta_cliente) left outer join
      Tecnico t on (a.cd_tecnico = t.cd_tecnico)left outer join
      Vendedor ve on (a.cd_vendedor_externo = ve.cd_vendedor)left outer join
      vendedor v on (a.cd_vendedor_interno = v.cd_vendedor)left outer join
      EgisAdmin.dbo.usuario u on (a.cd_usuario_solicitante = u.cd_usuario)left outer join
      Amostra_Material am on (a.cd_amostra = am.cd_amostra)left outer join
      Amostra_Produto ap on (a.cd_amostra = ap.cd_amostra)

      where 
      cli.cd_cliente = @cd_cliente

   end
end
