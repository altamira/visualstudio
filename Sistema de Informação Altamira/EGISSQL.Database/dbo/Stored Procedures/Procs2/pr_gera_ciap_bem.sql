
-------------------------------------------------------------------------------
--pr_gera_ciap_bem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Gerar Automaticamente o Ciap para o Bem 
--Data             : 27/01/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_ciap_bem
  @cd_bem       int      = 0,
  @dt_data      datetime = 0
as

declare @cd_tipo_ciap       int
declare @qt_mes_apropriacao int
declare @cd_ciap            int
declare @dt_aquisicao_bem   datetime
declare @cd_usuario         int

-- Pegando o Tipo padrao do CIAP
Select Top 1
  @cd_tipo_ciap = cd_tipo_ciap
From 
  Tipo_CIAP
Where
  ic_padrao_tipo_ciap = 'S'

-- Pegando a Quantidade de Meses Apropriações do Mes
select
  @qt_mes_apropriacao = qt_mes_apropriacao
from
  Coeficiente_Ciap
where
  cd_ano = Year(@dt_data) and
  cd_mes = Month(@dt_data)

--Pegando dados do bem para gerar o calculo do Ciap
select
  @dt_aquisicao_bem = dt_aquisicao_bem,
  @cd_usuario       = cd_usuario
From
  Bem
Where
  cd_bem = @cd_bem

--Selecionando o Bem
insert into
  Ciap(
    cd_ciap, 
    dt_ciap,
    qt_mes_ciap,
    vl_icms_ciap,
    cd_fornecedor,
    cd_operacao_fiscal,
    cd_nota_entrada,
    cd_serie_nota_fiscal, 
    cd_usuario,
    dt_usuario,
    cd_bem,
    dt_entrada_nota_ciap,
    ic_credito_ciap,
    cd_tipo_ciap
  )
Select
  isnull((select max(cd_ciap)+1 from Ciap),1) as cd_ciap,
  @dt_data                                    as dt_ciap,
  isnull(@qt_mes_apropriacao,48)              as qt_mes_ciap,
  vb.vl_icms_bem,
  b.cd_fornecedor,
  b.cd_operacao_fiscal,
  b.cd_nota_entrada,
  b.cd_serie_nota_fiscal,
  b.cd_usuario,
  b.dt_usuario,
  b.cd_bem,
  b.dt_aquisicao_bem,
  'S'                                         as ic_credito_ciap,
  @cd_tipo_ciap                               as cd_tipo_ciap
from
  Bem b
  left join Valor_Bem vb on b.cd_bem = vb.cd_bem
Where
  b.cd_bem = @cd_bem

exec pr_calculo_ciap 0, @dt_aquisicao_bem, @dt_aquisicao_bem, @cd_bem, @cd_usuario, @cd_tipo_ciap 

