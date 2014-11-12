CREATE TABLE [dbo].[Agenda_Feriado] (
    [dt_agenda_feriado]     DATETIME     NOT NULL,
    [cd_feriado]            INT          NOT NULL,
    [nm_observacao_feriado] VARCHAR (30) NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Agenda_feriado] PRIMARY KEY CLUSTERED ([dt_agenda_feriado] ASC, [cd_feriado] ASC) WITH (FILLFACTOR = 90)
);


GO
create trigger ti_agenda_feriado
on Agenda_Feriado
after insert

as

--ti_agenda_feriado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo: Trigger para atualização da tabela Agenda
-- para lançamento do Agenda_Feriado
--Data: 27/01/2004
---------------------------------------------------

begin

 
 
  declare @dt_agenda_feriado datetime

  select
    @dt_agenda_feriado = dt_agenda_feriado
  from
    inserted p

  update Agenda
  set ic_util = 'N',
      ic_plantao_vendas = 'N',
      ic_financeiro = 'N',
      ic_fiscal = 'N',
      ic_fabrica_operacao = 'N',
      ic_financeira = 'N'
  where
    dt_agenda= @dt_agenda_feriado



end





GO

create trigger tU_agenda_feriado
on Agenda_Feriado
after update

as

--tU_agenda_feriado
---------------------------------------------------
--GBS - Global Business Solution	       2004
--Trigger: Microsoft SQL Server                2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo: Trigger para atualização da tabela Agenda após
--          modificações da Agenda_Feriado
--Data: 17/04/2004
---------------------------------------------------

begin

  -- somente executado caso exista conteúdo na tabela inserted
  if not exists(select top 1 * from inserted)
    return

  declare @dt_agenda_nova datetime
  declare @dt_agenda_velha datetime 

  select 
    i.dt_agenda_feriado as dt_agenda_nova,
    d.dt_agenda_feriado as dt_agenda_velha
  into
    #AgendaFeriado
  from 
    Inserted i inner join
    Deleted d on i.dt_agenda_feriado <> d.dt_agenda_feriado

  ----------------------------------------------------------------------
  -- Acertando Documentos que tiveram o plano_financeiro modificado.
  ----------------------------------------------------------------------   
  while exists (select top 1 * from #AgendaFeriado)
  begin
    Select 
  	top 1
      @dt_agenda_nova = dt_agenda_nova,
      @dt_agenda_velha = dt_agenda_velha
    from 
      #AgendaFeriado

    update Agenda
    set ic_util = 'S',
        ic_plantao_vendas = 'S',
        ic_financeiro = 'S',
        ic_fiscal = 'S',
        ic_fabrica_operacao = 'S',
        ic_financeira = 'S'
    where
     dt_agenda= @dt_agenda_velha

    update Agenda
    set ic_util = 'N',
        ic_plantao_vendas = 'N',
        ic_financeiro = 'N',
        ic_fiscal = 'N',
        ic_fabrica_operacao = 'N',
        ic_financeira = 'N'
    where
     dt_agenda= @dt_agenda_nova

    delete from #AgendaFeriado
    where 
      dt_agenda_velha = @dt_Agenda_velha and
      dt_agenda_nova = @dt_agenda_nova
  end

end





GO
create trigger td_agenda_feriado  
on Agenda_Feriado
for delete 

as

--td_agenda_feriado  
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo: Trigger para atualização da tabela Agenda
-- após feriado ser excluído.
-- excluído.
--Data: 17/04/2004
---------------------------------------------------

begin

  declare @dt_agenda_mudanca datetime

  select 
    d.dt_agenda_feriado
  into #DataFeriado
  from 
    Deleted d 

  ----------------------------------------------------------------------
  -- Acertando Documentos que tiveram o plano_financeiro modificado.
  ----------------------------------------------------------------------   
  while exists (select top 1 * from #DataFeriado)
  begin
    Select 
  	top 1
      @dt_agenda_mudanca = dt_agenda_feriado
    from 
      #DataFeriado

    update Agenda
    set ic_util = 'S',
        ic_plantao_vendas = 'S',
        ic_financeiro = 'S',
        ic_fiscal = 'S',
        ic_fabrica_operacao = 'S',
        ic_financeira = 'S'
    where
     dt_agenda= @dt_agenda_mudanca 

    delete from #DataFeriado
    where 
      dt_agenda_feriado = @dt_agenda_mudanca

  end


end


