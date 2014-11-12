create procedure dbo.pr_copia_operacao_fiscal 
@cd_operacao_fiscal int OUTPUT
As
declare 
        @Nova_chave int, -- novo codigo da operacao fiscal 
	@Tabela varchar(60)
-- Cria tabela temporária 
select *
into #operacao_fiscal_tmp
 from operacao_fiscal
where cd_operacao_fiscal = @cd_operacao_fiscal

-- Encontra novo codigo da operacao fiscal 
set @Nova_chave = 0

set @Tabela = DB_NAME() +'.dbo.Operacao_Fiscal'
exec EgisAdmin.dbo.sp_PegaCodigo @Tabela, 'cd_operacao_fiscal', @Nova_chave out
-- altera chave da tabela temporária'

update #operacao_fiscal_tmp set cd_operacao_fiscal = @Nova_chave
-- insere na tabela oficial'
insert into dbo.operacao_fiscal 
select * from #operacao_fiscal_tmp

-- libera codigo'
exec EgisAdmin.dbo.sp_LiberaCodigo @Tabela, @Nova_chave , 'D'
-- retorna registro inserido'
drop table #operacao_fiscal_tmp
-- retorna OutPut
set @cd_operacao_fiscal = @Nova_chave
