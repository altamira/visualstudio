
CREATE PROCEDURE pr_consulta_documento_sem_vendedor

@cd_documento Integer,
@dt_inicial  datetime,
@dt_final    datetime,
@ic_corrigir_vendedores char(1) = 'N'

AS
  set @ic_corrigir_vendedores = isnull(@ic_corrigir_vendedores,'N')

select
  cli.nm_fantasia_cliente,
  dr.cd_documento_receber,
  dr.dt_emissao_documento,
  dr.dt_vencimento_documento,
  dr.vl_saldo_documento,
  dr.vl_documento_receber,
  dr.dt_pagto_document_receber,
  dr.vl_pagto_document_receber,
  dr.cd_nota_saida,
  cli.cd_cliente 
into
   #DocumentoReceberSemVendedor

from
  Documento_Receber dr
  LEFT OUTER JOIN
  Cliente cli
  ON
  dr.cd_cliente = cli.cd_cliente
where
  dr.cd_vendedor = 0 and
 ((dr.cd_documento_receber = @cd_documento) or (@cd_documento = ''))and
 (dr.dt_vencimento_documento between @dt_inicial and @dt_final)  

order by
  dr.dt_emissao_documento desc


  -- Corrigir os Vendedores

  if ( @ic_corrigir_vendedores = 'S' )
  begin
   
    print 'Atualizando..'

    declare @cd_documento_receber int,
            @cd_Vendedor int
  
    declare cr cursor for
      select
        dr.cd_documento_receber,
        case when ( isnull(ns.cd_vendedor,0) = 0 )
          then c.cd_vendedor
          else ns.cd_vendedor
        end as 'cd_vendedor'
      from 
        #DocumentoReceberSemVendedor dr
      
        inner join nota_saida ns on
          ns.cd_nota_saida = dr.cd_nota_saida
              
        left outer join Cliente c on
          ns.cd_tipo_destinatario = 1 and       
          c.cd_cliente = ns.cd_cliente
      
      
    open cr 

    FETCH NEXT FROM cr
      into @cd_documento_receber,
           @cd_Vendedor

    while (@@fetch_status = 0) --não chegou no fim do  arquivo
    begin

    if @cd_Vendedor is not null
      begin
        update documento_receber
         set cd_vendedor = @cd_Vendedor
         where cd_documento_receber = @cd_documento_receber
      end              

      FETCH NEXT FROM cr
        into @cd_documento_receber,
             @cd_Vendedor

    end

    close cr
    deallocate cr
    
  end
  else
  begin
    print 'Selecionando..'

    select * from #DocumentoReceberSemVendedor
  end

