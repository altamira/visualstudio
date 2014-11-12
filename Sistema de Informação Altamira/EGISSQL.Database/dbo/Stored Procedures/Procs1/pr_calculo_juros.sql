
create procedure pr_calculo_juros
@ic_parametro  int,
@cd_cliente    int,
@dt_base       datetime,
@dt_referencia datetime,
@vl_taxa       float

as

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- todos os documentos (Abertos)
-------------------------------------------------------------------------------
  begin

    select
      p.nm_portador,
      d.cd_cliente,
      c.nm_razao_social_cliente,
      case when isnull(c.cd_ddd,'')<>'' then
        '('+rtrim(c.cd_ddd)+')'+ltrim(c.cd_telefone)
      else
        ltrim(c.cd_telefone) end as 'cd_telefone_cliente',      
      d.cd_identificacao,
      d.dt_emissao_documento,
   
      --Verificar se houve baixa e pega a data do último pagamento-----------------------------------------------
      case when isnull( ( select top 1 cd_documento_receber from documento_receber_pagamento dp
                          where
                            dp.cd_documento_receber = d.cd_documento_receber ),0 ) <> 0
      then
       isnull(( select max(dp.dt_pagamento_documento) from
           documento_receber_pagamento dp
         where
           dp.cd_documento_receber = d.cd_documento_receber ),d.dt_vencimento_documento)
 
      else
        d.dt_vencimento_documento
      end                                 as 'dt_vencimento_documento',
   
      cast(d.vl_saldo_documento as float) as 'vl_documento_receber',
      cast(0 as int)                      as 'qt_dias',
      cast(0.00 as float)                 as 'vl_despesa',
      cast(0.00 as float)                 as 'vl_juros',
      cast(0.00 as float)                 as 'vl_total',
      'D'                                 as 'Tipo'
 --    d.dt_vencimento_documento            as 'dt_vencimento_base',
 --    d.dt_vencimento_original             as 'dt_vencimento_original'
 
   into
      #Documento_Receber
    from
      Documento_receber d with (nolock) 
    left outer join
      Cliente c
    on
      c.cd_cliente = d.cd_cliente
    left outer join
      Portador p
    on
      p.cd_portador = d.cd_portador  
    where
      d.cd_cliente = @cd_cliente and
      cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) <> 0 
      and d.dt_cancelamento_documento is null

    select
     'x' as 'nm_fornecedor',
      n.cd_cliente,
      c.nm_razao_social_cliente,
      case when isnull(c.cd_ddd,'')<>'' then
        '('+rtrim(c.cd_ddd)+')'+ltrim(c.cd_telefone)
      else
        ltrim(c.cd_telefone) end as 'cd_telefone_cliente',      
      n.cd_nota_debito as 'cd_identificacao',
      n.dt_nota_debito as 'dt_emissao_documento',
      n.dt_vencimento_nota_debito as 'dt_vencimento_documento',
      cast(n.vl_nota_debito as float) as 'vl_documento_receber',
      cast(0 as int) as 'qt_dias',
      cast(0.00 as float) as 'vl_despesa',
      cast(0.00 as float) as 'vl_juros',
      cast(0.00 as float) as 'vl_total',
      'N' as 'Tipo'
--     n.dt_vencimento_nota_debito            as 'dt_vencimento_base',
--     n.dt_vencimento_nota_debito             as 'dt_vencimento_original'

    into
      #Nota_Debito
    from
      Nota_Debito n with (nolock) 
    left outer join
      Cliente c
    on
      c.cd_cliente = n.cd_cliente
    where
      n.cd_cliente = @cd_cliente and
      n.dt_pagamento_nota_debito is null and
      n.dt_cancelamento_nota_debi is null

    insert into
      #Documento_receber
    select * from
      #Nota_Debito
      
    select * from 
      #Documento_Receber 
    order by 
      Tipo,
      dt_vencimento_documento

  end

-------------------------------------------------------------------------------
if @ic_parametro = 2   -- Documentos Vencidos
-------------------------------------------------------------------------------

