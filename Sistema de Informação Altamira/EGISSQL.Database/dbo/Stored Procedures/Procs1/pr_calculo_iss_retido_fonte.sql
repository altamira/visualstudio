
CREATE  PROCEDURE pr_calculo_iss_retido_fonte
--------------------------------------------------------------------------------
--GBS - Global Business Solution              2004
--------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server     2000
--Autor(es)        : Fabio Cesar Magalhães
--Banco de Dados   : EGISSQL
--Objetivo         : Atualizar informações da nota fiscal de serviço para retenção de impostos
--Data             : 29.01.2004
--Atualizações     : 22.09.2004 - Alterações no cálculo do PIS, COFINS e CSLL, descrição logo abaixo. Igor Gama
--                   17/01/2005 - Passa a ler o Teto para a BC do ISS - ELIAS
--                   13/10/2005 - Otimização - ELIAS
--                   24.07.2006 - Saldo do Total da Nota Fiscal para Cálculo no Período - Carlos Fernandes
-- 24.06.2009 - Ajuste Geral - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------

  @cd_nota_saida          int,
  @cd_destinatario        int,
  @cd_tipo_destinatario   int,
  @nm_cidade_destinataria varchar(50),
  @sg_estado_destinatario varchar(2),
  @dt_nota_saida          datetime

AS

