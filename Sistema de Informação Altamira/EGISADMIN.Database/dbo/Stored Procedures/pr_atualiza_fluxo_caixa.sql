
CREATE PROCEDURE pr_atualiza_fluxo_caixa
  @ic_parametro int,
  @dt_inicial datetime,
  @dt_final datetime,
  @cd_usuario int

AS

declare @cd_movimento int
declare @cont int
declare @cont_temp int

-------------------------------------------------------
if @ic_parametro = 1 -- Atualiza SCP
-------------------------------------------------------
begin
declare @dt_documento_pagar datetime
declare @cont2 int -- Contador para Verificar o while do Documento_Pagar
declare @cont3 int -- Contador para verificar o While do #Selecao
set @cont = 0 
set @cont3 = 0
set @dt_documento_pagar = @dt_inicial

 -- Numero de Vezes que eu vou verificar a tabela de documento_pagar.
-- while @cont <> ( select count(cd_documento_pagar) from Documento_Pagar where vl_saldo_documento_pagar > 0 and
--                         dt_cancelamento_documento is null and
--                         dt_vencimento_documento = @dt_documento_pagar group by dt_emissao_documento_paga)

--  begin
    -- pegando e Agrupando Por Data e Plano Financeiro.
    exec EgisADMIN.dbo.sp_PegaCodigo 'EgisSQL.dbo.Plano_Financeiro_Movimento', 'cd_movimento', @codigo = @cd_movimento output
    select
      identity(int , 1,1)           as 'Codigo',
      sum(vl_saldo_documento_Pagar) as 'Saldo',
      dt_emissao_documento_paga     as 'Emissao',
      cd_plano_financeiro           as 'Plano'
    into #Selecao
    from
      Documento_Pagar 
    where
      vl_saldo_documento_pagar > 0 and
      dt_cancelamento_documento is null and
      convert(datetime, cast(dt_vencimento_documento as int), 101 ) between @dt_inicial and @dt_final and
      cd_plano_financeiro is not null 
    group by dt_emissao_documento_paga, cd_plano_financeiro

--    select * from #Selecao
    -- Caso já exista Documentos com a mesma data, verificar se há mudança no saldo e atualizar novo saldo.

    update Plano_Financeiro_Movimento 
    set vl_plano_financeiro = s.Saldo 
    from Plano_Financeiro_Movimento pm, #Selecao s 
    where 
      s.cd_plano_financeiro = pm.cd_plano_financeiro and
      s.dt_emissao_documento_paga = pm.dt_movto_plano_financeiro and
      s.Saldo <> pm.vl_plano_financeiro

    -- Atualizando dt_fluxo_doc_pagar, verificar como proceder caso só precise ser gravado quando for atualizado.
/*    update Documento_Pagar 
    set dt_fluxo_docto_pagar = convert(datetime, cast(getdate() as int), 101)
    where
      vl_saldo_documento_pagar > 0 and
      dt_cancelamento_documento is null and
      convert(datetime, cast(dt_vencimento_documento as int), 101 ) = @dt_documento_pagar and
      cd_plano_financeiro is not null and dt_fluxo_docto_pagar is null 

    -- Inserindo e Atualizando Dados no Plano_Financeiro_Movimento
    -- Coloquei esse while para caso o #Selecao Retornar mais de um valor. ( O cd_Plano_financeiro tem mais de um valor.)
    set @cont3 = 0
    while @cont_temp <> ( select cont3 = cont3 + count(Codigo) from #Selecao )
      begin
        exec EgisADMIN.dbo.sp_PegaCodigo 'EgisSQL.dbo.Plano_Financeiro_Movimento', 'cd_movimento', @codigo = @cd_movimento output
        insert into 
          Plano_Financeiro_Movimento
        select 
          @cd_movimento,
          1,
          1,
          GetDate(),
          s.Saldo,
          'Atualização Automática SCP',
          1,
          1,
          1,
          @cd_usuario,
          GetDate()
        from
          Plano_Financeiro_Movimento pm, #Selecao s
        where
          s.dt_emissao_documento_paga <> pm.dt_movto_plano_financeiro
        set @cont_temp = @cont_temp + 1
        exec EgisADMIN.dbo.sp_LiberaCodigo 'EgisSQL.dbo.Plano_Financeiro_Movimento', @cd_movimento, 'D'
      end
    -- Verifiquei 1 vez o Documento_Pagar
    set @cont = @cont + 1
    -- Pegando outra data.
    set @dt_documento_pagar = ( select top 1 dt_emissao_documento_paga from Documento_Pagar where vl_saldo_documento_pagar > 0 and
                                                                                           dt_cancelamento_documento is null and
                                                                                           dt_vencimento_documento between @dt_inicial and @dt_final and
                                                                                           dt_vencimento_documento > @dt_documento_pagar)
*/   
    drop table #Selecao

--  end
end

-------------------------------------------------------
if @ic_parametro = 2 -- Atualiza SCR
-------------------------------------------------------
begin
declare @cd_documento_receber int
set @cont = 0 
set @cd_documento_receber = 0

 while @cont <> ( select count(cd_documento_receber) from Documento_Receber where  vl_saldo_documento > 0 and
   dt_cancelamento_documento is null and
   dt_vencimento_documento between @dt_inicial and @dt_final )
  begin

    -- pegando o Documento Posterior da tabela de Documento_Receber
     set @cd_documento_receber = ( select top 1 cd_documento_receber from Documento_Receber where    vl_saldo_documento > 0 and
   dt_cancelamento_documento is null and
   dt_vencimento_documento between @dt_inicial and @dt_final and cd_documento_receber > @cd_documento_receber)

     exec EgisADMIN.dbo.sp_PegaCodigo 'EgisSQL.dbo.Plano_Financeiro_Movimento', 'cd_movimento', @codigo = @cd_movimento output

     select
        @cd_movimento             as 'Codigo',
        vl_saldo_documento        as 'Saldo',
        dt_emissao_documento      as 'Emissao',
        cd_plano_financeiro       as 'Plano',
        dt_fluxo_docto_receber    as 'Fluxo'

     into #Selecao_Receber
     from
        Documento_Receber
     where
        vl_saldo_documento > 0 and
        dt_cancelamento_documento is null and
        dt_vencimento_documento between @dt_inicial and @dt_final and
        cd_documento_receber = @cd_documento_receber

--     print(cast(@codigo as varchar(30))
    -- Apagando dt_fluxo_doc_pagar
      update Documento_Receber
      set dt_fluxo_docto_receber = Null
      where
       vl_saldo_documento > 0 and
       dt_cancelamento_documento is null and
       dt_vencimento_documento between @dt_inicial and @dt_final and
       cd_documento_receber = @cd_documento_receber

-- Inserindo e Atualizando Dados no Plano_Financeiro_Movimento
      insert into 
        Plano_Financeiro_Movimento
      select 
        Codigo,
        1,
        1,
        GetDate(),
        Saldo,
        'Atualização Automática',
        1,
        1,
        1,
        @cd_usuario,
        GetDate()
      from
        #Selecao_Receber
--      select * from #Selecao
      drop table #Selecao_Receber
      set @cont = @cont + 1
      exec EgisADMIN.dbo.sp_LiberaCodigo 'EgisSQL.dbo.Plano_Financeiro_Movimento', @cd_movimento, 'D'

  end
end


