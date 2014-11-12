
create procedure pr_acerta_nota_saida_livro
@cd_nota_saida int,
@cd_usuario int

as    

declare @contabil 	decimal(25,2)
declare @naocoml        decimal(25,2)
declare @bcipi 		decimal(25,2)
declare @ipi 		decimal(25,2)
declare @pc_ipi 	decimal(25,2)
declare @ipiisento 	decimal(25,2)
declare @ipioutras 	decimal(25,2)
declare @ipiobs 	decimal(25,2)
declare @bcicms 	decimal(25,2)
declare @icms 		decimal(25,2)
declare @pc_icms 	decimal(25,2)
declare @icmsisento 	decimal(25,2)
declare @icmsoutras 	decimal(25,2)
declare @icmsobs 	decimal(25,2)
declare @frete          decimal(25,2)
declare @seguro		decimal(25,2)
declare @despacess	decimal(25,2)
declare @produto	decimal(25,2)

declare @cd_item_nota_saida 	int
declare @cd_operacao_fiscal 	int
declare @cd_estado 		int
declare @cd_registro 		int

declare @sg_estado char(2)
declare @dt_nota_saida datetime

print('Carregando Totais')
-- Declaração do vl_produto vai receber o mesmo do @contabil (Aguardando Calcuro correto ) Alexandre - 19/02/2004
select 
  @contabil 	= (sum(isnull(nsir.vl_contabil_item_nota,0))),
  @naocoml      = sum(case when isnull(opf.ic_comercial_operacao,'N') <> 'S' then
                        isnull(nsir.vl_contabil_item_nota,0)
                      else
                        0
                      end),
  @bcipi 	= sum(isnull(nsir.vl_base_ipi_item_nota,0)),
  @ipi 		= sum(isnull(nsir.vl_ipi_item_nota_saida,0)),
  @ipiisento 	= sum(isnull(nsir.vl_ipi_isento_item_nota,0)),
  @ipioutras 	= sum(isnull(nsir.vl_ipi_outras_item_nota,0)),
  @ipiobs 	= sum(isnull(nsir.vl_ipi_obs_item_nota,0)),
  @bcicms 	= sum(isnull(nsir.vl_base_icms_item_nota,0)),
  @icms 	= sum(isnull(nsir.vl_icms_item_nota_saida,0)),
  @icmsisento 	= sum(isnull(nsir.vl_icms_isento_item_nota,0)),
  @icmsoutras 	= sum(isnull(nsir.vl_icms_outras_item_nota,0)),
  @icmsobs 	= sum(isnull(nsir.vl_icms_obs_item_nota,0)),
  @frete        = sum(isnull(nsir.vl_frete_item_nota_saida,0)),
  @seguro       = sum(isnull(nsir.vl_seguro_item_nota_saida,0)),
  @despacess    = sum(isnull(nsir.vl_desp_acess_item_nota,0)),
  @produto 	= (sum(isnull(nsir.vl_contabil_item_nota,0))-(sum(isnull(nsir.vl_ipi_item_nota_saida,0)))-sum(isnull(nsir.vl_icms_item_nota_saida,0)))
from
  nota_saida_item_registro nsir
left outer join
  Operacao_Fiscal opf
on
  opf.cd_operacao_fiscal = nsir.cd_operacao_fiscal
where 
  nsir.cd_nota_saida = @cd_nota_saida 

--  isnull(opf.ic_comercial_operacao,0) <> 'N'


print   @contabil 
print   @bcipi 	

print('Carregando Estado e Data')
-- CARREGANDO O ESTADO E A DATA
select
  top 1
  @dt_nota_saida = dt_nota_saida,
  @sg_estado = sg_estado
from
  nota_saida_item_registro
where
  cd_nota_saida = @cd_nota_saida

print('Identificando Código do Estado')
-- IDENTIFICANDO O CÓDIGO DO ESTADO
select
  @cd_estado = cd_estado
from
  Estado
where
  sg_estado = @sg_estado and
  cd_pais = 1 -- BRASIL

print('@contabil '+cast(@contabil as varchar))
print('@naocoml '+cast(@naocoml as varchar))