begin
    select
      p.nm_portador,
      d.cd_cliente,
      c.nm_razao_social_cliente,
      case when isnull(c.cd_ddd,'')<>'' then
        '('+rtrim(c.cd_ddd)+')'+ltrim(c.cd_telefone)
      else
        ltrim(c.cd_telefone) end as 'cd_telefone_cliente',
      d.cd_identificacao,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      cast(d.vl_saldo_documento as float) as 'vl_documento_receber',
      cast(0 as int) as 'qt_dias',
      cast(0.00 as float) as 'vl_despesa',
      cast(0.00 as float) as 'vl_juros',
      cast(0.00 as float) as 'vl_total',
      'D' as 'Tipo'
    into
      #Documento_Receber2
    from
      Documento_receber d
    left outer join
      Cliente c
    on
      c.cd_cliente = d.cd_cliente
    left outer join
      Portador p
    on
      p.cd_portador = d.cd_portador  

    where
      d.cd_cliente = @cd_cliente and
      cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) <> 0 and
      d.dt_vencimento_documento < @dt_referencia
    order by
      d.dt_vencimento_documento

    select
     'x' as 'nm_fornecedor',
      n.cd_cliente,
      c.nm_razao_social_cliente,
      case when isnull(c.cd_ddd,'')<>'' then
        '('+rtrim(c.cd_ddd)+')'+ltrim(c.cd_telefone)
      else
        ltrim(c.cd_telefone) end as 'cd_telefone_cliente',
      n.cd_nota_debito as 'cd_identificacao',
      n.dt_nota_debito as 'dt_emissao_documento',
      n.dt_vencimento_nota_debito as 'dt_vencimento_documento',
      cast(n.vl_nota_debito as float) as 'vl_documento_receber',
      cast(0 as int) as 'qt_dias',
      cast(0.00 as float) as 'vl_despesa',
      cast(0.00 as float) as 'vl_juros',
      cast(0.00 as float) as 'vl_total',
      'N' as 'Tipo'
    into
      #Nota_Debito2
    from
      Nota_Debito n
    left outer join
      Cliente c
    on
      c.cd_cliente = n.cd_cliente
    where
      n.cd_cliente = @cd_cliente and
      n.dt_pagamento_nota_debito is null and
      n.dt_nota_debito < @dt_referencia

    insert into
      #Documento_receber2
    select * from
      #Nota_Debito2
      
    select * from 
      #Documento_Receber2 
    order by 
      Tipo,
      dt_vencimento_documento


  end

-------------------------------------------------------------------------------
if @ic_parametro = 3   -- Documentos não vencidos em Aberto
-------------------------------------------------------------------------------

begin
    select
      p.nm_portador,
      d.cd_cliente,
      c.nm_razao_social_cliente,
      case when isnull(c.cd_ddd,'')<>'' then
        '('+rtrim(c.cd_ddd)+')'+ltrim(c.cd_telefone)
      else
        ltrim(c.cd_telefone) end as 'cd_telefone_cliente',
      d.cd_identificacao,
      d.dt_emissao_documento,
      d.dt_vencimento_documento,
      cast(d.vl_saldo_documento as float) as 'vl_documento_receber',
      cast(0 as int) as 'qt_dias',
      cast(0 as float) as 'vl_despesa',
      cast(0 as float) as 'vl_juros',
      cast(0 as float) as 'vl_total',
      'D' as 'Tipo'
    into
      #Documento_Receber3
    from
      Documento_receber d
    left outer join
      Cliente c
    on
      c.cd_cliente = d.cd_cliente
    left outer join
      Portador p
    on
      p.cd_portador = d.cd_portador  
    where
      d.cd_cliente = @cd_cliente and
      cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) <> 0 and
      d.dt_vencimento_documento > @dt_referencia
    order by
      d.dt_vencimento_documento desc

    select
     'x' as 'nm_fornecedor',
      n.cd_cliente,
      c.nm_razao_social_cliente,
      case when isnull(c.cd_ddd,'')<>'' then
        '('+rtrim(c.cd_ddd)+')'+ltrim(c.cd_telefone)
      else
        ltrim(c.cd_telefone) end as 'cd_telefone_cliente',
      n.cd_nota_debito as 'cd_identificacao',
      n.dt_nota_debito as 'dt_emissao_documento',
      n.dt_vencimento_nota_debito as 'dt_vencimento_documento',
      cast(n.vl_nota_debito as float) as 'vl_documento_receber',
      cast(0 as int) as 'qt_dias',
      cast(0 as float) as 'vl_despesa',
      cast(0 as float) as 'vl_juros',
      cast(0 as float) as 'vl_total',
      'N' as 'Tipo'
    into
      #Nota_Debito3
    from
      Nota_Debito n
    left outer join
      Cliente c
    on
      c.cd_cliente = n.cd_cliente
    where
      n.cd_cliente = @cd_cliente and
      n.dt_pagamento_nota_debito is null and
      n.dt_nota_debito > @dt_referencia

    insert into
      #Documento_receber3
    select * from
      #Nota_Debito3
      
    select * from 
      #Documento_Receber3 
    order by 
      Tipo,
      dt_vencimento_documento



  end

