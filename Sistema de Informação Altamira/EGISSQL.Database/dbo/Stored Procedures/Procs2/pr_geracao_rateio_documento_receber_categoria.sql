
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_rateio_documento_receber_categoria
-------------------------------------------------------------------------------
--pr_geracao_rateio_documento_receber_categoria
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática do Rateio de Documentos a Receber
--                   Por Plano Financeiro através da Categoria do Produto
--Data             : 19.12.2007
--Alteração        : 21.12.2007
------------------------------------------------------------------------------
create procedure pr_geracao_rateio_documento_receber_categoria
@cd_nota_saida_origem int      = 0, --Por documento
@dt_inicial           datetime = '', --Data Inicial
@dt_final             datetime = '',  --Data Final,
@cd_usuario           int      = 0
 
as

------------------------------------------------------------------------------
--Verificar quando o Produto for Especial não está funcionando
--cd_produto = 0
------------------------------------------------------------------------------


declare @ic_rateio_plano_categoria char(1)

select
  @ic_rateio_plano_categoria = isnull(ic_rateio_plano_categoria,'N')
from
  parametro_financeiro
where
  cd_empresa = dbo.fn_empresa()


if @ic_rateio_plano_categoria = 'S'
begin

  if @cd_nota_saida_origem>0
  begin
    select 
      @dt_inicial = dt_nota_saida,
      @dt_final   = dt_nota_saida
    from
      nota_saida
    where
      cd_nota_saida = @cd_nota_saida_origem
  end

  --select * from nota_saida_item
  --select * from categoria_produto

  select
    ns.cd_nota_saida,
    cp.cd_plano_financeiro,
    --sum ( nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota ) 
    sum (  isnull(nsi.vl_total_item,0) )                      as vl_total_item,
    sum ( (isnull(nsi.vl_total_item,0) / ns.vl_produto)*100 ) as pc_plano_financeiro
--    0.00                                                      as vl_plano_financeiro
  into
    #RateioCategoriaProduto
  from
    nota_saida_item nsi
    inner join nota_saida        ns on ns.cd_nota_saida        = nsi.cd_nota_saida
    inner join categoria_produto cp on cp.cd_categoria_produto = nsi.cd_categoria_produto
  where
    ns.cd_nota_saida = case when @cd_nota_saida_origem = 0 then ns.cd_nota_saida else @cd_nota_saida_origem end and
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    --isnull(cp.cd_plano_financeiro,0)>0                 and
    ns.cd_nota_saida in ( select cd_nota_saida from documento_receber )
  group by
    ns.cd_nota_saida,
    cp.cd_plano_financeiro
  
  --select * from #RateioCategoriaProduto order by cd_nota_saida

  --deleta todas as notas de saída da tabela de Documento a Receber

  delete from documento_receber_plano_financ where cd_nota_saida in ( select cd_nota_saida from #RateioCategoriaProduto)

  declare @cd_nota_saida       int
  declare @cd_plano_financeiro int 
  declare @pc_plano_financeiro float

  while exists ( select top 1 cd_nota_saida from #RateioCategoriaProduto )
  begin
    select top 1 
      @cd_nota_saida       = cd_nota_saida,
      @cd_plano_financeiro = cd_plano_financeiro,
      @pc_plano_financeiro = pc_plano_financeiro
    from
      #RateioCategoriaProduto

    --Montagem da Tabela temporária para inserção

    select
      d.cd_documento_receber,
      @cd_plano_financeiro as cd_plano_financeiro,
      @pc_plano_financeiro as pc_plano_financeiro,
      d.vl_documento_receber * ( @pc_plano_financeiro/100) as vl_plano_financeiro,
      @cd_usuario          as cd_usuario,
      getdate()            as dt_usuario,
      @cd_nota_saida       as cd_nota_saida
    into
      #documento_receber_plano_financ
    from
      documento_receber d  
    where
      d.cd_nota_saida = @cd_nota_saida
             
    insert into documento_receber_plano_financ
      select 
        *
      from
        #documento_receber_plano_financ

    drop table #documento_receber_plano_financ

        
    delete from #RateioCategoriaProduto 
    where 
      @cd_nota_saida = cd_nota_saida and
      @cd_plano_financeiro = cd_plano_financeiro
     

  end


  --select * from documento_receber where cd_nota_saida = 500727
  --select * from documento_receber_plano_financ
  --delete from documento_receber_plano_financ
  --select cd_categoria_produto,vl_total_item,* from nota_saida_item where cd_nota_saida = 500727
  
        

end