print('Acertando Cabecalho da Nota')
-- ACERTANDO TOTAIS NO CABEÇALHO DA NOTA
update nota_saida
set  
  sg_estado_nota_saida 	= @sg_estado,
  dt_nota_saida 	= @dt_nota_saida,
  vl_produto            = case when @contabil = @naocoml then @contabil - @ipi else (@contabil - @naocoml) - @ipi end,
  vl_total 		= case when @contabil = @naocoml then @contabil else (@contabil - @naocoml) end,
  vl_bc_ipi 		= @bcipi,
  vl_ipi 		= @ipi,
  vl_ipi_isento 	= @ipiisento,
  vl_ipi_outros 	= @ipioutras,
  vl_ipi_obs 		= @ipiobs,
  vl_bc_icms 		= @bcicms,
  vl_icms 		= @icms,
  vl_icms_isento 	= @icmsisento,
  vl_icms_outros 	= @icmsoutras,
  vl_icms_obs 		= @icmsobs,
  vl_frete              = @frete,
  vl_seguro             = @seguro,
  vl_desp_acess         = @despacess,
  cd_usuario 		= @cd_usuario,
  dt_usuario 		= getdate()
from
  nota_saida
where
  cd_nota_saida = @cd_nota_saida

select vl_total from nota_saida where cd_nota_saida = @cd_nota_saida

-- print('Tabela Temporaria ')
-- select * 
-- into
--    #nota_saida_item_registro
-- from
--   nota_saida_item_registro
-- 
--print('Delete Nota_Saida_registro')
-- delete from Nota_Saida_registro where cd_nota_saida = @cd_nota_saida

print('Limpando Variáveis')
-- LIMPANDO VARIÁVEIS DE TOTAIS PARA NOVO CÁLCULO
set @contabil   = 0.00
set @naocoml    = 0.00
set @bcipi      = 0.00
set @ipi        = 0.00
set @ipiisento  = 0.00
set @ipioutras  = 0.00
set @ipiobs     = 0.00
set @bcicms     = 0.00
set @icms       = 0.00
set @icmsisento = 0.00
set @icmsoutras = 0.00
set @icmsobs    = 0.00
set @frete      = 0.00
set @seguro     = 0.00
set @despacess  = 0.00

set @cd_operacao_fiscal = 0

-- ACERTANDO OS ITENS E NOTA_SAIDA_REGISTRO
declare cCursor cursor for
  select cd_item_nota_saida from nota_saida_item
  where cd_nota_saida = @cd_nota_saida

open cCursor

fetch next from cCursor into @cd_item_nota_saida
while @@fetch_status = 0 
begin

print('Carregando Totais ')

-- CARREGANDO TOTAIS
select 
   @contabil 	= @contabil 	+ (isnull(nsir.vl_contabil_item_nota,0)),
   @naocoml     = @naocoml      + case when isnull(opf.ic_comercial_operacao,'N') <> 'S' then
                                    (isnull(nsir.vl_contabil_item_nota,0))
                                  else
                                    0
                                  end,
   @bcipi 	= @bcipi 	+ isnull(nsir.vl_base_ipi_item_nota,0),
   @ipi 	= @ipi 		+ isnull(nsir.vl_ipi_item_nota_saida,0),
   @ipiisento 	= @ipiisento 	+ isnull(nsir.vl_ipi_isento_item_nota,0),
   @ipioutras 	= @ipioutras 	+ isnull(nsir.vl_ipi_outras_item_nota,0),
   @ipiobs 	= @ipiobs 	+ isnull(nsir.vl_ipi_obs_item_nota,0),
   @bcicms 	= @bcicms 	+ isnull(nsir.vl_base_icms_item_nota,0),
   @icms 	= @icms 	+ isnull(nsir.vl_icms_item_nota_saida,0),
   @icmsisento 	= @icmsisento 	+ isnull(nsir.vl_icms_isento_item_nota,0),
   @icmsoutras 	= @icmsoutras 	+ isnull(nsir.vl_icms_outras_item_nota,0),
   @icmsobs 	= @icmsobs 	+ isnull(nsir.vl_icms_obs_item_nota,0),
   @frete	= @frete 	+ isnull(nsir.vl_frete_item_nota_saida,0),
   @seguro  	= @seguro	+ isnull(nsir.vl_seguro_item_nota_saida,0),
   @despacess	= @despacess	+ isnull(nsir.vl_desp_acess_item_nota,0)
 from
   nota_saida_item_registro nsir
 left outer join
   Operacao_Fiscal opf
 on
   opf.cd_operacao_fiscal = nsir.cd_operacao_fiscal
 where 
   nsir.cd_nota_saida = @cd_nota_saida and
   nsir.cd_item_nota_saida = @cd_item_nota_saida 

print   @contabil 
print   @bcipi 	


print('Entrando no Cursor')

