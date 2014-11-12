
CREATE PROCEDURE pr_solicitacao_amostra
@ic_parametro int,
@cd_amostra int,
@nm_cliente varchar(40),
@nm_vendedor varchar(40)


as

begin
-----------------------------  Realiza Pesquisa por Cliente -----------------------------------------
if @ic_parametro = 1
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     a.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     ci.nm_cidade,
     es.sg_estado,
     cli.cd_telefone,
     cli.cd_cnpj_cliente,
     cli.cd_inscestadual,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno'

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
      Cidade ci on (cli.cd_cidade = ci.cd_cidade)left outer join
      Estado es on (cli.cd_estado = es.cd_estado)
    

    where
    cli.nm_fantasia_cliente  like @nm_cliente + '%'   
  end

--***-

else
-------------------------  Realiza Pesquisa por Codigo Amostra---------------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     a.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     ci.nm_cidade,
     es.sg_estado,
     cli.cd_telefone,
     cli.cd_cnpj_cliente,
     cli.cd_inscestadual,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno'

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
      Cidade ci on (cli.cd_cidade = ci.cd_cidade)left outer join
      Estado es on (cli.cd_estado = es.cd_estado)

    where
    a.cd_amostra = @cd_amostra   
  end

--***-

else
-----------------------------  Realiza Pesquisa por Vendedor Externo---------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     a.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     ci.nm_cidade,
     es.sg_estado,
     cli.cd_telefone,
     cli.cd_cnpj_cliente,
     cli.cd_inscestadual,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno'

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
      Cidade ci on (cli.cd_cidade = ci.cd_cidade)left outer join
      Estado es on (cli.cd_estado = es.cd_estado)

    where
    ve.nm_vendedor like @nm_vendedor + '%'   
  end

--***-

else
-----------------------------  Realiza Pesquisa Geral------------------------------------------------
if @ic_parametro = 4
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     a.*,
     cli.cd_vendedor as 'vendedor_cliente_externo',
     cli.cd_vendedor_interno as 'vendedor_cliente_interno',
     u.nm_usuario as 'usuario_solicitante',
     cli.nm_fantasia_cliente,
     ci.nm_cidade,
     es.sg_estado,
     cli.cd_telefone,
     cli.cd_cnpj_cliente,
     cli.cd_inscestadual,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno'

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
      Cidade ci on (cli.cd_cidade = ci.cd_cidade)left outer join
      Estado es on (cli.cd_estado = es.cd_estado)

   end
end