begin
 
  --Variáveis para verificação do cliente se é optante do SIMPLES e se o valor esta no TETO estabelecido.
  declare @vl_teto_imp_retido money,
          @vl_teto_iss_retido money,
          @vl_iss_retido      money, 
          @vl_bc_servico      money,
          @vl_nota_fiscal     money,
          @ic_optante_simples char(1),
          @ic_nota_imposto    char(1) --Verifica se o cliente já foi nota com retenção de imposto no período
                                      --Sistema vai calcular independente do valor do Teto

  --Atualiza os campos dos itens da nota de saída onde deverá ser retido o ISS
  declare @cd_dispositivo_legal        int,
          @cd_dispositivo_legal_outros int,
          @cd_estado_destinatario      int,
          @cd_cidade_destinatario      int,
          @cd_estado_empresa           int,
          @cd_cidade_empresa           int,
          @nm_dispositivo_legal        varchar(2000),
          @nm_dispositivo_legal_outros varchar(2000),
          @cd_item_nota_saida          int

  --Demais impostos que são retidos na fonte

  declare @vl_cofins float,
          @vl_pis    float,
          @vl_csll   float

  set @vl_cofins = 0.00
  set @vl_pis    = 0.00
  set @vl_csll   = 0.00

  --Demais impostos que são retidos na fonte -- Embutido por incompatibilidade

  declare 
    @cd_pis    int, --Códigos na tabela de Impostos
    @cd_cofins int,
    @cd_csll   int,
    @pc_pis    money, --Percentuais
    @pc_cofins money,
    @pc_csll   money

  declare 
    @vl_total_nf    money,
    @nm_nf_montante varchar(2000),
    @codigo         int

  set @vl_total_nf = 0.00

  set nocount on 

  if @dt_nota_saida is null
    set @dt_nota_saida = getdate()

  select 
    @ic_optante_simples = isnull(ic_op_simples,'N')
  from 
    vw_destinatario
  where 
    cd_destinatario = @cd_destinatario and cd_tipo_destinatario = @cd_tipo_destinatario

  select @vl_nota_fiscal = sum(isnull((vl_servico * qt_item_nota_saida),0))
  from nota_saida_item with(nolock)
  where cd_nota_saida = @cd_nota_saida

  select 
     @vl_teto_imp_retido = isnull(vl_teto_imposto_retido,0)
  from 
     parametro_faturamento with(nolock)
  where 
     cd_empresa = dbo.fn_empresa()

  --Verifcar o Teto por Imposto -> Modificar
  --Ainda Não está feito
  --Carlos 24.7.2006
  --


  --Dispositivo Legal
  select
    @cd_dispositivo_legal        = cd_dispositivo_iss_ret_fonte,
    @cd_dispositivo_legal_outros = cd_dispositivo_ret_imp
  from 
    Parametro_Faturamento with(nolock)
  where 
    cd_empresa = dbo.fn_empresa()

  select 
    @nm_dispositivo_legal = cast(ds_dispositivo_legal as varchar(2000))
  From 
    Dispositivo_Legal with(nolock)
  where 
    cd_dispositivo_legal = @cd_dispositivo_legal

  select 
    @nm_dispositivo_legal_outros = cast(ds_dispositivo_legal as varchar(2000))
  From 
    Dispositivo_Legal with(nolock)
  where 
    cd_dispositivo_legal = @cd_dispositivo_legal_outros

  --Carrega a cidade e o estado da empresa
  Select @cd_cidade_empresa = cd_cidade,
         @cd_estado_empresa = cd_estado
  from EgisAdmin.dbo.Empresa with(nolock)
  where cd_empresa = dbo.fn_empresa()
  
  --Carrega a cidade e o estado da nota
  Select top 1 @cd_estado_destinatario = cd_estado
  from Estado with(nolock)
  where sg_estado = @sg_estado_destinatario

  Select top 1 @cd_cidade_destinatario = cd_cidade
  from Cidade with(nolock)
  where cd_estado = @cd_estado_destinatario and 
    nm_cidade = @nm_cidade_destinataria
    
  --1º- Verifica se o serviço retem o ISS independente do Município
  select nsi.cd_item_nota_saida,   
    ((nsi.vl_servico * nsi.qt_item_nota_saida) * (nsi.pc_iss_servico / 100)) as vl_iss_servico,
    (nsi.vl_servico * nsi.qt_item_nota_saida) as vl_bc_servico
  into #Servico
  from Nota_Saida_Item nsi with(nolock)
    inner join Servico s on nsi.cd_servico = s.cd_servico           and
                            IsNull(s.ic_retencao_servico,'N') = 'S' and
                            IsNull(ic_rentecao_iss_obrig,'N') = 'S'
  where nsi.cd_nota_saida = @cd_nota_saida --Filtra as notas

  --2º- Verifica se o serviço retem o ISS caso o município de destino venha a ser o mesmo da empresa
  --  - e para este municipio venha a ser necessário

  if ( ( @cd_cidade_empresa = @cd_cidade_destinatario ) and
       ( @cd_estado_empresa = @cd_estado_destinatario ) )
  begin
    Insert into #Servico
    Select nsi.cd_item_nota_saida,
      nsi.vl_iss_servico,
      (nsi.vl_servico * nsi.qt_item_nota_saida)
    from Nota_Saida_Item nsi with(nolock)
      inner join Servico_cidade sc with(nolock) on nsi.cd_servico = sc.cd_servico and
                                                   sc.cd_estado = @cd_estado_destinatario and
                                                   sc.cd_cidade = @cd_cidade_destinatario and
                                                   IsNull(sc.ic_retencao_imposto_servico,'N') = 'S' and
                                                   sc.cd_imposto = 3 --ISS fixo
    where nsi.cd_nota_saida = @cd_nota_saida --Filtra as notas
      and not exists(Select 'x' from #Servico where cd_item_nota_saida = nsi.cd_item_nota_saida )

  end

  --3º - Verificar se o somatório de serviços do destinatário, passa o valor do TETO. Somente
  --     para as notas que não foram cálculados os impostos. Ou seja, pegar o somatório das NF
  --     do destinatário no período da emissão da NF e verifica se houve algum cálculo para o mesmo.
  --     Caso afirmativo, calcular o imposto sobre o somatório e destacar nas informações adicionais
  --     a qual NF foi relacionado a base de cálculo dos impostos. Caso já tenha calculado os impostos
  --     pegar como base a parcela do valor do serviço da NF em questão. Igor Gama - 22.09.2004


  declare @dt_inicio_saldo datetime

  --Verificar 
  --sql  mm/dd/aaaa

  set @dt_inicio_saldo = cast( cast( month(@dt_nota_saida) as varchar(02))+'/01/'+cast( year(@dt_nota_saida) as varchar(4) ) as datetime )

  --delphi dd/mm/aaaa
  --set @dt_inicio_saldo = cast( '01/'+cast( month(@dt_nota_saida) as varchar(02))+'/'+cast( year(@dt_nota_saida) as varchar(4) ) as datetime )

  --select @dt_inicio_saldo

  set @nm_nf_montante = ''
  set @vl_total_nf    = 0.00
	
  --Verifica o saldo do Cliente
    
   select 
     @vl_total_nf     = isnull(dbo.fn_saldo_imposto_nota_retencao(@cd_destinatario,@dt_inicio_saldo,@dt_nota_saida,@cd_nota_saida),0.00)

   select
     @ic_nota_imposto = isnull(dbo.fn_nota_retencao_imposto_periodo(@cd_destinatario,@dt_inicio_saldo,@dt_nota_saida,@cd_nota_saida),'N')

--   select @vl_total_nf,@ic_nota_imposto
 

  --Atualiza os itens da nota de saída    

  begin transaction

    update Nota_Saida_Item
    set ic_iss_servico = 'N'
    where cd_nota_saida = @cd_nota_saida

    --Itens da nota que precisarão ser atualizados
    if exists(Select 'x' from #Servico)
    begin

      update Nota_Saida_Item
      set ic_iss_servico = 'S'
      from Nota_Saida_Item, #Servico 
      where Nota_Saida_Item.cd_nota_saida = @cd_nota_saida and
        Nota_Saida_Item.cd_item_nota_saida = #Servico.cd_item_nota_saida

     select 
       @vl_iss_retido = sum(cast(vl_iss_servico as money)),
       @vl_bc_servico = sum(cast(vl_bc_servico as money))      
     from #Servico

    end
    else
    begin

      set @vl_iss_retido = 0.00
      set @vl_bc_servico = 0.00

    end

    -- Verifica o Teto de ISS específico da Cidade - ELIAS 17/01/2005

    select 
      @vl_teto_iss_retido = isnull(sc.vl_teto_iss_retido,0)
    from 
      Nota_Saida_Item nsi with(nolock)
      inner join Servico_cidade sc with(nolock) on nsi.cd_servico = sc.cd_servico and
                                                   sc.cd_estado = @cd_estado_destinatario and
                                                   sc.cd_cidade = @cd_cidade_destinatario and
                                                   IsNull(sc.ic_retencao_imposto_servico,'N') = 'S' and
                                                   sc.cd_imposto = 3 --ISS fixo
    where nsi.cd_nota_saida = @cd_nota_saida

    -- Caso exista um Valor de Teto, havera ISS somente se os Serviços
    -- Forem Superiores a Este Valor - ELIAS 17/01/2005 - Conf. Lei 5.360 de 17/12/04

    if (isnull(@vl_teto_iss_retido,0)<>0) and
      (@vl_bc_servico < @vl_teto_iss_retido)
      set @vl_iss_retido = 0.00

    if ( @@error != 0 )
      Rollback Transaction
    else
      Commit Transaction

  set nocount  on
 
  /* Igor Gama - 22.09.2004
       De acordo com a Lei nº 10.833, de 29 de Dezembro de 2003, qualquer fonte pagadora que for optante
     pelo SIMPLES, ficará isenta das tributações de PIS/PASEP e CONFIS, onde somente implicará na
     retenção do CSLL sobre 1% na Base de cálculo da parcela de "SERVIÇOS". <== Tabela Imposto

     2.2 - Limitação Imposta pela Lei 10.925/04 
       No art. 5° da  Lei 10.925/2004, que alterou o art. 31 da Lei n° 10.833, de 29 de dezembro de 2003, 
     foi dispensada a retenção das Contribuições Sociais devidas em pagamentos de valor igual ou inferior 
     a R$ 5.000,00 (cinco mil reais). <== Esta no parametro faturamento
       Portanto, somente ocorrerá a retenção sobre os pagamentos de valor superior ao limite estabelecido, 
     observado o critério do item seguinte. 
     
     2.2.1 - Mais de um Pagamento no Mês ao Mesmo Prestador de Serviços
       Conforme determina o § 4º do art. 31 da Lei n° 10.833/04, alterado pelo  art. 5° da  Lei 10.925/2004,  
     quando ocorrer mais de um pagamento no mesmo mês à mesma pessoa jurídica, deve ser efetuada a soma de 
     todos os valores pagos no mês para efeito de cálculo do limite que dispensa a retenção.

     P.S.: Verificar o site abaixo, onde contem maiores informações sobre o mesmo.
       http://www.senar.com.br/html/informativo_legislacao_detalhe.php?id_grupo=3&id_legislacao=308
  */

  --select @ic_optante_simples
  --select @vl_teto_imp_retido
  --select @vl_nota_fiscal,@vl_total_nf

  if ((@ic_optante_simples = 'N') and ( (@vl_nota_fiscal + @vl_total_nf) > @vl_teto_imp_retido)) or ( @ic_nota_imposto = 'S')
  begin

    --Impostos que serão retidos na fonte
    --PIS
    select top 1 @cd_pis    = cd_imposto from imposto where sg_imposto = 'PIS'    order by cd_imposto

    --COFINS
    select top 1 @cd_cofins = cd_imposto from imposto where sg_imposto = 'COFINS' order by cd_imposto

    --CSLL
    select top 1 @cd_csll   = cd_imposto from imposto where sg_imposto = 'CSLL'   order by cd_imposto
	
    --Seleciona a primeira alíquota vigente apartir da data de saída da nota
    --PIS

    select top 1 @pc_pis = IsNull(pc_imposto,0)
    from Imposto_Aliquota with(nolock)
    where cd_imposto = @cd_pis and
      dt_imposto_aliquota <= @dt_nota_saida
    order by dt_imposto_aliquota desc
	
    --COFINS

    select top 1 @pc_cofins = IsNull(pc_imposto,0)
    from Imposto_Aliquota with(nolock)
    where cd_imposto = @cd_cofins and
      dt_imposto_aliquota <= @dt_nota_saida
    order by dt_imposto_aliquota desc
	
    --CSLL
    select top 1 @pc_csll = IsNull(pc_imposto,0)
    from Imposto_Aliquota with(nolock)
    where cd_imposto = @cd_csll and
      dt_imposto_aliquota <= @dt_nota_saida
    order by dt_imposto_aliquota desc
	
    --3º- Verifica se o serviço retém os impostos e já calcula o valor

--    select @pc_pis,@pc_cofins,@pc_csll

    select 
      nsi.cd_nota_saida,
      nsi.cd_item_nota_saida,   
      round(((nsi.vl_servico * nsi.qt_item_nota_saida) * (@pc_pis    / 100)),2) as vl_pis,
      round(((nsi.vl_servico * nsi.qt_item_nota_saida) * (@pc_cofins / 100)),2) as vl_cofins,
      round(((nsi.vl_servico * nsi.qt_item_nota_saida) * (@pc_csll   / 100)),2) as vl_csll
    into 
      #ServicoOutrosImpostos
    from 
      Nota_Saida_Item nsi with(nolock)
      inner join Servico s on nsi.cd_servico = s.cd_servico and isnull(s.ic_retencao_fed_servico,'N') = 'S'
    where
      nsi.cd_nota_saida = @cd_nota_saida --Filtra as notas

    --select * from #ServicoOutrosImpostos
	
    if exists(Select top 1 cd_item_nota_saida from #ServicoOutrosImpostos)
    begin
      select 
        @vl_pis     = sum(cast(isnull(vl_pis,0)    as money)),
        @vl_cofins  = sum(cast(isnull(vl_cofins,0) as money)),
        @vl_csll    = sum(cast(isnull(vl_csll,0)   as money))
      from
        #ServicoOutrosImpostos

      --Atualiza os itens da Nota Fiscal de Saída

      declare @vl_item_pis    money
      declare @vl_item_cofins money
      declare @vl_item_csll   money

      while exists ( select top 1 cd_item_nota_saida from #ServicoOutrosImpostos )
      begin
        select
          @cd_item_nota_saida = cd_item_nota_saida,
          @vl_item_pis        = vl_pis,
          @vl_item_cofins     = vl_cofins,
          @vl_item_csll       = vl_csll
        from
          #ServicoOutrosImpostos
        
        --Atualiza o Valor do PIS/COFINS/CSLL do Item da Nota

        update Nota_Saida_Item
        set
          vl_cofins           = @vl_item_cofins,
          vl_pis              = @vl_item_pis,
          vl_csll             = @vl_item_csll
        where
          @cd_nota_saida      = cd_nota_saida      and
          @cd_item_nota_saida = cd_item_nota_saida
        
        delete from #ServicoOutrosImpostos where
          @cd_nota_saida      = cd_nota_saida and
          @cd_item_nota_saida = cd_item_nota_saida

      end

    end
    else
      select 
        @vl_pis           = 0.00,
        @vl_cofins        = 0.00,
        @vl_csll          = 0.00
	
    set nocount off
  end
  else
    select @vl_pis      = 0.00,
           @vl_cofins   = 0.00,
           @vl_csll     = 0.00

 
 
  --select @cd_destinatario,@dt_inicio_saldo,@dt_nota_saida,dbo.fn_saldo_imposto_nota_retencao(@cd_destinatario,@dt_inicio_saldo,@dt_nota_saida,@cd_nota_saida)

  --Verifica o Total das Notas Anteriores
 
   if isnull(@vl_total_nf,0)>0.00
   begin
      set @vl_pis    = @vl_pis    + round(( @vl_total_nf * (@pc_pis/100)    ),2)
      set @vl_cofins = @vl_cofins + round(( @vl_total_nf * (@pc_cofins/100) ),2)
      set @vl_csll   = @vl_csll   + round(( @vl_total_nf * (@pc_csll/100)   ),2)
   end

  --Mostra os Valores Total

  if (isnull(@vl_iss_retido,0) = 0 )
  begin
    set @nm_dispositivo_legal = ''
  end

  if ((isnull(@vl_cofins,0) = 0 ) and
     (isnull(@vl_pis,0) = 0 ) and
     (isnull(@vl_csll,0) = 0 ) )
  begin
    set @nm_dispositivo_legal_outros = ''
  end

  --Atualiza a Nota Fiscal com o Cálculo da Retenção

  if @vl_cofins > 0 and @vl_pis>0 and @vl_csll >0
  begin
    update
      nota_saida
    set
      ic_imposto_nota_saida = 'S'
    where
      cd_nota_saida = @cd_nota_saida
  end

--Terminar
--Carlos 26.06.2008
--Gravar as notas utilizadas para cálculo (sql)
--Imprimir nos Dados Adicionais (Delphi)
--
--   --Atualização das Nota Seleciondas
-- 
--   delete from nota_saida_acumulada 
--   where
--     cd_nota_saida_origem = @cd_nota_saida
-- 
--   --select * from nota_saida_acumulada
-- 
--   insert into
--     nota_saida_acumulada
--   select
--     @cd_nota_saida,
--     @cd_nota_saida,
--     null,
--     getdate(),
--     'N'  

  --Mostra os Dados Finais para Uso no Faturamento
  --Carlos - 06.07.2010 - Caso der problema em algum cliente - temos que analisar melhor....
  
  set @vl_pis    = 0
  set @vl_cofins = 0
  set @vl_csll   = 0
 
  select
     @vl_total_nf         as vl_total_nf,
     @vl_nota_fiscal      as vl_nota_fiscal,
     @vl_iss_retido       as vl_deducao, 
     isnull(@vl_cofins,0) as vl_cofins,
     isnull(@vl_pis,0)    as vl_pis,
     isnull(@vl_csll,0)   as vl_csll,
 
    rtrim((case when @vl_iss_retido=0  --ISS
           then ''
           else 'ISS de : ' + REPLACE ( cast(@vl_iss_retido as varchar), '.',',')
           end) + ' ' +
    IsNull(@nm_dispositivo_legal,''))     
                                                                   as nm_iss_retido,

     rtrim((case when @vl_cofins = 0 --COFINS
                  then ''
                  else '<COFINS>'
                end) + ' ' +
             (case when @vl_pis = 0  --PIS
                  then ''
                  else '<PIS>'
               end) + ' ' +
             (case when @vl_csll = 0 --CSLL
                   then ''
                   else '<CSLL>'
              end) + ' ' + IsNull(@nm_dispositivo_legal_outros,'')) as nm_outros_impostos_retido


end	