-- VERIFICANDO OCORRÊNCIA DE NOVA CFOP
if @cd_operacao_fiscal <> (select 
                             cd_operacao_fiscal
                           from
                             Nota_Saida_Item_Registro
                           where
                             nota_saida_item_registro.cd_nota_saida = @cd_nota_saida and
                             nota_saida_item_registro.cd_item_nota_saida = @cd_item_nota_saida)
  begin

    print('Encontrou CFOP Diferente')

    -- CARREGANDO OS PERCENTUAIS DE ICMS E IPI
    select
      @pc_icms = pc_icms_item_nota_saida,
      @pc_ipi = pc_ipi_item_nota_saida
    from
      nota_saida_item_registro 
    where
      cd_nota_saida = @cd_nota_saida and
      cd_item_nota_saida = @cd_item_nota_saida

    print('Carregando Nova CFOP')

    -- CARREGANDO A NOVA CFOP
    select 
      @cd_operacao_fiscal = cd_operacao_fiscal
    from
      Nota_Saida_Item_Registro
    where
      nota_saida_item_registro.cd_nota_saida = @cd_nota_saida and
      nota_saida_item_registro.cd_item_nota_saida = @cd_item_nota_saida

    -- ACERTANDO O NOTA_SAIDA_REGISTRO CASO ENCONTRE A CFOP
    if exists(select top 1 cd_operacao_fiscal
              from Nota_Saida_Registro
              where cd_nota_saida = @cd_nota_saida and
                    cd_operacao_fiscal = @cd_operacao_fiscal)
    begin

      print('Atualizando NotaSaidaRegistro')

      update nota_saida_registro
      set
        vl_contabil_nota_saida 		= case when @contabil = @naocoml then @contabil - @ipi else (@contabil - @naocoml)-@ipi end,
        vl_base_ipi_nota_saida 		= @bcipi,
        vl_ipi_nota_saida 		= @ipi,
        vl_ipi_isento_nota_saida 	= @ipiisento,
        vl_ipi_outras_nota_saida 	= @ipioutras,
        vl_ipi_obs_nota_saida 		= @ipiobs,
        vl_base_icms_nota_saida 	= @bcicms,
        vl_icms_nota_saida 		= @icms,
        vl_icms_isento_nota_saida 	= @icmsisento,
        vl_icms_outras_nota_saida 	= @icmsoutras,
        vl_icms_obs_nota_saida 		= @icmsobs, 
	vl_frete_nota_saida		= @frete,
	vl_seguro_nota_saida		= @seguro,
	vl_desp_acess_nota_saida	= @despacess,
        pc_aliq_ipi_nota_saida 		= @pc_ipi,
        pc_aliq_icms_nota_saida 	= @pc_icms,
        cd_usuario 			= @cd_usuario,
        dt_usuario 			= GetDate(),
        ic_fiscal_nota_saida_reg 	= 'S',
        ic_manual_nota_saida_reg 	= 'S'
      where
        cd_nota_saida = @cd_nota_saida and 
        cd_operacao_fiscal = @cd_operacao_fiscal

    end
  else
    begin

      -- ENCONTRANDO NOVO CÓDIGO DE REGISTRO
      select @cd_registro = isnull(max(cd_item_nota_saida_regist),0)+1
      from Nota_Saida_Registro
      where cd_nota_saida = @cd_nota_saida

      print('Inserindo NotaSaidaRegistro');
      
      -- INSERINDO NOVO REGISTRO
      insert into nota_saida_registro
        (cd_nota_saida,
        cd_operacao_fiscal,
        cd_item_nota_saida_regist,
        vl_contabil_nota_saida,
        vl_base_ipi_nota_saida,
        vl_ipi_nota_saida,
        vl_ipi_isento_nota_saida,
        vl_ipi_outras_nota_saida,
        vl_ipi_obs_nota_saida,
        vl_base_icms_nota_saida,
        vl_icms_nota_saida,
        vl_icms_isento_nota_saida,
        vl_icms_outras_nota_saida,
        vl_icms_obs_nota_saida,
        vl_frete_nota_saida,
        vl_seguro_nota_saida,
        vl_desp_acess_nota_saida,
        pc_aliq_ipi_nota_saida,
        pc_aliq_icms_nota_saida,
        cd_usuario,
        dt_usuario,
        ic_fiscal_nota_saida_reg,
        ic_manual_nota_saida_reg)
      values (@cd_nota_saida,
              @cd_operacao_fiscal,
              @cd_registro,
              case when @contabil = @naocoml then @contabil - @ipi else (@contabil - @naocoml) - @ipi end,
              @bcipi,
              @ipi,
              @ipiisento,
              @ipioutras,
              @ipiobs,
              @bcicms,
              @icms,
              @icmsisento,
              @icmsoutras,
              @icmsobs,
              @frete,
              @seguro,
              @despacess,
              @pc_ipi,               
              @pc_icms,
              @cd_usuario,
              GetDate(),
              'S',
              'S')

    end     

    print('Limpando Variáveis') 

    -- LIMPANDO VARIÁVEIS DE TOTAIS PARA NOVO CÁLCULO
    set @contabil   = 0.00
    set @naocoml    = 0.00
    set @bcipi      = 0.00
    set @ipi        = 0.00
    set @ipiisento  = 0.00
    set @ipioutras  = 0.00
    set @ipiobs     = 0.00
    set @bcicms     = 0.00
    set @icms       = 0.00
    set @icmsisento = 0.00
    set @icmsoutras = 0.00
    set @icmsobs    = 0.00
    set @frete      = 0.00
    set @seguro     = 0.00
    set @despacess  = 0.00

  end

