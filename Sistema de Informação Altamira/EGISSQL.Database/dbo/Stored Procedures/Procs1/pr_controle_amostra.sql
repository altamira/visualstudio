
CREATE PROCEDURE pr_controle_amostra
@ic_parametro as int,
@dt_inicial as DateTime,
@dt_final as DateTime


as
Begin
-----------------------------Realiza Pesquisa por Período------------------------------------------------
if @ic_parametro = 1
-------------------------Usado Somente no Controle de Amostra--------------------------------------------
Begin
   Select 
     a.*,
     cli.nm_fantasia_cliente,
     co.nm_contato_cliente,
     sa.nm_status_amostra,
     rc.nm_resposta_cliente,
     t.nm_tecnico,
     ve.nm_vendedor as 'nm_vendedor_externo',
     v.nm_vendedor as 'nm_vendedor_interno',
     usu.nm_usuario as 'nm_usuario_solicitante'

    From 
      Amostra a left outer join 
      Cliente cli on (a.cd_cliente = cli.cd_cliente) left outer join 
      Cliente_Contato co on (a.cd_contato = co.cd_contato)and(co.cd_cliente = cli.cd_cliente) left outer join
      Status_Amostra sa on (a.cd_status_amostra = sa.cd_status_amostra)left outer join
      Resposta_Cliente rc on (a.cd_resposta_cliente = rc.cd_resposta_cliente) left outer join
      Tecnico t on (a.cd_tecnico = t.cd_tecnico)left outer join
      Vendedor ve on (a.cd_vendedor_externo = ve.cd_vendedor)left outer join
      vendedor v on (a.cd_vendedor_interno = v.cd_vendedor)left outer join
      egisadmin..usuario usu on (a.cd_usuario_solicitante = usu.cd_usuario)

   where 
   a.dt_solicitacao_amostra between @dt_inicial and @dt_final
end

else
-----------------------------Realiza Pesquisa por Período------------------------------------------------
if @ic_parametro = 2
-------------------------Usado Somente no Controle de Retenções--------------------------------------------
  Begin
   Select 
     rt.*,
     ogr.nm_origem_retencao,
     p.nm_produto,
     p.nm_fantasia_produto
    From 
      Retencao rt left outer join
      Origem_retencao ogr on(rt.cd_origem_retencao = ogr.cd_origem_retencao) left outer join
      Produto p on (rt.cd_produto = p.cd_produto) left outer join
      Amostra a on (rt.cd_amostra = a.cd_amostra)
    where 
      rt.dt_retencao between @dt_inicial and @dt_final

  end
end
