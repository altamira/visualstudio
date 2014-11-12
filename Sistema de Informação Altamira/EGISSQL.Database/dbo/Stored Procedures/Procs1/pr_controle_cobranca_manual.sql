
CREATE PROCEDURE pr_controle_cobranca_manual

@ic_parametro         int,
@cd_portador          int,
@dt_inicial           datetime,
@dt_final             datetime


as

--pr_controle_cobranca_manual
---------------------------------------------------
--GBS - Global Business Sollution              2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo: - Consultar Documentos do Portador escolhido com cobrança manual.
--Data: 31/10/2003
--Atualizado: 
---------------------------------------------------

-----------------------------------------------------------------------
--if @ic_parametro = 1 -- Consulta de Documentos a Receber por portador.
-----------------------------------------------------------------------
--begin

  SELECT  p.nm_portador,
	  dr.cd_identificacao, 
	  c.nm_fantasia_cliente, 
          dr.dt_emissao_documento, 
          dr.dt_vencimento_documento, 
          dr.vl_documento_receber, 
          dr.vl_saldo_documento, 
          v.nm_fantasia_vendedor 

  FROM    Documento_Receber dr left outer join
          Cliente c ON dr.cd_cliente = c.cd_cliente left outer join
          Vendedor v ON dr.cd_vendedor = v.cd_vendedor left outer join
          Portador p ON dr.cd_portador = p.cd_portador
  where
/*         ( dr.cd_portador = ( case when @cd_portador = 0 then
		                  dr.cd_portador
		                else
			          @cd_portador
                                end ) */
	  ( ( dr.cd_portador = @cd_portador ) or (@cd_portador = 0))	
	  and
         ( dr.dt_vencimento_documento between @dt_inicial and @dt_final ) and
	 IsNull(p.ic_cob_manual_portador,'N') = 'S' and
	 dr.vl_saldo_documento > 0 


--end

--else return