print('Acertando Item')

-- ACERTO DO ITEM DA NOTA FISCAL
update 
  nota_saida_item
set
  dt_nota_saida = nota_saida_item_registro.dt_nota_saida,
  cd_operacao_fiscal = nota_saida_item_registro.cd_operacao_fiscal,
  vl_total_item = case when (isnull(ic_tipo_nota_saida_item,'P') = 'P') then
                    isnull(nota_saida_item_registro.vl_contabil_item_nota,0) - 
                    isnull(nota_saida_item_registro.vl_ipi_item_nota_saida,0) -
		    isnull(nota_saida_item_registro.vl_frete_item_nota_saida,0) -
		    isnull(nota_saida_item_registro.vl_seguro_item_nota_saida,0) -
                    isnull(nota_saida_item_registro.vl_desp_acess_item_nota,0)
                  else
                    isnull(nota_saida_item_registro.vl_contabil_item_nota,0)
                  end,
  vl_icms_item = nota_saida_item_registro.vl_icms_item_nota_saida,
  pc_icms = nota_saida_item_registro.pc_icms_item_nota_saida,
  vl_base_icms_item = nota_saida_item_registro.vl_base_icms_item_nota,
  vl_icms_isento_item = nota_saida_item_registro.vl_icms_isento_item_nota,
  vl_icms_outros_item = nota_saida_item_registro.vl_icms_outras_item_nota,
  vl_icms_obs_item = nota_saida_item_registro.vl_icms_obs_item_nota,
  vl_ipi = nota_saida_item_registro.vl_ipi_item_nota_saida,
  pc_ipi = nota_saida_item_registro.pc_ipi_item_nota_saida,
  vl_base_ipi_item = nota_saida_item_registro.vl_base_ipi_item_nota,  
  vl_ipi_isento_item = nota_saida_item_registro.vl_ipi_isento_item_nota,
  vl_ipi_outros_item = nota_saida_item_registro.vl_ipi_outras_item_nota,
  vl_ipi_obs_item = nota_saida_item_registro.vl_ipi_obs_item_nota,
  vl_frete_item = nota_saida_item_registro.vl_frete_item_nota_saida,
  vl_seguro_item = nota_saida_item_registro.vl_seguro_item_nota_saida,
  vl_desp_acess_item = nota_saida_item_registro.vl_desp_acess_item_nota,
  cd_usuario = @cd_usuario,
  dt_usuario = getDate()
from
  nota_saida_item_registro
where
  nota_saida_item.cd_nota_saida = @cd_nota_saida and
  nota_saida_item.cd_item_nota_saida = @cd_item_nota_saida and
  nota_saida_item_registro.cd_nota_saida = @cd_nota_saida and
  nota_saida_item_registro.cd_item_nota_saida = @cd_item_nota_saida

print('Next')
-- APONTANDO PARA NOVO CURSOR
fetch next from cCursor into @cd_item_nota_saida

print('Apagando NotaSaidaRegistro')
-- APAGANDO OS REGISTROS ERRADOS EM NOTA_SAIDA_REGISTRO
delete from 
  nota_saida_registro 
where
  cd_nota_saida = @cd_nota_saida and
  cd_operacao_fiscal not in (select cd_operacao_fiscal 
                             from nota_saida_item_registro
                             where cd_nota_saida = @cd_nota_saida) 

end

close cCursor
deallocate cCursor


