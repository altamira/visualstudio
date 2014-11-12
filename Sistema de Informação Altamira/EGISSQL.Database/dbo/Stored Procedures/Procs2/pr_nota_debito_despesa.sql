
CREATE PROCEDURE pr_nota_debito_despesa
  
  @ic_parametro int,
  @cd_nota_debito int,
  @dt_inicial DateTime,
  @dt_final DateTime

--------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2003
--------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.	
--Banco de Dados: EgisSql
--Objetivo   : Consultar Notas de Débito por Despesa	
--Data       : 04/07/2003
--Atualizado : 15/07/2003 - Adição de Campos - DUELA
-- 31/07/2003 - Inclusão de campos - Daniel C. NEto.
-- 05/08/2003 - Inclusão de Campos - Daniel C. Neto.
-- 07.12.2005 - Inclusão do Centro de Custo - Carlos Fernandes
--------------------------------------------------------------------------------------------------------
AS

--------------------------------------------------------------
if @ic_parametro = 1 -- Consulta Notas de Débito no período.
--------------------------------------------------------------
begin

 SELECT     
   nbd.*,
   c.nm_fantasia_cliente,
   p.cd_interno_projeto,
   co.nm_fantasia_contato,
   cc.nm_centro_custo,
   a.nm_analista

  FROM         
    Nota_Debito_Despesa nbd 
    LEFT OUTER JOIN Cliente c          ON c.cd_cliente = nbd.cd_cliente 
    left outer join Cliente_Contato co on co.cd_cliente = nbd.cd_cliente and co.cd_contato = nbd.cd_contato 
    left outer join Projeto p          on p.cd_projeto = nbd.cd_projeto
    left outer join Centro_Custo cc    on cc.cd_centro_custo = nbd.cd_centro_custo
    left outer join Analista a         on a.cd_analista = nbd.cd_analista
  Where
    ( ( nbd.dt_nota_debito_despesa between @dt_inicial and @dt_final ) and
      ( @cd_nota_debito = 0 ) ) or
    ( nbd.cd_nota_debito_despesa = @cd_nota_debito )
  Order By
    nbd.dt_nota_debito_despesa desc

end

----------------------------------------------------------------------
else if @ic_parametro = 2 -- Consulta os itens da nota.
----------------------------------------------------------------------
begin
 SELECT     
   nbdi.*,
   td.nm_tipo_despesa

  FROM         
    Nota_Debito_Despesa_Composicao nbdi LEFT OUTER JOIN 
    Tipo_Despesa td ON td.cd_tipo_despesa = nbdi.cd_tipo_despesa
  Where
    ( nbdi.cd_nota_debito_despesa = @cd_nota_debito )
  Order By
    nbdi.cd_item_nota_despesa desc

end

---------------------------------------------------------------------------
else if @ic_parametro = 3 -- Dados para o relatório.
---------------------------------------------------------------------------
begin

  select 
    n.cd_nota_debito_despesa,
    n.dt_nota_debito_despesa,
    n.dt_inicio_ref_nota_debito,
    n.dt_final_ref_nota_debito,
    n.nm_ref_nota_debito,
    n.dt_vencimento_nota_debito,
    n.ds_nota_debito,
    n.vl_nota_debito,
    c.nm_razao_social_cliente,
    '(' + c.cd_ddd + ') ' + c.cd_telefone as 'Telefone',
    b.cd_banco,
    b.nm_fantasia_banco,
    ab.cd_numero_agencia_banco,
    cab.nm_conta_banco,
    co.nm_fantasia_contato,
    cc.nm_centro_custo,
    a.nm_analista,
    n.cd_identificacao_cliente
  from 
    Nota_Debito_Despesa n left outer join
    CLiente c on c.cd_cliente = n.cd_cliente left outer join
    Cliente_Contato co on co.cd_cliente = n.cd_cliente and co.cd_contato = n.cd_contato left outer join
    Conta_Agencia_Banco cab on cab.cd_conta_banco = n.cd_conta_banco left outer join
    Banco b on b.cd_banco = cab.cd_banco left outer join
    Agencia_Banco ab on ab.cd_banco = cab.cd_banco and ab.cd_agencia_banco = cab.cd_agencia_banco
    left outer join Centro_Custo cc on cc.cd_centro_custo = n.cd_centro_custo
    left outer join Analista a         on a.cd_analista = n.cd_analista
  where
    ( ( n.cd_nota_debito_despesa = @cd_nota_debito ) or
      ( @cd_nota_debito = 0 and n.dt_pagto_nota_debito is null ) )
  order by
    n.cd_nota_debito_despesa

end

