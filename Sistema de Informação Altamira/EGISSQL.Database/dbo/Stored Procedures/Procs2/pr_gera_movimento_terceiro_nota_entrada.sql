
-------------------------------------------------------------------------------
--sp_helptext pr_gera_movimento_terceiro_nota_entrada
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera Movimento de Terceiro
--Data             : 06.03.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_movimento_terceiro_nota_entrada
@dt_inicial           datetime = '',
@dt_final             datetime = '',
@cd_nota_entrada      int      = 0,
@cd_fornecedor        int      = 0,
@cd_operacao_fiscal   int      = 0,
@cd_serie_nota_fiscal int      = 0,
@cd_usuario           int      = 0

as

--select * from movimento_produto_terceiro

declare @Tabela		     varchar(80)
declare @cd_movimento_produto_terceiro int


-- Nome da Tabela usada na geração e liberação de códigos

set @Tabela = cast(DB_NAME()+'.dbo.Movimento_Produto_Terceiro' as varchar(80))

exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_produto_terceiro', @codigo = @cd_movimento_produto_terceiro output
	
  while exists(Select top 1 'x' from Movimento_Produto_Terceiro where cd_movimento_produto_terceiro = @cd_movimento_produto_terceiro)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_produto_terceiro', @codigo = @cd_movimento_produto_terceiro output

    -- limpeza da tabela de código

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_produto_terceiro, 'D'

  end




--select * from nota_entrada

-- insert into Movimento_Produto_Terceiro (
--   cd_movimento_produto_terceiro,
--   cd_produto,
--   cd_nota_entrada,
--   cd_tipo_destinatario,
--   cd_destinatario,
--   cd_serie_nota_fiscal,
--   cd_operacao_fiscal,
--   cd_item_nota_fiscal,
--   ic_tipo_movimento,
--   dt_movimento_terceiro,
--   qt_movimento_terceiro,
--   cd_usuario,
--   dt_usuario )


--select * from nota_entrada
--select * from nota_entrada_item

select
  identity(int,1,1)                  as cd_controle,
  case when isnull(p.cd_produto_baixa_estoque,0)=0
  then
    nei.cd_produto
  else
    p.cd_produto_baixa_estoque
  end                                as cd_produto,
  ne.cd_nota_entrada,
  ne.cd_tipo_destinatario,
  ne.cd_fornecedor                   as cd_destinatario,
  ne.cd_serie_nota_fiscal,
  ne.cd_operacao_fiscal,
  nei.cd_item_nota_entrada           as cd_item_nota_fiscal,
  'E'                                as ic_tipo_movimento,
  ne.dt_receb_nota_entrada           as dt_movimento_terceiro,
  nei.qt_item_nota_entrada           as qt_movimento_terceiro,
  case when isnull(@cd_usuario,0)=0 
  then
    isnull(ne.cd_usuario,0)
  else
    @cd_usuario             
  end                               as cd_usuario,
  ne.dt_usuario,

  isnull((select top 1 'S' from movimento_produto_terceiro where cd_produto           = nei.cd_produto           and
                                                          cd_nota_entrada      = nei.cd_nota_entrada         and
                                                          cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal    and
                                                          cd_item_nota_fiscal  = nei.cd_item_nota_entrada ),'N') as ic_gerado,
  0 as cd_movimento_produto_terceiro
  
into
  #NotaEntradaTerceiro

from
  Nota_Entrada ne with (nolock)
  inner join Nota_Entrada_item nei on  ne.cd_fornecedor        = nei.cd_fornecedor      and 
                                       ne.cd_nota_entrada      = nei.cd_nota_entrada    and
                                       ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal and
                                       ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
  inner join operacao_fiscal opf   on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal
  inner join produto p             on p.cd_produto             = nei.cd_produto
 
where
  ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
  ne.cd_fornecedor                     = case when @cd_fornecedor        = 0 then ne.cd_fornecedor        else @cd_fornecedor        end and 
  ne.cd_nota_entrada                   = case when @cd_nota_entrada      = 0 then ne.cd_nota_entrada      else @cd_nota_entrada      end and
  ne.cd_operacao_fiscal                = case when @cd_operacao_fiscal   = 0 then ne.cd_operacao_fiscal   else @cd_operacao_fiscal   end and
  ne.cd_serie_nota_fiscal              = case when @cd_serie_nota_fiscal = 0 then ne.cd_serie_nota_fiscal else @cd_serie_nota_fiscal end and
  isnull(opf.ic_terceiro_op_fiscal,'N') = 'S'


update
  #NotaEntradaTerceiro
set
  cd_movimento_produto_terceiro = cd_controle + @cd_movimento_produto_terceiro


select * from #NotaEntradaTerceiro where ic_gerado = 'N'


insert into Movimento_Produto_Terceiro (
  cd_movimento_produto_terceiro,
  cd_produto,
  cd_nota_entrada,
  cd_tipo_destinatario,
  cd_destinatario,
  cd_serie_nota_fiscal,
  cd_operacao_fiscal,
  cd_item_nota_fiscal,
  ic_tipo_movimento,
  dt_movimento_terceiro,
  qt_movimento_terceiro,
  cd_usuario,
  dt_usuario )
select
   cd_movimento_produto_terceiro,
  cd_produto,
  cd_nota_entrada,
  cd_tipo_destinatario,
  cd_destinatario,
  cd_serie_nota_fiscal,
  cd_operacao_fiscal,
  cd_item_nota_fiscal,
  ic_tipo_movimento,
  dt_movimento_terceiro,
  qt_movimento_terceiro,
  cd_usuario,
  dt_usuario
from
  #NotaEntradaTerceiro
where
  ic_gerado = 'N'



--select * from nota_entrada_item
  
-- values (
--   :cd_movimento_produto_terceiro,
--   :cd_produto,
--   :cd_nota_entrada,
--   :cd_tipo_destinatario,
--   :cd_destinatario,
--   :cd_serie_nota_fiscal,
--   :cd_operacao_fiscal,
--   :cd_item_nota_fiscal,
--   'E',
--   :dt_movimento_terceiro,
--   :qt_movimento_terceiro,
--   :cd_usuario,
--   :dt_usuario )
-- 
-- 
-- 
--select * from movimento_produto_terceiro order by cd_movimento_produto_terceiro

